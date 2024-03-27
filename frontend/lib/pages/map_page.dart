import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/advance_book.dart';
import 'package:frontend/models/hubs.dart';
import 'package:frontend/pages/alerts.dart';
import 'package:frontend/pages/booking_page.dart';
import 'package:frontend/pages/history_page.dart';
import 'package:frontend/pages/qr_scanner.dart';
import 'package:frontend/pages/setting_page.dart';
import 'package:frontend/pages/wallet_home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';
import 'active_ride.dart';

late int activeHubId;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _MapPageState();
}

class _MapPageState extends State<Dashboard>
    with AfterLayoutMixin<Dashboard>, RouteAware {
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  late String placeOfMarker;
  bool showInfoContainer = false;
  late int cycleNumber;
  Set<Marker> markers = {};
  User user = User("loading", "loading", "loading", "loading", false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _getUserInfo() async {
    getUserDetails();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('user');
    if (userData != null) {
      user = User.fromJson(jsonDecode(userData));
    }
  }

  void infoForMarker(
      String markerId, LatLng markerPosition, int cycles, int hubId) async {
    await getHubs();
    setState(() {
      placeOfMarker = markerId;
      cycleNumber = cycles;
      activeHubId = hubId;
      showInfoContainer = true;
    });
  }

  List<LatLng> coordinates = [];

  void populateCoordinates(List<LatLng> coordinates) {
    for (int i = 0; i < latitudeList.length; i++) {
      coordinates.add(LatLng(latitudeList[i], longitudeList[i]));
    }
  }

  void _generateMarkers() {
    getHubs().whenComplete(() {
      populateCoordinates(coordinates);
      for (int i = 1; i <= hubIdList.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId(hubNameList[i - 1]),
            position: coordinates[i - 1],
            onTap: () {
              infoForMarker(hubNameList[i - 1], coordinates[i - 1],
                  availableList[i - 1], hubIdList[i - 1]);
            },
          ),
        );
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello, ${user.firstName}!',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (user.isRideActive) {
                              Fluttertoast.showToast(
                                  msg: 'You already have an active ride!');
                              return;
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const QRViewExample(mode: "book"),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            'Ride Now',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (user.isRideActive) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => RideScreen()),
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'You have no active rides!');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 88, 83, 154),
                          ),
                          child: Text(
                            'View Active Ride',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 600,
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(26.5113, 80.2329),
                        zoom: 15,
                      ),
                      markers: markers,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showInfoContainer)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showInfoContainer = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      height: 330,
                      width: 320,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  child: Center(
                                      child: Text(
                                    'SELECTED\nHUB',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  child: Center(
                                      child: Text(
                                    'CYCLES\nAVAILABLE',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: Center(
                                      child: Text(placeOfMarker,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue))),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: Center(
                                      child: Text('$cycleNumber',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue))),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: (user.isSubscribed
                                    ? Colors.blueAccent.withOpacity(0.4)
                                    : Colors.grey),
                                border: Border.all(
                                  color: (user.isSubscribed
                                      ? Colors.blue
                                      : Colors.grey),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          child: Center(
                                              child: Text(
                                            'Advanced Booking',
                                            style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              ElevatedButton(
                                                onPressed: (!user.isSubscribed)
                                                    ? null
                                                    : () =>
                                                        _selectDate(context),
                                                child: Text(
                                                  'Select Date',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 88, 83, 154),
                                                ),
                                              ),
                                              Text(
                                                '${DateFormat("dd MMM yyyy").format(DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute))}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              ElevatedButton(
                                                onPressed: (!user.isSubscribed)
                                                    ? null
                                                    : () =>
                                                        _selectTime(context),
                                                child: Text(
                                                  'Select Time',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 88, 83, 154),
                                                ),
                                              ),
                                              Text(
                                                '${DateFormat("hh:mm a").format(DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute))}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: (!user.isSubscribed)
                                        ? null
                                        : () => bookLater(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: Size(120, 40),
                                    ),
                                    child: Text(
                                      'Book for Later',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 170,
                width: 340,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/profile_photo.png'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('Wallet'),
                    onTap: () {
                      if (!user.isSubscribed) {
                        AlertPopup().show(context,
                            text:
                                "This feature is available only for subscribed users!");
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WalletHomePage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('History'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (HistoryPage())),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('My Bookings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (BookingPage())),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('View Profile'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage()));
                    },
                  ),
                  ListTile(
                    title: Text('Log Out'),
                    onTap: () async {
                      FlutterSecureStorage storage = FlutterSecureStorage();
                      storage.delete(key: 'auth_token');
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.clear();

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(title: 'Pedal Pal'),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    print("afterFirstLayout called!");
    placeOfMarker = '';
    _generateMarkers();
    _getUserInfo();
  }

  @override
  void didPush() {
    print("didPush called on dashboard");
    _getUserInfo();
  }

  @override
  void didPop() {
    print("didPop called on dashboard");
    _getUserInfo();
  }

  @override
  void didPushNext() {
    print("didPushNext called on dashboard");
    _getUserInfo();
  }

  @override
  void didPopNext() {
    print("didPopNext called on dashboard");
    _getUserInfo();
  }

  void bookLater() async {
    var cost = DateTime(selectedDate!.year, selectedDate!.month,
            selectedDate!.day, selectedTime!.hour, selectedTime!.minute)
        .difference(DateTime.now())
        .inMinutes;
    if (cost <= 0) {
      Fluttertoast.showToast(
        msg: "Your booking cannot be in the past!",
      );
      setState(() {
        showInfoContainer = false;
      });
      return;
    }
    var response = await showConfirmationDialog(
        context, 'Book in Advance?', 'You will have to pay ₹$cost.');
    if (response == true) {
      await bookForLater(selectedDate, selectedTime);
    }
    setState(() {
      showInfoContainer = false;
    });
  }
}
