// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, file_names, unused_import, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//paths for authentication
import './auth/loginPage.dart';
import './dashboard/mainDashboard.dart';
import 'dart:convert';

//create a scaffold outside [MyApp class]
class frontPage extends StatefulWidget {
  @override
  frontPageState createState() => frontPageState();
}

//custom state
class frontPageState extends State<frontPage> {
  late SharedPreferences loginData;
  late bool newUser;
  //using shared preferences, if a user has logged in previously, then loginData was stored in persistent memory, implementing one time login, until user logouts
  void isLoggedIn() async {
    print('isLoggedinFunction is running');
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);

    print(newUser);

    if (newUser == false) {
      String storedEmail = loginData.getString('id')!;
      //decode stored String list into a Map
      String storedData = loginData.getString('side')!;
      Map<dynamic, dynamic> side = json.decode(storedData);
      print('data: {$side}');
      //navigate to dashboard
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  mainDashboard(id: storedEmail, side: side)));
    }
  }

  //init State for checkIfLoggedIn
  @override
  void initState() {
    print('initState started');
    super.initState();
    isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    //Navigator Route Function to Login

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 12, 94, 116),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //airduino Logo
              SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset('assets/images/logo.png')),
              SizedBox(
                height: 60,
                width: 200,
                child: const Text('AIRDUINO DEVICE MONITORING APP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    )),
              ),
              //Navigate to Login Container
              Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginPage()));
                      },
                      child: const Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 12, 94, 116),
                        ),
                      ))),
            ],
          ),
        ));
  }
}
