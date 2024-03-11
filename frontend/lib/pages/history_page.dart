import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryData> historyDataList = [];

  Future<void> historyRequest() async {
    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app',
      path: 'analytics/history/',
    );

    FlutterSecureStorage storage = FlutterSecureStorage();
    var token = await storage.read(key: 'auth_token');

    try {
      var response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token"
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body) as List<dynamic>;

        // Update the state variable with the fetched data
        historyDataList = resBody.map((data) {
          // Convert start time and end time strings to DateTime objects
          DateTime startTime = DateTime.parse(data['start_time']);
          DateTime endTime = DateTime.parse(data['end_time']);

          // Calculate duration as the difference between end time and start time
          Duration difference = endTime.difference(startTime);

          // Format the duration as hours and minutes
          String formattedDuration =
              '${difference.inHours}h ${difference.inMinutes.remainder(60)}m';

          return HistoryData(
            startLocation: (data['start_hub']).toString(),
            startTime: startTime,
            endLocation: 'End Location',
            endTime: endTime,
            duration: formattedDuration,
          );
        }).toList();

        setState(() {});
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error Making Request: $e');
    }
  }

  void init() async {
    await historyRequest();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

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
        child: Padding(
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
                children: historyDataList.map((data) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: HistoryPane(
                      startLocation: data.startLocation,
                      startTime: data.startTime,
                      endLocation: data.endLocation,
                      endTime: data.endTime,
                      duration: data.duration,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryPane extends StatelessWidget {
  final String startLocation;
  final DateTime startTime;
  final DateTime endTime;
  final String endLocation;
  final String duration;

  HistoryPane({
    required this.startLocation,
    required this.startTime,
    required this.endLocation,
    required this.endTime,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the width of HistoryPane based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final paneWidth = screenWidth * 0.9; // Adjust the percentage as needed

    return Container(
      width: paneWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFC1E2F1),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationCircle(startLocation),
          SizedBox(height: 8),
          _buildTimeInfo('Start', startTime),
          SizedBox(height: 8),
          _buildTimeInfo('End', endTime),
          SizedBox(height: 8),
          _buildLocationCircle(endLocation),
          SizedBox(height: 8),
          Text(
            duration,
            style: TextStyle(fontSize: 18.0),
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
      alignment: Alignment.center,
      child: Text(
        location,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildTimeInfo(String label, DateTime time) {
    return Text(
      '$label: ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      style: TextStyle(color: Color(0xFF8B97AC)),
    );
  }
}

class HistoryData {
  final String startLocation;
  final DateTime startTime;
  final DateTime endTime;
  final String endLocation;
  final String duration;

  HistoryData({
    required this.startLocation,
    required this.startTime,
    required this.endLocation,
    required this.endTime,
    required this.duration,
  });
}