import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class WalletHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: WalletBalanceScreen(),
    );
  }
}


class WalletBalanceScreen extends StatelessWidget {
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
            // TODO: Fetch Wallet Balance and display here
            '\₹500.00',
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
                MaterialPageRoute(builder: (context) => TransactionHistoryScreen()),
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

  void openCheckout(){
    var options = {
      "key" : dotenv.env['RAZORPAY_API_KEY'],
      "amount" : num.parse(textEditingController.text)*100,
      "name" : "PedalPal",
      "description" : "Add Balance to your PedalPal Wallet",
      "prefill" : {
        "contact" : "6969696969",
        "email" : "admin@pedalpal.com"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);

    }catch(e){
      print(e.toString());
    }

  }

  void handlerPaymentSuccess(){
    print("Payment success");
    Fluttertoast.showToast(msg : "Payment Success!", toastLength: Toast.LENGTH_SHORT);
  }

  void handlerErrorFailure(){
    print("Pament error");
    Fluttertoast.showToast(msg : "Payment Failed!", toastLength: Toast.LENGTH_SHORT);
  }

  void handlerExternalWallet(){
    print("External Wallet");
    Fluttertoast.showToast(msg : "External Wallet", toastLength: Toast.LENGTH_SHORT);
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
            SizedBox(height: 12,),
            ElevatedButton(
              child: Text("Add Balance", style: TextStyle(
                  color: Colors.blueAccent
              ),),
              onPressed: (){
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
