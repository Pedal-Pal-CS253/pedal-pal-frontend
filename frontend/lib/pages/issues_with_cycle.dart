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

class IssuesWithCycle extends StatefulWidget {
  const IssuesWithCycle({Key? key}) : super(key: key);

  @override
  _IssuesWithCycleState createState() => _IssuesWithCycleState();
}

class _IssuesWithCycleState extends State<IssuesWithCycle> {
  List<bool> selectedIssues = [false, false, false, false];

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
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 6, 11)),
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
                IssueItem(
                    title: 'Tires low on air',
                    isSelected: selectedIssues[0] == true,
                    onTap: () => toggleIssueSelection(0)),
                IssueItem(
                    title: 'Sounds while riding',
                    isSelected: selectedIssues[1] == true,
                    onTap: () => toggleIssueSelection(1)),
                IssueItem(
                    title: 'Malfunctioning brakes',
                    isSelected: selectedIssues[2] == true,
                    onTap: () => toggleIssueSelection(2)),
                IssueItem(
                    title: 'Chain fallen off',
                    isSelected: selectedIssues[3] == true,
                    onTap: () => toggleIssueSelection(3)),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            IssueReportingScreen(issues: selectedIssues)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color.fromARGB(255, 16, 138, 237),
                ),
                child: Text('Continue',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleIssueSelection(int issue) {
    setState(() {
      if (selectedIssues[issue]) {
        selectedIssues[issue] = false;
      } else {
        selectedIssues[issue] = true;
      }
    });
  }
}

class IssueItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const IssueItem(
      {Key? key,
      required this.title,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title),
              ),
              GestureDetector(
                child: Container(
                  width: 24,
                  height: 35,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    color: isSelected ? Colors.blue : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 20, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
        )
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Expanded(
        //         child: Text(
        //           title,
        //           style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        //         ),
        //       ),
        //       isSelected
        //           ? Icon(Icons.check, color: Colors.white)
        //           : SizedBox(), // Empty SizedBox to maintain the layout
        //     ],
        //   ),
        // ),
        );
  }
}
