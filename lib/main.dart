// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import './frontPage.dart';
//import './auth/registerPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AirDuino',
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 12, 94, 116))),
        //homepage route
        home: frontPage());
  }
}
