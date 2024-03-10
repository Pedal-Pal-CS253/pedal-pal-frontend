import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/feedback_submitted.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/pages/alerts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IssueReportingScreen(issues: []),
    );
  }
}

class IssueReportingScreen extends StatefulWidget {
  final List<bool> issues;

  const IssueReportingScreen({Key? key, required this.issues})
      : super(key: key);

  @override
  _IssueReportingScreenState createState() => _IssueReportingScreenState();
}

class _IssueReportingScreenState extends State<IssueReportingScreen> {
  final TextEditingController _textFieldController = TextEditingController();

  Future<http.Response> _submitIssue(
      List<bool> issues, String description) async {
    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'maintenance/feedbacks/add/',
    );

    FlutterSecureStorage storage = FlutterSecureStorage();
    var token = await storage.read(key: 'auth_token');

    var body = jsonEncode({
      'air_issues': issues[0],
      'sound_issues': issues[1],
      'brake_issues': issues[2],
      'chain_issues': issues[3],
      'detailed_issues': description
    });

    LoadingIndicatorDialog().show(context);
    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
      body: body,
    );
    LoadingIndicatorDialog().dismiss();
    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeedbackSubmitted()),
      );
    } else {
      AlertPopup().show(context, text: response.body);
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.0),
              Row(
                children: [
                  SizedBox(width: 16.0),
                  Text(
                    'Issue Reporting',
                    style: TextStyle(color: Colors.black, fontSize: 24.0),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'DESCRIBE THE ISSUE',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Let us know the exact problem you faced.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                labelText: 'Type here ...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submitIssue(widget.issues, _textFieldController.text);
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 15, 27),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
