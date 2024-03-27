import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/hubs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String email;
  String firstName;
  String lastName;
  String phone;
  bool isSubscribed = false;
  bool isActive = true;
  bool isStaff = false;
  bool isRideActive = false;
  int balance = 0;

  User(
      this.email, this.firstName, this.lastName, this.phone, this.isSubscribed);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        firstName = json['first_name'] as String,
        lastName = json['last_name'] as String,
        phone = json['phone'] as String,
        isSubscribed = json['is_subscribed'] as bool,
        isActive = json['is_active'] as bool,
        isStaff = json['is_staff'] as bool,
        isRideActive = json['ride_active'] as bool,
        balance = json['balance'] as int;

  Map<String, dynamic> toJson() => {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'is_subscribed': isSubscribed,
        'is_active': isActive,
        'is_staff': isStaff,
        'ride_active': isRideActive,
        'balance': balance
      };
}

Future<void> getUserDetails() async {
  var token = await FlutterSecureStorage().read(key: 'auth_token');
  var uri = Uri(
    scheme: 'https',
    host: 'pedal-pal-backend.vercel.app',
    path: 'auth/get_user_details/',
  );

  var response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token'
    },
  );

  SharedPreferences pref = await SharedPreferences.getInstance();

  if (response.statusCode == 200) {
    pref.setString(
      'user',
      jsonEncode(
        User.fromJson(jsonDecode(response.body)['user']).toJson(),
      ),
    );
  }

  uri = Uri(
    scheme: 'https',
    host: 'pedal-pal-backend.vercel.app',
    path: 'analytics/history/',
  );

  response = await http.post(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Token $token"
    },
  );

  if (response.statusCode == 200) {
    var resBody = jsonDecode(response.body) as List<dynamic>;

    for (var data in resBody) {
      if (data['end_time'] != null) continue;
      print(data);
      pref.setString('ride_start_time', data['start_time']);
      pref.setString('ride_start_hub', hubIdName[data['start_hub']]!);
    }
  }
}
