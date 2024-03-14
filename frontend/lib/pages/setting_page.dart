import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/profile.dart';
import 'map_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingPage(),
    );
  }
}

// Custom text controller to prevent cursor from moving to the front
class CustomTextEditingController extends TextEditingController {
  CustomTextEditingController({String text = ''}) : super(text: text);

  @override
  TextSelection get selection =>
      TextSelection.fromPosition(TextPosition(offset: text.length));
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late User user;

  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    user = User('email', 'firstName', 'lastName', 'phone', true);
    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);

    _updateProfile();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": dotenv.env['RAZORPAY_API_KEY'],
      "amount": num.parse('100') * 100,
      "name": "PedalPal",
      "description": "Subscribe to Pedal Pal",
      "prefill": {"contact": "6969696969", "email": "admin@pedalpal.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse instance) async {
    debugPrint("Payment success");
    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'payment/update_balance/',
    );

    var body = jsonEncode({'amount': num.parse('80')}); // Subscription Fee
    var token = await FlutterSecureStorage().read(key: 'auth_token');

    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: body,
    );

    var body2 = jsonEncode({'value': true});
    var uri2 = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'auth/subscribe/',
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Payment Successful!");

      var response2 = await http.post(
        uri2,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: body2,
      );

      print(response2.body);

      if (response2.statusCode == 200) {
        Fluttertoast.showToast(msg: "You are subscribed successfully!");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Dashboard()),
              (route) => false,
        );
      } else {
        Fluttertoast.showToast(
            msg:
            "Payment successful but failed to subscribe! Please contact support team.");
      }

    } else {
      Fluttertoast.showToast(
          msg:
          "Payment successful but failed to update database! Please contact support team.");
    }
  }

  void handlerErrorFailure() {
    debugPrint("Payment error");
    Fluttertoast.showToast(
        msg: "Payment Failed!", toastLength: Toast.LENGTH_SHORT);
  }

  void handlerExternalWallet() {
    debugPrint("External Wallet");
    Fluttertoast.showToast(
        msg: "External Wallet", toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> _updateProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user = User.fromJson(jsonDecode(preferences.getString('user')!));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Disable back arrow
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 24.0),
                  ),
                ),
              ),
              SizedBox(width: 48.0), // Add space to the right of the text
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 160.0,
                    height: 160.0,
                    child:
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/profile_photo.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          // Open dialogue box here
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'NAME',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                '${user.firstName} ${user.lastName}',
                style: TextStyle(fontSize: 20.0),
              ),
              ),
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'EMAIL',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                user.email,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'PHONE',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                user.phone,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'SUBSCRIPTION STATUS',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                user.isSubscribed ? 'Subscribed' : 'Not Subscribed',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 24.0),
            if (!user.isSubscribed)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () => openCheckout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1a2758),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Increased border radius
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                    ),
                    child: Text(
                      'Subscribe for Additional Benefits!',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
