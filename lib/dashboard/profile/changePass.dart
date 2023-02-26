// ignore_for_file: non_constant_identifier_names, must_be_immutable, use_key_in_widget_constructors, camel_case_types, no_logic_in_create_state, prefer_const_constructors, unused_local_variable, prefer_final_fields, depend_on_referenced_packages, avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
//import 'package:my_app/auth/registerPage.dart';
//import '../mainDashboard.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'authUser.dart';

class changePass extends StatefulWidget {
  String email;
  String pass;
  changePass({required this.email, required this.pass});
  @override
  changePassState createState() => changePassState(email, pass);
}

class changePassState extends State<changePass> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String change_email;
  String change_pass;

  changePassState(this.change_email, this.change_pass);
  bool _passwordVisible = false;
  String hashPassword(String text) {
    var bytes = utf8.encode(text);
    var hash = sha256.convert(bytes);
    return hash.toString();
  }

  //update user password in firebase
  Future<void> updatePassword(String email, String newPass) async {
    //check user input
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> password = {
      'password': hashPassword(newPass),
    };
    CollectionReference collection =
        FirebaseFirestore.instance.collection('users-db');
    DocumentReference document = collection.doc(email);
    document.update(password);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      change_pass = hashPassword(newPass);
      print('Update Old Pass: $change_pass');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Old Pass: $change_pass');

    final newPass = TextEditingController();
    final userInput = TextEditingController();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 94, 116),
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/logo.png')),
              Container(
                margin: EdgeInsets.all(20.0),
                child: Text(
                  'Change Password',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                  Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      height: 50,
                      width: 300,
                      child: TextFormField(
                        controller: userInput,
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          //labelText: '',
                          //prefixIcon: Icon(Icons.location_pin),
                          hintText: 'Enter old password',
                          filled: true,
                          fillColor: Color.fromARGB(255, 236, 234, 234),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
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
                        validator: (value) {
                          if (value!.isEmpty ||
                              hashPassword(value) != change_pass) {
                            print(change_pass);
                            return "Enter correct old password";
                          } else {
                            //pass value to variable for data handling
                            return null;
                          }
                        },
                      )),
                  //NEW PASSWORD
                  Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      height: 50,
                      width: 300,
                      child: TextFormField(
                        controller: newPass,
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          //labelText: '',
                          //prefixIcon: Icon(Icons.location_pin),
                          hintText: 'Enter new password',
                          filled: true,
                          fillColor: Color.fromARGB(255, 236, 234, 234),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "New password cannot be empty";
                          } else {
                            if (hashPassword(value) == change_pass) {
                              return "New password cannot be the same with the old one";
                            } else {
                              //pass value to variable for data handling
                              return null;
                            }
                          }
                        },
                      )),
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await updatePassword(
                                      change_email, newPass.text);
                                  userInput.clear();
                                  newPass.clear();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Password Updated!'),
                                  ));
                                  //navigate back to the dashboard
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                }
                              },
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 12, 94, 116),
                                ),
                              ))),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
