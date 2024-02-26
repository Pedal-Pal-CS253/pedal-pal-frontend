import 'package:flutter/material.dart';
import 'package:frontend/pages/feedback_submitted.dart';

void main() {
  runApp(DescribeIssue());
}

class DescribeIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Issue Reporting',
      theme: ThemeData(
        primaryColor: Colors.white,
        hintColor: Colors.green,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      home: IssueReportingScreen(),
    );
  }
}

class IssueReportingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issue Reporting'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'DESCRIBE THE ISSUE',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Let us know the exact problem you faced.',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Type here ...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ((FeedbackSubmitted()))),
                  );
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
      ),
    );
  }
}
