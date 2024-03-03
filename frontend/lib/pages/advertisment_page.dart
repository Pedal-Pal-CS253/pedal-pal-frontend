import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Membership Subscription',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MembershipSubscriptionPage(),
    );
  }
}

class MembershipSubscriptionPage extends StatefulWidget {
  @override
  _MembershipSubscriptionPageState createState() => _MembershipSubscriptionPageState();
}

class _MembershipSubscriptionPageState extends State<MembershipSubscriptionPage> {
  int selectedPlan = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Subscription'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.0),
          Text(
            'Become a subscribed member today!',
            style: TextStyle(
              fontSize: 28.0, // Slightly larger font
              fontWeight: FontWeight.bold,
              color: Colors.black, // Black font color
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Perks of Membership', // Line above perks
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.blue, // Blue font color
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Advance Booking Option | Wallet Facilities',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 20.0),
          _buildMembershipPlan(
            '₹ 200.00 / YEAR',
            '12 month membership',
            'Best Deal - 44%',
            0,
            Colors.blue,
          ),
          SizedBox(height: 20.0),
          _buildMembershipPlan(
            '₹ 120.00 / 6 MONTHS',
            '6 month membership',
            '',
            1,
            Colors.blue,
          ),
          SizedBox(height: 20.0),
          _buildMembershipPlan(
            '₹ 30.00 / MONTH',
            '1 month membership',
            '',
            2,
            Colors.blue,
          ),
          Spacer(),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Action for starting the trial
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.blue.withOpacity(0.3), // Black text color
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0), // Increased width
              textStyle: TextStyle(fontSize: 18.0),
            ),
            child: Text('Start a 7 day trial'),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildMembershipPlan(String price, String duration, String tag, int index, Color color) {
    bool isSelected = selectedPlan == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey), // Change border color if selected
          borderRadius: BorderRadius.circular(15.0), // Curved corners
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white, // Change background color if selected
        ),
        child: Row(
          children: [
            Container(
              width: 30.0,
              height: 30.0,
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.white : Colors.grey), // Change tick color if selected
                color: isSelected ? Colors.blue : Colors.white, // Change tick background color if selected
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white, // White tick color
                      size: 20.0,
                    )
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black text color
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black, // Black text color
                    ),
                  ),
                  SizedBox(height: 5.0),
                  if (tag.isNotEmpty && isSelected)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
