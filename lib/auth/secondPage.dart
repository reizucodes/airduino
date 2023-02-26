// ignore_for_file: prefer_const_constructors, prefer_const_declarations, camel_case_types, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, depend_on_referenced_packages

import 'package:flutter/material.dart';
import './registerPage.dart';
import 'dart:convert';
import '../dashboard/mainDashboard.dart';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//secondPage
class secondPage extends StatefulWidget {
  secondPage(String name, String address, String birthdate, String gender,
      String email, String password);
  @override
  secondPageState createState() => secondPageState();
}

class secondPageState extends State<secondPage> {
  //final _formKey = GlobalKey<FormState>();
  //counter for checklist

  bool _isLoading = false;
  final List<bool> _checkList = List.filled(5, false);
  final List<String> _item = [
    'Asthma',
    'Bronchitis',
    'Emphysema',
    'Pneumonia',
    'Tubercolosis',
  ];

  int checker() {
    int count = 0;
    for (bool isChecked in _checkList) {
      if (isChecked) count++;
    }
    return count;
  }

  Map mapUser(BuildContext context) {
    final String status = checker().toString();
    Map data = {
      'email': email,
      'password': password,
      'name': name,
      'address': address,
      'birthdate': birthdate,
      'gender': gender,
      'userClass': status,
    };
    return data;
  }

  String passwordHash(String password) {
    var bytes = utf8.encode(password);
    var hash = sha256.convert(bytes);
    return hash.toString();
  }

  //FIREBASE
  //store user in db
  Future<void> storeUser(BuildContext context) async {
    final String status = checker().toString();
    final _user = FirebaseFirestore.instance.collection('users-db').doc(email);
    //create Json collection of data
    final userData = {
      'email': email,
      'password': passwordHash(password),
      'name': name,
      'address': address,
      'birthdate': birthdate,
      'gender': gender,
      'userClass': status,
    };
    //Write user data to firestore
    await _user.set(userData);
  }

  //check if email exists
  Future<bool> isEmailExisting(String email) async {
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection('users-db')
        .doc(email)
        .get();
    if (user.exists) {
      return true;
    } else {
      return false;
    }
  }

  //register user
  Future<void> registerFirebase(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    //bool result = await isEmailExisting(email);
    if (await isEmailExisting(email)) {
      //if email exists
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email is already used by another user'),
      ));
      print('Email present in database');
    } else {
      //else, store data into database;
      //proceed to dashboard
      await storeUser(context);
      Map user = mapUser(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => mainDashboard(id: email, side: user)));
      //removes route from Stack to avoid issues
      Navigator.removeRoute(context, ModalRoute.of(context) as PageRoute);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 12, 94, 116),
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 100.0),
            child: Text('Quick Survey'),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 236, 234, 234),
                    ),
                    height: 320,
                    width: 300,
                    child: Column(
                      children: [
                        Text(
                          'Please select any illness which applies to you. ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 12, 94, 116),
                          ),
                        ),
                        Text(
                          'If none, Continue.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 12, 94, 116),
                          ),
                        ),
                        //Divider
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                          height: 2,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 0.0,
                                  color: Color.fromARGB(255, 100, 99, 99)),
                            ),
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: _checkList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CheckboxListTile(
                              value: _checkList[index],
                              onChanged: (value) {
                                setState(() {
                                  _checkList[index] = value!;
                                });
                              },
                              title: Text(
                                _item[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Color.fromARGB(255, 12, 94, 116)),
                              ),
                            );
                          },
                        )),
                      ],
                    )),
                _isLoading
                    ? CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : SizedBox(
                        height: 40,
                        width: 200,
                        child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () async =>
                                await registerFirebase(context),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 12, 94, 116),
                              ),
                            ))),
              ],
            ),
          ),
        ));
  }
}
