import 'package:flutter/material.dart';
import 'package:frontend/pages/feedback_submitted.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IssueReportingScreen(),
    );
  }
}

class IssueReportingScreen extends StatelessWidget {
  const IssueReportingScreen({Key? key}) : super(key: key);

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
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Let us know the exact problem you faced.',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,
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
                  MaterialPageRoute(
                      builder: (context) => ((FeedbackSubmitted()))),
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
    );
  }
}
