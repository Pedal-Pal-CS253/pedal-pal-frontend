import 'package:flutter/material.dart';
import 'package:frontend/pages/reg_login_forgot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Service UI',
      theme: ThemeData(
        // Set background color as desired
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: RideScreen(user: user),
    );
  }
}

class RideScreen extends StatefulWidget {
  final User user;

  RideScreen({required this.user});
  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  late User user;
  String _paymentMode = '';

  get prefs => SharedPreferences.getInstance();

  @override
  Future<void> initState() async{
    super.initState();
    _getPaymentMode();
  }

  Future<void> _getPaymentMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSubscribed = user.isSubscribed ?? false;
    String user_first = prefs.getString('user_first_name')!;
    print(user_first);
    setState(() {
      _paymentMode = isSubscribed ? 'Wallet' : 'UPI';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Service'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage('assets/profile_picture.jpg'),
                  backgroundColor: Colors.cyan,
                ),
                SizedBox(height: 10),
                Text(
                  user.firstName + user.lastName,
                  // 'Rag',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Functionality for Ride Status goes here
                },
                child: Text(
                  'Ride Status',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 248, 246, 246),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Start Hub',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Library',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Payment Mode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _paymentMode,
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Functionality to end ride goes here
                },
                child: Text(
                  'End Ride',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 248, 246, 246),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}