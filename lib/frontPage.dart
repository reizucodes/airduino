// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, file_names, unused_import
import 'package:flutter/material.dart';
//paths for authentication
import './auth/loginPage.dart';

//create a scaffold outside [MyApp class]
class frontPage extends StatefulWidget {
  @override
  frontPageState createState() => frontPageState();
}

//custom state
class frontPageState extends State<frontPage> {
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
