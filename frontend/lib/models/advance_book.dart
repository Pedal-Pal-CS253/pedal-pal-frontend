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
    path: 'booking/book_later/',
  );

  FlutterSecureStorage storage = FlutterSecureStorage();
  var token = await storage.read(key: 'auth_token');

  try {
    var body = jsonEncode({
      'hub': activeHubId,
      'start_time':
      "${selectedDate?.year}-${selectedDate?.month.toString().padLeft(2, '0')}-${selectedDate?.day.toString().padLeft(2, '0')}T${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}:00",
    });
    
    var response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token"
      },
      body: body,
    );

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
