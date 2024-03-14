import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/profile.dart';
import 'package:frontend/pages/qr_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final double costPerMinute = 1.0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Service UI',
      theme: ThemeData(
        // Set background color as desired
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: RideScreen(),
    );
  }
}

class RideScreen extends StatefulWidget {
  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  var user = User("loading", "loading", "loading", "loading", false);
  var startTime = DateTime.now();
  var startHub = "Loading";

  @override
  void initState() {
    super.initState();
    // Retrieve the user information from shared_preferences
    _getUserInfo();
  }

  void _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('user');
    var startTimeData = prefs.getString('ride_start_time');
    var startHubData = prefs.getString('ride_start_hub');
    print(userData);
    print(startTimeData);
    print(startHubData);
    if (userData != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userData));
      });
    }
    if (startTimeData != null) {
      setState(() {
        startTime = DateTime.parse(startTimeData);
      });
    }
    if (startHubData != null) {
      setState(() {
        startHub = startHubData;
      });
    }
  }

  int calculateRideDuration() {
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(startTime);
    return difference.inMinutes;
  }

  double calculateCurrentAmount() {
    int duration = calculateRideDuration();
    return duration * costPerMinute;
  }

  String getFDT(DateTime dt) {
    var formatterDate = DateFormat("dd MMM yyyy");
    var formatterTime = DateFormat('hh:mm a');
    return formatterDate.format(dt) + "    " + formatterTime.format(dt);
  }

  void _showRideStatusDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Ride Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Ride Duration:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${calculateRideDuration()} minutes",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8), // Adjust spacing as needed
              Text(
                "Current Amount:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "₹${calculateCurrentAmount().toStringAsFixed(2)}",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
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
            // User Profile
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage(
                  //     'assets/profile_picture.jpg'), // Put your image path here
                ),
                SizedBox(height: 10),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Ride Status Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showRideStatusDialog,
                child: Text(
                  'Ride Status',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 248, 246, 246)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40), // Increased vertical space
            // Start Hub
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Start Hub',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  startHub,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 40), // Increased vertical space
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ride Start Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  getFDT(startTime),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 40), // Increased vertical space
            // Payment Mode
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Payment Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  // onTap: _toggleSubscription,
                  child: Text(
                    user.isSubscribed ? 'Wallet' : 'UPI',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            // Ride Status Button
            SizedBox(height: 20),
            // End Ride Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  endRide();
                },
                child: Text(
                  'End Ride',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 248, 246, 246)),
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

  Future<bool> showAlertDialog(BuildContext context, String cost) async {
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("End Ride?"),
      content: Text("You will have to pay ₹$cost."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return result ?? false;
  }

  void endRide() async {
    var response =
        await showAlertDialog(context, calculateCurrentAmount().toString());
    if (response == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const QRViewExample(mode: 'end'),
        ),
      );
    }
  }
}
