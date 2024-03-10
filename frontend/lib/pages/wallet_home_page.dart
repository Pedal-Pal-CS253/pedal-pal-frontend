import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/pages/alerts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class WalletHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: WBS(),
    );
  }
}

class WBS extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WalletBalanceScreen();
}

class WalletBalanceScreen extends State<WBS> {
  var balance = "Loading...";

  Future<void> fetchBalance() async {
    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'payment/get_balance/',
    );

    FlutterSecureStorage storage = FlutterSecureStorage();
    var token = await storage.read(key: 'auth_token');

    print("Using token $token");

    var response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Authorization": "Token $token",
    });

    print(response);

    if (response.statusCode == 200) {
      balance = '₹${jsonDecode(response.body)['balance']}';
      setState(() {});
    } else {
      print("error: ${response.body}");
    }
  }

  void init() async {
    await fetchBalance();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Balance:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            balance,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ABS()),
              );
            },
            child: Text('Add Balance'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransactionHistoryScreen()),
              );
            },
            child: Text('View Transaction History'),
          ),
        ],
      ),
    );
  }
}

class ABS extends StatefulWidget {
  @override
  AddBalanceScreen createState() => AddBalanceScreen();
}

class AddBalanceScreen extends State<ABS> {
  Razorpay razorpay = Razorpay();
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": dotenv.env['RAZORPAY_API_KEY'],
      "amount": num.parse(textEditingController.text) * 100,
      "name": "PedalPal",
      "description": "Add Balance to your PedalPal Wallet",
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

    var body = jsonEncode({'amount': num.parse(textEditingController.text)});
    var token = await FlutterSecureStorage().read(key: 'auth_token');

    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Payment Successful!");
    } else {
      Fluttertoast.showToast(msg: "Payment successful but failed to update database! Please contact support team.");
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Balance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextFormField(
              controller: textEditingController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                hintText: '0.00',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                return null;
              },
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedButton(
              child: Text(
                "Add Balance",
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: () {
                openCheckout();
              },
            )
          ],
        ),
      ),
    );
  }
}

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Transaction History',
              style: TextStyle(fontSize: 20),
            ),
            // TODO: To fetch the transaction history and display here
          ],
        ),
      ),
    );
  }
}