import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController subscriptionController = TextEditingController();

  bool trialStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            // Implement back button functionality here
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Profile Picture',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton.icon(
              onPressed: () {
                // Implement edit profile functionality here
                setState(() {
                  nameController.text = ''; // clear existing text
                  emailController.text = '';
                  phoneController.text = '';
                  subscriptionController.text = '';
                });
              },
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              ),
            ),
            SizedBox(height: 20.0),
            Divider(
              color: Colors.grey[400],
              thickness: 1.0,
              height: 20,
              indent: 20,
              endIndent: 20,
            ),
            UserInfoItem(label: 'Name', controller: nameController),
            UserInfoItem(label: 'Email', controller: emailController),
            UserInfoItem(label: 'Phone', controller: phoneController),
            UserInfoItem(
              label: 'Subscription Status',
              controller: subscriptionController,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  trialStarted = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Start a 7 day trial',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 16, 25, 74),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(300, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  UserInfoItem({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                // Implement functionality to handle text changes
              },
            ),
          ),
        ],
      ),
    );
  }
}
