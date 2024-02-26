import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatelessWidget {
  final List<BookingData> bookingDataList = [
    BookingData(
      startLocation: 'Hall 2',
      startDate: '24 Feb',
      startTime: '12:02',
    ),
    BookingData(
      startLocation: 'RM',
      startDate: '25 Feb',
      startTime: '10:30',
    ),
    // Add more BookingData objects as needed
  ];

  final List<PrevBookingData> prevBookingDataList = [
    PrevBookingData(
      startLocation: 'Hall 6',
      startDate: '22 Feb',
      startTime: '15:30',
    ),
    PrevBookingData(
      startLocation: 'Hall 4',
      startDate: '20 Feb',
      startTime: '09:45',
    ),
    // Add more PrevBookingData objects as needed
  ];

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
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Bookings: ${bookingDataList.length}',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bookingDataList.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: BookingInfo(
                          startLocation: data.startLocation,
                          startDate: data.startDate,
                          startTime: data.startTime,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0), // Adding space between current and previous bookings
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previous Bookings: ${prevBookingDataList.length}',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: prevBookingDataList.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: PrevBookingInfo(
                          startLocation: data.startLocation,
                          startDate: data.startDate,
                          startTime: data.startTime,
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

class BookingInfo extends StatelessWidget {
  final String startLocation;
  final String startDate;
  final String startTime;

  BookingInfo({
    required this.startLocation,
    required this.startDate,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
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
              color: Color(0xFF8EC1DC),
            ),
            alignment: Alignment.center,
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
                startDate,
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

class PrevBookingInfo extends StatelessWidget {
  final String startLocation;
  final String startDate;
  final String startTime;

  PrevBookingInfo({
    required this.startLocation,
    required this.startDate,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
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
              color: Color(0xFF8EC1DC),
            ),
            alignment: Alignment.center,
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
                startDate,
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
  final String startDate;
  final String startTime;

  BookingData({
    required this.startLocation,
    required this.startDate,
    required this.startTime,
  });
}

class PrevBookingData {
  final String startLocation;
  final String startDate;
  final String startTime;

  PrevBookingData({
    required this.startLocation,
    required this.startDate,
    required this.startTime,
  });
}
