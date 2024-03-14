import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<BookingData> currentBookings = [];
  List<BookingData> pastBookings = [];

  Future<void> bookingRequest() async {
    var uri = Uri(
      scheme: 'https',
      host: 'pedal-pal-backend.vercel.app', // Replace with your backend URL
      path:
          'analytics/booking_history/', // Replace with the endpoint to fetch booking data
    );

    FlutterSecureStorage storage = FlutterSecureStorage();
    var token = await storage.read(key: 'auth_token');

    var response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      var resBody = jsonDecode(response.body) as List<dynamic>;

      for (var data in resBody) {
        BookingData bookingData = BookingData(
          startLocation: data['hub'].toString(),
          bookTime: data['book_time'],
          startTime: data['start_time'],
          endTime: (data['end_time'] != Null) ? data['end_time'] : null,
        );

        if (bookingData.endTime == null) {
          print("adding in current bookings");
          currentBookings.add(bookingData);
        } else {
          print("adding in past bookings");
          pastBookings.add(bookingData);
        }
      }

      setState(() {});
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void init() async {
    await bookingRequest();
  }

  @override
  void initState() {
    super.initState();
    init();
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
                    'Booking',
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
              _buildBookingsSection('Current Bookings', currentBookings),
              SizedBox(height: 16.0),
              _buildBookingsSection('Past Bookings', pastBookings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsSection(String title, List<BookingData> bookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ${bookings.length}',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: bookings.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: BookingInfo(
                startLocation: data.startLocation,
                bookTime: data.bookTime,
                startTime: data.startTime,
                endTime: data.endTime,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class BookingInfo extends StatelessWidget {
  final String startLocation;
  final String bookTime;
  final String startTime;
  final String? endTime; // Nullable endTime

  BookingInfo({
    required this.startLocation,
    required this.bookTime,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentBooking = endTime == null;

    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFC1E2F1),
      ),
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Circle on the left
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrentBooking
                  ? Colors.green
                  : Colors.red, // Color based on current or past booking
            ),
            alignment: Alignment.center,
            child: Icon(
              isCurrentBooking ? Icons.check : Icons.history,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16.0),
          // Start Location
          Expanded(
            child: Text(
              startLocation,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          // Start Date and Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                bookTime,
                style: TextStyle(
                  color: Color(0xFF8B97AC),
                  fontSize: 16.0,
                ),
              ),
              Text(
                startTime,
                style: TextStyle(
                  color: Color(0xFF8B97AC),
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingData {
  final String startLocation;
  final String bookTime;
  final String startTime;
  final String? endTime; // Nullable endTime

  BookingData({
    required this.startLocation,
    required this.bookTime,
    required this.startTime,
    this.endTime,
  });
}
