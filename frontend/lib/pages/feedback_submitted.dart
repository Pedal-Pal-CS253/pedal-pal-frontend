import 'package:flutter/material.dart';



class FeedbackSubmitted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.0),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      'Feedback Submitted',
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
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Container(
            width: 400,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton(
                //   icon: Icon(Icons.arrow_back),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
                Image.asset(
                  'assets/confirmation.png', // Path to your feedback image
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Feedback Submitted!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'We appreciate your feedback.\nOur team will promptly address the issue.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
