//import 'viewProfile.dart';
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
import './changePass.dart';

Future<Map> getUserData(String email, String pass) async {
  final Map<String, String> noMap = {'User Data': 'Failed to retrieve'};
  const String url =
      'https://api.thingspeak.com/channels/2020581/feeds.json?api_key=8PB79WZM217WORJ9';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final feeds = data['feeds'];
    for (var feed in feeds) {
      if (email == feed['field1'] && pass == feed['field2']) {
        return feed;
      }
    }
  }
  return noMap;
}

Future<Map> authUser(String email, String pass) async {
  final Map userData = await getUserData(email, pass);
  return userData;
}

//CHANGE PASSWORD
Future<void> updatePassword(
    String checkEmail, String oldPass, String newPass) async {
  final String url =
      "https://api.thingspeak.com/update/2?api_key=7E2GNSZVO18E72NV&field2=thesis";
  var response = await http.put(Uri.parse(url));
  print(response.statusCode);
  if (response.statusCode == 200) {
    print('User data stored to database');
  } else {
    print('Error');
  }
}
