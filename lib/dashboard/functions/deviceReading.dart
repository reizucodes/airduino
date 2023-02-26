//PDID-01 API GET Key
//Gets latest feed, first entry.
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getReadings(String url) async {
  //supposdely gets the latest entry within the database using provided url
  final response = await http.get(Uri.parse(url));
  print(response.statusCode);
  if (response.statusCode == 200) {
    print('Hi, im in');
    final data = json.decode(response.body);
    final feeds = data['feeds'];
    for (var feed in feeds) {
      return feed;
    }
  }
  return {};
}
