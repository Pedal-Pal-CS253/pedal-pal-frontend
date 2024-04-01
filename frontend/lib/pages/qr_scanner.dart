import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/models/hubs.dart';
import 'package:frontend/pages/active_ride.dart';
import 'package:frontend/pages/issues_with_cycle.dart';
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
                    'Scan the QR on the Lock',
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
          SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                    const Text('Scan a Code'),
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
                              return (snapshot.data!)
                                  ? Icon(
                                      Icons.flash_on,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.flash_off,
                                      color: Colors.black,
                                    );
                            },
                          ),
                        ),
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
                              return (snapshot.data == 'front')
                                  ? Icon(
                                      Icons.camera_front,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.camera_rear,
                                      color: Colors.black,
                                    );
                            },
                          ),
                        ),
                      ),
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

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tell Us About Your Experience"),
          content: Text("Would you like to tell us about your ride?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => IssuesWithCycle()),
                  (route) => false,
                );
              },
              child: Text("Sure"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Dashboard()),
                  (route) => false,
                );
              },
              child: Text("Later"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
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
      var startTime =
          DateTime.parse(pref.getString('ride_start_time')!).toLocal();
      cost = DateTime.now().difference(startTime).inMinutes;
      if (cost == 0) cost = 1;

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

    await getUserDetails();

    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: 'Ride ended successfully!');
      _showFeedbackDialog();
    } else {
      var jsonResponse = jsonDecode(response.body);
      Fluttertoast.showToast(
          msg:
              '${jsonResponse[jsonResponse.keys.first].toString()}');
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

    await getUserDetails();

    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 201) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('ride_start_time', DateTime.now().toString());
      preferences.setString(
          'ride_start_hub', hubIdName[jsonDecode(response.body)['start_hub']]!);
      Fluttertoast.showToast(msg: 'Ride started successfully!');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RideScreen()),
      );
    } else {
      var jsonResponse = jsonDecode(response.body);
      Fluttertoast.showToast(
          msg:
              "${jsonResponse[jsonResponse.keys.first].toString()}");
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

    await getUserDetails();

    SharedPreferences preferences = await SharedPreferences.getInstance();

    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: 'Ride ended successfully!');
      preferences.remove('ride_start_time');
      preferences.remove('ride_start_hub');
      _showFeedbackDialog();
    } else {
      var jsonResponse = jsonDecode(response.body);
      Fluttertoast.showToast(
          msg:
              '${jsonResponse[jsonResponse.keys.first].toString()}');
      Navigator.pop(context);
    }
  }

  void handlePaymentFailure(PaymentFailureResponse instance) {}
}
