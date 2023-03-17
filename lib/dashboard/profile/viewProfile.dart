// ignore_for_file: no_logic_in_create_state, prefer_final_fields, unused_field, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, must_be_immutable
import 'package:airduino/dashboard/functions/statusColor.dart';
import 'package:flutter/material.dart';
import './authUser.dart';
import '../mainDashboard.dart';
import '../functions/getStatus.dart';
//import 'authUser.dart';

class viewProfile extends StatefulWidget {
  Map userModel;

  viewProfile({required this.userModel});
  @override
  viewProfileState createState() => viewProfileState(userModel);
}

class viewProfileState extends State<viewProfile> {
  Map feed;
  viewProfileState(this.feed);
  @override
  Widget build(BuildContext context) {
    //assign feed entries to a variable
    var email = feed['email'];
    var pass = feed['password'];
    var name = feed['name'];
    var address = feed['address'];
    var birthDate = feed['birthdate'];
    var gender = feed['gender'];
    var colorStat = feed['userClass'];
    var status = getStatus(feed['userClass']);
    print(feed);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 94, 116),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fill,
            width: 11 * 4.5,
            height: 13 * 4.5,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.4 * 400,
              //height: 1.0 * 200,
              child: Image.asset('assets/images/profile_img.png'),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: Text(
                name.toUpperCase(),
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(blurRadius: 20.0, color: Colors.grey.shade700)
                ],
                color: Colors.white70,
                //border: Border.all(width: 0),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 30.0),
              padding: EdgeInsets.all(20.0),
              height: 250,
              width: 280,
              //color: Colors.red,
              child: Column(children: [
                Text(
                  'STATUS',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                        letterSpacing: 2.0,
                        color: statusColor(colorStat),
                        /*
                        color: colorStat == '0'
                            ? Colors.green.shade800
                            : colorStat == '1'
                                ? Colors.amber.shade400
                                : colorStat == '2'
                                    ? Colors.orange.shade800
                                    : colorStat == '3'
                                        ? Colors.orange.shade800
                                        : colorStat == '4'
                                            ? Colors.red.shade700
                                            : colorStat == '5'
                                                ? Colors.red.shade700
                                                : Colors.black,
                                                */
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
                Text(
                  'BIRTHDATE',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    birthDate,
                    style: TextStyle(
                        //color: Color.fromARGB(255, 12, 94, 116),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  ),
                ),
                Text(
                  'GENDER',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    gender.toUpperCase(),
                    style: TextStyle(
                        //color: Color.fromARGB(255, 12, 94, 116),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  ),
                ),
                Text(
                  'ADDRESS',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: Text(
                    address.toUpperCase(),
                    style: TextStyle(
                        //color: Color.fromARGB(255, 12, 94, 116),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 40,
              width: 150,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.white70),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'DASHBOARD',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
            )
          ],
        )),
      ),
    );
  }
}
