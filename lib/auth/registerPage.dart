// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, file_names, unused_import, unused_local_variable, unrelated_type_equality_checks, unnecessary_new, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'secondPage.dart';
import 'package:intl/intl.dart';

//String variables for User input
String name = "",
    address = "",
    birthdate = "",
    gender = "",
    email = "",
    password = "";

//registerPage screen
class registerPage extends StatefulWidget {
  @override
  registerPageState createState() => registerPageState();
}

//custom state
class registerPageState extends State<registerPage> {
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String _selectedDate = '';

  //date picker function
  Future<String> datePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    //format Date
    String formatDate = new DateFormat("MM-dd-yyyy").format(picked!);
    print(formatDate);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = formatDate;
      });
    }
    return _selectedDate;
  }

  //textFormFields
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 94, 116),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('Create an account')),
          //set appbar divider to false
          elevation: 0),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //logo
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //User input fields
                    SizedBox(
                        child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            height: 40,
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                hintText: 'Please enter your name',
                                prefixIcon: Icon(Icons.account_circle),
                                filled: true,
                                fillColor: Color.fromARGB(255, 236, 234, 234),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter correct name";
                                } else {
                                  //pass value to variable for data handling
                                  name = value;
                                  return null;
                                }
                              },
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            height: 40,
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Address',
                                prefixIcon: Icon(Icons.location_pin),
                                hintText: 'Please enter your address',
                                filled: true,
                                fillColor: Color.fromARGB(255, 236, 234, 234),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter correct address";
                                } else {
                                  //pass value to variable for data handling
                                  address = value;
                                  return null;
                                }
                              },
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            height: 40,
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Birthdate',
                                hintText: '2000-01-01',
                                prefixIcon: Icon(Icons.calendar_today),
                                //hintText: 'Please enter your date',
                                filled: true,
                                fillColor: Color.fromARGB(255, 236, 234, 234),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              //function call for a date Picker widget
                              onTap: () => datePicker(context),
                              controller:
                                  TextEditingController(text: _selectedDate),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter date";
                                } else {
                                  //pass value to variable for data handling
                                  birthdate = value;
                                  return null;
                                }
                              },
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            height: 40,
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: Icon(Icons.transgender_outlined),
                                hintText: 'Enter desired gender',
                                filled: true,
                                fillColor: Color.fromARGB(255, 236, 234, 234),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Required";
                                } else {
                                  //pass value to variable for data handling
                                  gender = value;
                                  return null;
                                }
                              },
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            height: 40,
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                prefixIcon: Icon(Icons.email_rounded),
                                hintText: 'Please enter your e-mail',
                                filled: true,
                                fillColor: Color.fromARGB(255, 236, 234, 234),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter correct e-mail";
                                } else {
                                  //pass value to variable for data handling
                                  email = value;
                                  return null;
                                }
                              },
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 30.0),
                            height: 40,
                            width: 300,
                            child: TextFormField(
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.password_rounded),
                                hintText: 'Enter desired password',
                                filled: true,
                                fillColor: Color.fromARGB(255, 236, 234, 234),
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter correct password";
                                } else {
                                  //pass value to variable for data handling
                                  password = value;
                                  return null;
                                }
                              },
                            )),
                      ],
                    )),
                    SizedBox(
                        height: 40,
                        width: 200,
                        child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () {
                              print(birthdate);
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => secondPage(
                                        name,
                                        address,
                                        birthdate,
                                        gender,
                                        email,
                                        password),
                                  ),
                                );
                                //removes route from Stack to avoid issues
                                //Navigator.removeRoute(context,
                                //    ModalRoute.of(context) as PageRoute);
                              }
                            },
                            child: const Text(
                              'Continue',
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
                                'Already have an account?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 19, 255, 243),
                                  ),
                                ))
                          ],
                        ))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
