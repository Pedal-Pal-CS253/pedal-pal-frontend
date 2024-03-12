import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/pages/map_page.dart';
import 'package:http/http.dart' as http;

Future<void> bookForLater(
    DateTime? selectedDate, TimeOfDay? selectedTime) async {
  // TODO: change host
  var uri = Uri(
    scheme: 'https',
    host: 'pedal-pal-backend.vercel.app',
    path: 'booking/book/',
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
    print("YEH RHA RESPONSE:");
    print(response.statusCode);

    // TODO: response code is 400, check attributes
    var tokenBody = jsonEncode({
      'hub': activeHubId,
      'start_time':
          "${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}T${selectedTime?.hour}:${selectedTime?.minute}:00",
      'cycle': "1",
    });

    if (response.statusCode == 200) {
      var resBody = jsonDecode(response.body) as List<dynamic>;
      print(resBody);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error Making Request: $e');
  }
}
