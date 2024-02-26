import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HistoryPage(),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<HistoryData> historyDataList = [
    HistoryData(
      startLocation: 'Hall 2',
      startTime: '12:02',
      startDate: '24 Feb',
      endLocation: 'DJAC',
      endTime: '13:02',
      endDate: '25 Feb',
      duration: '1h 0m',
    ),
    HistoryData(
      startLocation: 'RM',
      startTime: '10:30',
      startDate: '25 Feb',
      endLocation: 'Hall 2',
      endTime: '12:00',
      endDate: '25 Feb',
      duration: '1h 30m',
    ),
    // Add more HistoryData objects as needed
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate total time used
    Duration totalTimeUsed = Duration();
    historyDataList.forEach((data) {
      List<String> timeParts = data.duration.split(' ');
      int hours = int.parse(timeParts[0].replaceAll('h', ''));
      int minutes = int.parse(timeParts[1].replaceAll('m', ''));
      totalTimeUsed += Duration(hours: hours, minutes: minutes);
    });

    String formattedTotalTimeUsed =
        '${totalTimeUsed.inHours}h ${totalTimeUsed.inMinutes.remainder(60)}m';

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
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    'History',
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Time Used: $formattedTotalTimeUsed',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: historyDataList.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: HistoryPane(
                          startLocation: data.startLocation,
                          startTime: data.startTime,
                          startDate: data.startDate,
                          endLocation: data.endLocation,
                          endTime: data.endTime,
                          endDate: data.endDate,
                          duration: data.duration,
                        ),
                      );
                    }).toList(),
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

class HistoryPane extends StatelessWidget {
  final String startLocation;
  final String startTime;
  final String startDate;
  final String endLocation;
  final String endTime;
  final String endDate;
  final String duration;

  HistoryPane({
    required this.startLocation,
    required this.startTime,
    required this.startDate,
    required this.endLocation,
    required this.endTime,
    required this.endDate,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFC1E2F1),
      ),
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLocationCircle(startLocation),
                SizedBox(height: 8),
                Text(
                  startLocation,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  startDate,
                  style: TextStyle(color: Color(0xFF8B97AC)),
                ),
                Text(
                  startTime,
                  style: TextStyle(color: Color(0xFF8B97AC)),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  duration,
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  endDate,
                  style: TextStyle(color: Color(0xFF8B97AC)),
                ),
                Text(
                  endTime,
                  style: TextStyle(color: Color(0xFF8B97AC)),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLocationCircle(endLocation),
                SizedBox(height: 8),
                Text(
                  endLocation,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCircle(String location) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF8EC1DC),
      ),
    );
  }
}

class HistoryData {
  final String startLocation;
  final String startTime;
  final String startDate;
  final String endLocation;
  final String endTime;
  final String endDate;
  final String duration;

  HistoryData({
    required this.startLocation,
    required this.startTime,
    required this.startDate,
    required this.endLocation,
    required this.endTime,
    required this.endDate,
    required this.duration,
  });
}
