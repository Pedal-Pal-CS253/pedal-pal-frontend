import 'package:flutter/material.dart';
import 'package:frontend/pages/describe_issue.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IssuesWithCycle(),
    );
  }
}

class IssuesWithCycle extends StatelessWidget {
  const IssuesWithCycle({Key? key}) : super(key: key);

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
                    'Issues with the cycle',
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Issues with Cycle',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 6, 11)),
            ),
            SizedBox(height: 10),
            Text(
              'Knowing about your issues will help us in maintenance',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IssueItem(title: 'Tires low on air'),
                IssueItem(title: 'Sounds while riding'),
                IssueItem(title: 'Malfunctioning brakes'),
                IssueItem(title: 'Chain fallen off'),
                IssueItem(title: 'Other'),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ((IssueReportingScreen()))),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color.fromARGB(255, 16, 138, 237),
                ),
                child: Text('Continue', style: TextStyle(fontSize: 16, color: Colors.black54)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IssueItem extends StatefulWidget {
  final String title;

  const IssueItem({Key? key, required this.title}) : super(key: key);

  @override
  _IssueItemState createState() => _IssueItemState();
}

class _IssueItemState extends State<IssueItem> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Grey background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(widget.title),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isSelected = !_isSelected;
              });
            },
            child: Container(
              width: 24,
              height: 35,
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
                color: _isSelected ? Colors.blue : Colors.transparent,
              ),
              child: _isSelected
                  ? Icon(Icons.check, size: 20, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}