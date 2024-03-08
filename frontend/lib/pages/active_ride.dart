import 'package:flutter/material.dart';
import 'models/profile.dart';
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
      home: RideScreen(),
    );
  }
}

class RideScreen extends StatefulWidget {
  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
 // Set the user's subscription status here

  

  String _getPaymentMode() {
    // import the isSubscribed variable from the User class 
    // and use it to return the payment mode
    // why is this not working
    User user = User('email', 'firstName', 'lastName', 'phone', true );
    bool isSubscribed = user.isSubscribed;

    if (isSubscribed ) {
      return 'Wallet';
    } else {
      return 'UPI';
    }
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
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Profile
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/profile_picture.jpg'), // Put your image path here
                ),
                SizedBox(height: 10),
                Text(
                  'Raghav',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Ride Status Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Functionality for Ride Status goes here
                },
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
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Library',
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
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                InkWell(
                 // onTap: _toggleSubscription,
                  child: Text(
                    _getPaymentMode(),
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
                  // Functionality to end ride goes here
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
}

      ),
      
    );
  }
}
