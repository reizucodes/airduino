// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, file_names, unused_import, prefer_const_literals_to_create_immutables, unused_field, use_build_context_synchronously, depend_on_referenced_packages
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './registerPage.dart';
import '../main.dart';
import '../frontPage.dart';
import '../dashboard/mainDashboard.dart';

class loginPage extends StatefulWidget {
  @override
  loginPageState createState() => loginPageState();
}

//login Page logic
class loginPageState extends State<loginPage> {
  //const loginPageState({Key: key}) : super(key: key);
  bool _isLoading = false;
  bool _passwordVisible = false;
//controller for user input
  final _email = TextEditingController();
  final _pass = TextEditingController();
  //isLoggedIn variables
  late SharedPreferences loginData;
  late bool newUser;
  //clear LoginCache function to reset login
  Future<void> clearLoginCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_email.text);
    prefs.remove(_pass.text);
  }

  //clear user Map
  Future<void> clearUserMap(String data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(data);
  }

  //hash user input password
  String hashPassword(String text) {
    var bytes = utf8.encode(text);
    var hash = sha256.convert(bytes);
    return hash.toString();
  }

  //FIREBASE isUserExisting
  Future<bool> isUserExisting(String id) async {
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection('users-db')
        .doc(_email.text)
        .get();
    if (user.exists) {
      return true;
    } else {
      return false;
    }
  }

  //FIREBASE AUTHLOGIN!
  Future<void> loginFirebase(BuildContext context) async {
    String hashed = hashPassword(_pass.text);
    setState(() {
      _isLoading = true;
    });

    if (await isUserExisting(_email.text)) {
      //if user exists; continue authentication
      final user =
          FirebaseFirestore.instance.collection('users-db').doc(_email.text);
      user.get().then(
        (DocumentSnapshot doc) async {
          final data = doc.data() as Map<String, dynamic>;
          //if correct email and password input, then;
          //go to dashboard
          if (hashed == data['password']) {
            //user will be set as currently logged in
            loginData.setBool('login', false);
            //store to Shared Preferences for loginData
            loginData.setString('id', data['email']);
            //convert Map 'data' into String list using json.encode();
            String convertData = json.encode(data);
            print(convertData);
            //store to Shared Preferences for loginData
            loginData.setString('side', convertData);
            //print(_email.text);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        mainDashboard(id: data['email'], side: data)));
            //removes route from Stack to avoid issues
            Navigator.removeRoute(context, ModalRoute.of(context) as PageRoute);
            clearUserMap(data.toString());
            _email.clear();
            _pass.clear();
          }
          //else if correct email but wrong password
          else if (_pass.text != data['password']) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Incorrect Credentials'),
            ));
            _pass.clear();
            await clearLoginCache();
          }
        },
        onError: (e) => print("error getting data: $e"),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User not found.'),
      ));
      _email.clear();
      _pass.clear();
      await clearLoginCache();
    }
    //end
    setState(() {
      _isLoading = false;
    });
  }

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
      print(side);
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
  //login Page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 12, 94, 116),
        appBar: AppBar(
            //set appbar divider to false
            elevation: 0),
        body: Padding(
          padding: EdgeInsets.all(0.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Logo SizedBox
                  SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset('assets/images/logo.png')),
                  //User Input Text Fields
                  SizedBox(
                      height: 200,
                      width: 350,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //email textField
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email_outlined),
                                    hintText: 'Please enter your e-mail',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 236, 234, 234),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        //clear typed text
                                        _email.clear();
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                )),
                            //password textField
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: _pass,
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.password_outlined),
                                    hintText: 'Please enter your password',
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 236, 234, 234),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    //view password icon
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                )),
                          ])),
                  //Login button
                  _isLoading
                      ? CircularProgressIndicator.adaptive(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white))
                      : Container(
                          margin: EdgeInsets.all(20),
                          height: 50,
                          width: 200,
                          child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.white),
                              ),
                              onPressed: () async =>
                                  await loginFirebase(context),
                              //async => await authLogin(context),
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 94, 116),
                                ),
                              ))),
                  Container(
                      margin: EdgeInsets.all(20),
                      height: 50,
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              style: TextStyle(color: Colors.white),
                              'Do not have an account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => registerPage()));
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 19, 255, 243),
                                ),
                              ))
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
