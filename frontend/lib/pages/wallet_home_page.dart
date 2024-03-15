import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/payment.dart';
import 'map_page.dart';

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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text('Add Balance',
                style: TextStyle(
                  color: Colors.white,
                )
            ),
          ),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => THS()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 88, 83, 154),
            ),
            child: Text('View Transaction History',
                style: TextStyle(
                  color: Colors.white,
                )
            ),
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

    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
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
      Fluttertoast.showToast(
          msg:
              "Payment successful but failed to update database! Please contact support team.");
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false,
    );
  }

  void handlerErrorFailure() {
    debugPrint("Payment error");
    Fluttertoast.showToast(
        msg: "Payment Failed!", toastLength: Toast.LENGTH_SHORT);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false,
    );
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                "Add Balance",
                style: TextStyle(color: Colors.white),
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

class THS extends StatefulWidget {
  @override
  TransactionHistoryScreen createState() => TransactionHistoryScreen();
}

class TransactionHistoryScreen extends State<THS> {
  Future<List<Transaction>> getTransactions() async {
    List<Transaction> data = [];

    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'payment/get_transactions/',
    );

    var token = await FlutterSecureStorage().read(key: 'auth_token');

    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );

    print(response.body);

    Iterable transactions = json.decode(response.body);

    for (var transaction in transactions) {
      var temp = Transaction(
          transaction['status'].toString(),
          num.parse(transaction['amount'].toString()).toInt(),
          DateTime.parse(transaction['time']));
      data.add(temp);
    }

    return data;
  }

  String getFDT(DateTime dt) {
    var formatterDate = DateFormat("dd MMM yyyy");
    var formatterTime = DateFormat('hh:mm a');
    return formatterDate.format(dt) + "     " + formatterTime.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var transaction = snapshot.data![index];
                Color backgroundColor =
                    transaction.type == "CREDIT" ? Colors.green : Colors.red;
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: backgroundColor,
                      child: Icon(
                        Icons.currency_rupee,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Amount: ₹${transaction.amount.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${getFDT(transaction.date)}',
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No transactions found!'),
            );
          }
        },
      ),
    );
  }
}
