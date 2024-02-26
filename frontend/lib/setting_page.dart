import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingPage(),
    );
  }
}

class User {
  String name;
  String email;
  String phone;
  String subscriptionStatus;
  bool isEligible;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.subscriptionStatus,
    required this.isEligible,
  });
}

// Custom text controller to prevent cursor from moving to the front
class CustomTextEditingController extends TextEditingController {
  CustomTextEditingController({String text = ''}) : super(text: text);

  @override
  TextSelection get selection => TextSelection.fromPosition(TextPosition(offset: this.text.length));
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late User user;
  late CustomTextEditingController _nameController;
  late CustomTextEditingController _emailController;
  late CustomTextEditingController _phoneController;
  late CustomTextEditingController _subscriptionController;

  @override
  void initState() {
    super.initState();
    user = User(
      name: 'Debraj',
      email: 'debraj2003jsr@gmail.com',
      phone: '9470961409',
      subscriptionStatus: 'Inactive',
      isEligible: true, // Set the eligibility status here
    );
    _nameController = CustomTextEditingController(text: user.name);
    _emailController = CustomTextEditingController(text: user.email);
    _phoneController = CustomTextEditingController(text: user.phone);
    _subscriptionController = CustomTextEditingController(text: user.subscriptionStatus);
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
                    'Settings',
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
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Profile Picture',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 160.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    alignment: Alignment.center,
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
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                ),
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    user.name = value;
                  });
                },
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    user.email = value;
                  });
                },
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _phoneController,
                onChanged: (value) {
                  setState(() {
                    user.phone = value;
                  });
                },
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _subscriptionController,
                onChanged: (value) {
                  setState(() {
                    user.subscriptionStatus = value;
                  });
                },
              ),
            ),
            SizedBox(height: 24.0),
            if (user.isEligible)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF1a2758),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Increased border radius
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    ),
                    child: Text(
                      'Start a 7 day trial',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
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
