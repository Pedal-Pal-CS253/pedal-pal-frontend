import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

List<int> hubIdList = [];
List<String> hubNameList = [];
List<double> latitudeList = [];
List<double> longitudeList = [];
List<int> availableList = [];


Future<void> get_hubs() async {
  String baseURL = "http://10.0.2.2:8000/booking/view_hubs/";
  String token = "8d03eac512d5849b3c9078718a9247cdbb4bcefd";

  try {
    var response = await http.get(Uri.parse(baseURL), headers: {
      HttpHeaders.authorizationHeader: "Token $token",
    });
    print("YEH RHA RESPONSE:");
    print(response);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      for (var item in data) {
        hubIdList.add(item['id']);
        hubNameList.add(item['hub_name']);
        latitudeList.add(item['latitude']);
        longitudeList.add(item['longitude']);
        availableList.add(item['available']);
      }

      print('idList: $hubIdList');
      print('hubNameList: $hubNameList');
      print('latitudeList: $latitudeList');
      print('longitudeList: $longitudeList');
      print('availableList: $availableList');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('Error: $e');
  }
}