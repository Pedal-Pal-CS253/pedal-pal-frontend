import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/profile.dart';
import 'package:frontend/pages/qr_scanner.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alerts.dart';

final double costPerMinute = 1.0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Service UI',
      theme: ThemeData(
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

    if (userData == null || startTimeData == null || startHubData == null) {
      getUserDetails();
    }

    if (userData != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userData));
      });
    }
    if (startTimeData != null) {
      setState(() {
        startTime = DateTime.parse(startTimeData).toLocal();
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
              SizedBox(height: 8),
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
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile_photo.png'),
                ),
                SizedBox(height: 10),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 40),
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
            SizedBox(height: 40),
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
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Payment Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  child: Text(
                    user.isSubscribed ? 'Wallet' : 'UPI',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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

  void endRide() async {
    var response = await showConfirmationDialog(context, 'End Ride?',
        'You will have to pay ₹${calculateCurrentAmount().toString()}');
    if (response == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const QRViewExample(mode: 'end'),
        ),
      );
    }
  }
}
