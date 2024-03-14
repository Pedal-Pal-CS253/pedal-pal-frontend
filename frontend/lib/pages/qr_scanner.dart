import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/pages/active_ride.dart';
import 'package:frontend/pages/map_page.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';
import 'alerts.dart';

class QRViewExample extends StatefulWidget {
  final String mode;

  const QRViewExample({Key? key, required this.mode}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState(mode);
}

class _QRViewExampleState extends State<QRViewExample> {
  final String mode;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Razorpay razorpay = Razorpay();
  var cost = 0;

  _QRViewExampleState(this.mode) : super();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.0),
              Row(
                children: [
                  SizedBox(width: 16.0),
                  Text(
                    'Scan the QR on the cycle',
                    style: TextStyle(color: Colors.black, fontSize: 24.0),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(
                            result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(
                                          snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery
        .of(context)
        .size
        .width < 400 ||
        MediaQuery
            .of(context)
            .size
            .height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      setState(() {
        result = scanData;
        // scanData has lock id
        sendRequest(result?.code);
      });
      print(result);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void sendRequest(String? lock) async {
    if (mode == 'book') {
      sendRideNowRequest(lock);
    }
    if (mode == 'end') {
      sendEndRideRequest(lock);
    }
  }

  void sendEndRideRequest(lock) async {
    // check if user is subscribed first
    // if user is not subscribed, do payment first then come here.
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = User.fromJson(jsonDecode(preferences.getString('user')!));
    if (!user.isSubscribed) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var startTime = DateTime.parse(pref.getString('ride_start_time')!);
      cost = DateTime
          .now()
          .difference(startTime)
          .inMinutes;

      var options = {
        "key": dotenv.env['RAZORPAY_API_KEY'],
        "amount": cost * 100,
        "name": 'PedalPal',
        "description": "Add Balance to your PedalPal Wallet",
        "prefill": {"contact": "6969696969", "email": "admin@pedalpal.com"},
        "external": {
          "wallets": ["paytm"]
        },
      };

      try {
        razorpay.open(options);
      } catch (e) {
        print(e.toString());
      }
      return;
    }

    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'booking/end/',
    );

    var body = jsonEncode({
      'id': lock,
    });

    FlutterSecureStorage storage = FlutterSecureStorage();
    var token = await storage.read(key: 'auth_token');

    LoadingIndicatorDialog().show(context);

    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: body,
    );

    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: 'Ride ended successfully!');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
            (route) => false,
      );
    } else {
      Fluttertoast.showToast(msg: 'There was an error! ${response.body}');
      Navigator.pop(context);
    }
  }

  void sendRideNowRequest(String? lock) async {
    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'booking/book/',
    );

    var body = jsonEncode({
      'cycle': lock, // TODO: change to lock
    });

    FlutterSecureStorage storage = FlutterSecureStorage();
    var token = await storage.read(key: 'auth_token');

    LoadingIndicatorDialog().show(context);

    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: body,
    );

    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 201) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('ride_start_time', DateTime.now().toString());
      preferences.setString(
          'ride_start_hub', jsonDecode(response.body)['start_hub'].toString());
      Fluttertoast.showToast(msg: 'Ride started successfully!');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RideScreen()),
      );
    } else {
      Fluttertoast.showToast(msg: "There was an error! ${response.body}");
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void handlePaymentSuccess(PaymentSuccessResponse instance) async {
    LoadingIndicatorDialog().show(context);

    FlutterSecureStorage storage = FlutterSecureStorage();
    var token = await storage.read(key: 'auth_token');

    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'payment/add_payment/',
    );

    var body = jsonEncode({
      'amount': cost,
    });

    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: body,
    );

    var paymentId = jsonDecode(response.body)['id'];

    var lock = result?.code;

    uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'booking/end/',
    );

    body = jsonEncode({
      'id': lock,
      'payment_id': paymentId,
    });


    response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: body,
    );

    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: 'Ride ended successfully!');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
            (route) => false,
      );
    } else {
      Fluttertoast.showToast(msg: 'There was an error! ${response.body}');
      Navigator.pop(context);
    }
  }

  void handlePaymentFailure(PaymentFailureResponse instance) {
  }
}
