import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

List<int> hubIdList = [];
List<String> hubNameList = [];
List<double> latitudeList = [];
List<double> longitudeList = [];
List<int> availableList = [];
Map<int, String> hubIdName = {};

Future<void> getHubs() async {
  hubIdList = [];
  hubNameList = [];
  latitudeList = [];
  longitudeList = [];
  availableList = [];

  String baseURL = "https://pedal-pal-backend.vercel.app/booking/view_hubs/";
  FlutterSecureStorage storage = FlutterSecureStorage();
  var token = await storage.read(key: 'auth_token');
  print('token = $token');

  var response = await http.get(Uri.parse(baseURL), headers: {
    HttpHeaders.authorizationHeader: "Token $token",
  });

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    for (var item in data) {
      hubIdList.add(item['id']);
      hubNameList.add(item['hub_name']);
      latitudeList.add(item['latitude']);
      longitudeList.add(item['longitude']);
      availableList.add(item['available']);

      hubIdName.addEntries({hubIdList.last: hubNameList.last}.entries);
      print(hubIdName);
    }
  } else {}
}
