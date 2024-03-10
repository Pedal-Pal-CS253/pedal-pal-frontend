import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/alerts.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/pages/reg_login_forgot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/profile.dart';


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
      TextSelection.fromPosition(TextPosition(offset: this.text.length));
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var user = User("loading", "loading", "loading", "loading", false);
  late CustomTextEditingController _nameController;
  late CustomTextEditingController _emailController;
  late CustomTextEditingController _phoneController;
  late CustomTextEditingController _subscriptionController;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

_getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('user');
    if (userData != null) {
      print(userData);
      setState(() {
        user = User.fromJson(jsonDecode(userData));
      });
    }
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
                  onPressed: () {
                    sendRegistrationRequest(
                      context,
                      user.email,
                      user.phone,
                      user.firstName,
                      user.lastName
                    );
                  },
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
                    // Splitting the full name into first name and last name
                    var nameParts = value.split(' ');
                    if (nameParts.length >= 2) {
                      // Updating user's first name and last name separately
                      user.firstName = nameParts[0];
                      user.lastName = nameParts.sublist(1).join(' '); // Joining remaining parts as last name
                    } else {
                      // If only one name is entered, consider it as first name
                      user.firstName = value;
                      user.lastName = ''; // Resetting last name
                    }
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
              ),
            ),
            SizedBox(height: 24.0),
            if (user.isSubscribed == false)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
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

  Future<http.Response> sendRegistrationRequest(
      BuildContext context, String email, String phone, String firstName, String lastName) async {
    // TODO: change host
    var uri = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      path: 'auth/register/',
      port: 8000,
    );

    var body = jsonEncode({
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName
    });

    LoadingIndicatorDialog().show(context);
    // TODO: add OTP validation
    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 200) {
      Navigator.pushNamed(
          context, '/login'); // TODO: go to account created page
    } else {
      AlertPopup().show(context, text: response.body);
    }

    return response;
  }
}
