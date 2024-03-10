import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
    // TODO: change host
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
        print(resBody);
        // Update the state variable with the fetched data
        historyDataList = resBody.map((data) {
          return HistoryData(
            startLocation: (data['start_hub']).toString(),
            startTime: data['start_time'],
            startDate: "Start Date",
            endLocation: 'End Location',
            endTime: data['start_time'],
            endDate: 'End Date',
            duration: '1h 2m',
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
                  // IconButton(
                  //   icon: Icon(Icons.arrow_back),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
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
