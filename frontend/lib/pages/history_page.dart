import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/hubs.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:widget_arrows/widget_arrows.dart';

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

    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
    );

    if (response.statusCode == 200) {
      var resBody = jsonDecode(response.body) as List<dynamic>;

      for (var data in resBody) {
        if (data['end_time'] == null) continue;
        DateTime startTime = DateTime.parse(data['start_time']).toLocal();
        DateTime endTime = DateTime.parse(data['end_time']).toLocal();

        Duration difference = endTime.difference(startTime);

        String formattedDuration =
            '${difference.inHours}h ${difference.inMinutes.remainder(60)}m';

        historyDataList.add(HistoryData(
          startLocation: (data['start_hub']).toString(),
          startTime: startTime,
          endLocation: data['end_hub'].toString(),
          endTime: endTime,
          duration: formattedDuration,
        ));
      }

      historyDataList = historyDataList.reversed.toList();

      setState(() {});
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
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
    Duration totalTimeUsed = Duration();
    for (var data in historyDataList) {
      List<String> timeParts = data.duration.split(' ');
      int hours = int.parse(timeParts[0].replaceAll('h', ''));
      int minutes = int.parse(timeParts[1].replaceAll('m', ''));
      totalTimeUsed += Duration(hours: hours, minutes: minutes);
    }

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: HistoryPane(
                      index: historyDataList.indexOf(data),
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
  final int index;
  final String startLocation;
  final DateTime startTime;
  final DateTime endTime;
  final String endLocation;
  final String duration;

  HistoryPane({
    required this.index,
    required this.startLocation,
    required this.startTime,
    required this.endLocation,
    required this.endTime,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paneWidth = screenWidth * 0.9;

    return Container(
      width: paneWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFC1E2F1),
      ),
      padding: EdgeInsets.all(16.0),
      child: ArrowContainer(
        child: Row(
          children: [
            Column(
              children: [
                ArrowElement(
                  show: true,
                  id: 'start_hub_$index',
                  targetId: 'end_hub_$index',
                  sourceAnchor: Alignment.centerRight,
                  padEnd: 25,
                  padStart: 25,
                  child: Text(
                    hubIdName[int.parse(startLocation)]!,
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                _buildTimeInfo('Start', startTime),
              ],
            ),
            Spacer(),
            Text(
              duration,
              style: TextStyle(fontSize: 18.0),
            ),
            Spacer(),
            Column(
              children: [
                ArrowElement(
                  show: true,
                  id: 'end_hub_$index',
                  child: Text(
                    hubIdName[int.parse(endLocation)]!,
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                _buildTimeInfo('End', endTime),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, DateTime time) {
    return Column(
      children: [
        Text(
          DateFormat("dd MMM yyyy").format(time),
          style: TextStyle(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        Text(
          DateFormat("hh:mm a").format(time),
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
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
