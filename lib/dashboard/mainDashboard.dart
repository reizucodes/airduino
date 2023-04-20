// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_final_fields, use_build_context_synchronously, no_logic_in_create_state, must_be_immutable, sort_child_properties_last, prefer_adjacent_string_concatenation, prefer_typing_uninitialized_variables, unused_local_variable, prefer_const_declarations, avoid_print, non_constant_identifier_names
import 'package:airduino/dashboard/profile/moreInfo.dart';

import '../auth/loginPage.dart';
import 'functions/getStatus.dart';
import './profile/changePass.dart';
import 'functions/statusColor.dart';
import './profile/viewProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airduino/dashboard/functions/conversionMethod.dart';
import 'package:airduino/dashboard/functions/deviceReading.dart';
import 'package:airduino/dashboard/functions/recommendAction.dart';

class mainDashboard extends StatefulWidget {
  String id;
  Map side;
  mainDashboard({required this.id, required this.side});
  @override
  mainDashboardState createState() => mainDashboardState(id, side);
}

bool isPageLoading = true;
bool _isBodyLoading = false;
late SharedPreferences loginData;

class mainDashboardState extends State<mainDashboard> {
  //store user data in map
  String userID;
  Map side;
  mainDashboardState(this.userID, this.side);
  //SharedPreference variable
  //gloabl var foruserData
  Map userModel = {};
  //gloabl var for prototype I data
  Map dev1 = {};
  //gloabl var for prototype II data
  Map dev2 = {};
  //sidebar Variables
  var email;
  var pass;
  var name;
  var status;
  String timestamp1 = '';
  String dev1_date = '';
  String dev1_time = '';
  String timestamp2 = '';
  String dev2_date = '';
  String dev2_time = '';
  var temp1;
  var temp2;

  String month(int date) {
    List month = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return month[date - 1];
  }

  int hour(int data) {
    if (data == 0) {
      return 12;
    } else if (data > 12) {
      return data - 12;
    } else
      return data;
  }

  String period(int hour) {
    if (hour >= 12) {
      return 'PM';
    } else
      return 'AM';
  }

  //fetch and return latest data from device database
  //prototype I and II data latest reading fetch
  Future<void> _refreshBody() async {
    setState(() {
      _isBodyLoading = true;
    });
    //PDID-01 device reading
    final String api01 =
        'https://api.thingspeak.com/channels/1984955/feeds.json?api_key=NDNMXQL1V5H7A54X&results=1';
    //function call for latest reading fetching
    Map<String, dynamic> pd01 = await getReadings(api01);
    print(pd01);
    //PDID-02 device reading
    final String api02 =
        'https://api.thingspeak.com/channels/2036851/feeds.json?api_key=9XT7144SEWL028E4&results=1';
    //function call for latest reading fetching
    Map pd02 = await getReadings(api02);
    print('pd02: $pd02');
    //await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isBodyLoading = false;
      dev1 = pd01;
      timestamp1 = dev1['created_at'];
      DateTime dateTime_dev1 = DateTime.parse(timestamp1);
      DateTime dateTimeLocal_dev1 = dateTime_dev1.toLocal();
      //DateTime dateTimeGmt8 = dateTimeLocal.add(Duration(hours: 8));
      DateTime dateTimeGmt8_dev1 = dateTimeLocal_dev1;
      print(dateTimeLocal_dev1);
      dev1_date =
          "${month(dateTimeGmt8_dev1.month)} ${dateTimeGmt8_dev1.day}, ${dateTimeGmt8_dev1.year}";
      dev1_time =
          "${hour(dateTimeGmt8_dev1.hour)}:${dateTimeGmt8_dev1.minute.toString().padLeft(2, '0')} ${period(dateTimeGmt8_dev1.hour)}";
      dev2 = pd02;
      timestamp2 = dev2['created_at'];
      DateTime dateTime_dev2 = DateTime.parse(timestamp2);
      DateTime dateTimeLocal_dev2 = dateTime_dev2.toLocal();
      //DateTime dateTimeGmt8 = dateTimeLocal.add(Duration(hours: 8));
      DateTime dateTimeGmt8_dev2 = dateTimeLocal_dev2;
      //dateTimeGmt8_dev2.hour
      print(dateTimeLocal_dev2);
      dev2_date =
          "${month(dateTimeGmt8_dev2.month)} ${dateTimeGmt8_dev2.day}, ${dateTimeGmt8_dev2.year}";
      dev2_time =
          "${hour(dateTimeGmt8_dev2.hour)}:${dateTimeGmt8_dev2.minute.toString().padLeft(2, '0')} ${period(dateTimeGmt8_dev2.hour)}";
      //temperature values
      temp1 = double.parse(dev1['field1']);
      temp1 = double.parse(temp1.toStringAsFixed(1));
      temp2 = double.parse(dev2['field1']);
      temp2 = double.parse(temp2.toStringAsFixed(1));
    });
  }

  //get user data function
  Future<void> getUserData() async {
    final user = FirebaseFirestore.instance.collection('users-db').doc(userID);
    Map model = await user.get().then(
      (DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        return data;
      },
      onError: (e) => print("error getting data: $e"),
    );
    setState(() {
      isPageLoading = false;
      //pass value to global variable
      userModel = model;
      email = userModel['email'];
      pass = userModel['password'];
      name = userModel['name'];
      status = getStatus(userModel['userClass']);
    });
  }

  void fetchLoginData() async {
    loginData = await SharedPreferences.getInstance();
  }

  //init State
  @override
  void initState() {
    print('initState is running');
    super.initState();
    //fetch stored data in sharedPrefs
    fetchLoginData();
    //fetch user data and latest reading on initialization
    getUserData();
    _refreshBody();
  }

  @override
  void dispose() {
    print('dispose() is running');
    super.dispose();
    loginData.remove('id');
    loginData.remove('side');
    print('loginData: {$loginData}');
  }

  @override
  Widget build(BuildContext context) {
    //assigns values to sidebar variables
    email = side['email'];
    pass = side['password'];
    name = side['name'];
    status = getStatus(side['userClass']);

    //for debugging
    print('runTime');
    return isPageLoading
        ? Scaffold(
            backgroundColor: Color.fromARGB(255, 12, 94, 116),
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Color.fromARGB(255, 12, 94, 116),
            appBar: AppBar(
              title: Center(
                  child: Text(
                'Air Quality',
              )),
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(color: Colors.white, Icons.refresh_rounded),
                  onPressed: () {
                    //clears data models before refreshing
                    _refreshBody();
                    getUserData();
                  },
                )
              ],
            ),
            //check if data updates
            body: _isBodyLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshBody,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(20.0),
                          //height: 900,
                          //color: Colors.grey.shade500,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //PROTOYPE I - PENARANDA PARK
                              Container(
                                  padding: EdgeInsets.all(20.0),
                                  //height: 400,
                                  //width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 20.0,
                                          color: Colors.grey.shade700)
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Location and Temperature
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: Text(
                                                'PEÑARANDA PARK',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 2.5),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              //color: Colors.blue,
                                              width: double.infinity,
                                              child: Text(
                                                '$temp1 ° C',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),

                                      //TOTAL AQI DATE and TIME
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: Text(
                                                //convert aqi value into the index range's class
                                                getAqi(double.parse(
                                                        dev1['field7']))
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: sensorReadings(
                                                        getAqi(double.parse(
                                                            dev1['field7']))),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.5),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 5.0),
                                                height: 30,
                                                alignment:
                                                    Alignment.centerRight,
                                                //color: Colors.blue,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        //color: Colors.red,
                                                        child: Text(
                                                          //date value
                                                          dev1_date,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 1.2,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topRight,
                                                        //color: Colors.orange,
                                                        child: Text(
                                                          //time value
                                                          'As of $dev1_time',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 1.2,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      //Ozone Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Ozone',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getOzone(double.parse(
                                                    dev1['field2'])),
                                                style: TextStyle(
                                                  //replace with color function for ozone
                                                  color: sensorReadings(
                                                      getOzone(double.parse(
                                                          dev1['field2']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //PM2.5 Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'PM2.5',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getPM(double.parse(
                                                    dev1['field3'])),
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: sensorReadings(getPM(
                                                      double.parse(
                                                          dev1['field3']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Carbon Monoxide Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Carbon  Monoxide',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getCarbon(double.parse(
                                                    dev1['field4'])),
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: sensorReadings(
                                                      getCarbon(double.parse(
                                                          dev1['field4']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Sulfur Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Sulfur Dioxide',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getSulfur(double.parse(
                                                    dev1['field5'])),
                                                style: TextStyle(
                                                  //replace with color function for sulfur
                                                  color: sensorReadings(
                                                      getSulfur(double.parse(
                                                          dev1['field5']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Nitrogen Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Nitrogen Dioxide',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getNitrogen(double.parse(
                                                    dev1['field6'])),
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: sensorReadings(
                                                      getNitrogen(double.parse(
                                                          dev1['field6']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      //Recommmended Actions : General Public DEFAULT
                                      Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        //color: Colors.red,
                                        width: double.infinity,
                                        child: Text(
                                          'General Public',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                      Container(
                                        //margin: EdgeInsets.only(bottom: 5.0),
                                        //color: Colors.blue,
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            //recommended action based on total AQI
                                            //function call recommendedAction(genPub, totalAQI) => returns a String(recommended action)
                                            recommendAction(
                                                'General Public',
                                                getAqi(double.parse(
                                                    dev1['field7']))),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Recommended Action: User's status based
                                      Container(
                                          //margin: EdgeInsets.only(bottom: 5.0),
                                          height: 30,
                                          alignment: Alignment.centerLeft,
                                          //color: Colors.red,
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  'User Status: ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  status,
                                                  style: TextStyle(
                                                      color: statusColor(
                                                          userModel[
                                                              'userClass']),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                        //margin: EdgeInsets.only(bottom: 5.0),
                                        //color: Colors.blue,
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: FittedBox(
                                          //fit: BoxFit.contain,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            //returns a String(recommended action)
                                            recommendAction(
                                                status,
                                                getAqi(double.parse(
                                                    dev1['field7']))),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              //PROTOYPE II - TERMINAL ROAD 2
                              Container(
                                  padding: EdgeInsets.all(20.0),
                                  //height: 400,
                                  //width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 20.0,
                                          color: Colors.grey.shade700)
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Location and Temperature
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: Text(
                                                'TERMINAL ROAD 2',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 2.5),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              //color: Colors.blue,
                                              width: double.infinity,
                                              child: Text(
                                                //temperature value
                                                '$temp2 ° C',
                                                //'37° C',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //TOTAL AQI DATE and TIME
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: Text(
                                                //convert aqi value into the index range's class
                                                getAqi(double.parse(
                                                        dev2['field7']))
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: sensorReadings(
                                                        getAqi(double.parse(
                                                            dev2['field7']))),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.5),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          /*DATE
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              //color: Colors.blue,
                                              width: double.infinity,
                                              child: Text(
                                                //date value
                                                dev2_date,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          */
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 5.0),
                                                height: 30,
                                                alignment:
                                                    Alignment.centerRight,
                                                //color: Colors.blue,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        //color: Colors.red,
                                                        child: Text(
                                                          //date value
                                                          dev2_date,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 1.2,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topRight,
                                                        //color: Colors.orange,
                                                        child: Text(
                                                          //time value
                                                          'As of $dev2_time',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 1.2,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      //Ozone Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Ozone',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getOzone(double.parse(
                                                    dev2['field2'])),
                                                style: TextStyle(
                                                  //replace with color function for ozone
                                                  color: sensorReadings(
                                                      getOzone(double.parse(
                                                          dev2['field2']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //PM2.5 Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'PM2.5',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getPM(double.parse(
                                                    dev2['field3'])),
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: sensorReadings(getPM(
                                                      double.parse(
                                                          dev2['field3']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Carbon Monoxide Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Carbon  Monoxide',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getCarbon(double.parse(
                                                    dev2['field4'])),
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: sensorReadings(
                                                      getCarbon(double.parse(
                                                          dev2['field4']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Sulfur Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Sulfur Dioxide',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getSulfur(double.parse(
                                                    dev2['field5'])),
                                                style: TextStyle(
                                                  //replace with color function for sulfur
                                                  color: sensorReadings(
                                                      getSulfur(double.parse(
                                                          dev2['field5']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Nitrogen Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              //color: Colors.red,
                                              width: double.infinity,
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Nitrogen Dioxide',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              height: 30,
                                              alignment: Alignment.centerRight,
                                              width: double.infinity,
                                              child: Text(
                                                //recommended action based on total AQI
                                                //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                getNitrogen(double.parse(
                                                    dev2['field6'])),
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: sensorReadings(
                                                      getNitrogen(double.parse(
                                                          dev2['field6']))),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      //Recommmended Actions : General Public DEFAULT
                                      Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        //color: Colors.red,
                                        width: double.infinity,
                                        child: Text(
                                          'General Public',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                      Container(
                                        //margin: EdgeInsets.only(bottom: 5.0),
                                        //color: Colors.blue,
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            //recommended action based on total AQI
                                            //function call recommendedAction(genPub, totalAQI) => returns a String(recommended action)
                                            recommendAction(
                                                'General Public',
                                                getAqi(double.parse(
                                                    dev2['field7']))),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Recommended Action: User's status based
                                      Container(
                                          //margin: EdgeInsets.only(bottom: 5.0),
                                          height: 30,
                                          alignment: Alignment.centerLeft,
                                          //color: Colors.red,
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  'User Status: ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  status,
                                                  style: TextStyle(
                                                      color: statusColor(
                                                          userModel[
                                                              'userClass']),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                        //margin: EdgeInsets.only(bottom: 5.0),
                                        //color: Colors.blue,
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: FittedBox(
                                          //fit: BoxFit.contain,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            //returns a String(recommended action)
                                            recommendAction(
                                                status,
                                                getAqi(double.parse(
                                                    dev2['field7']))),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            //drawer: _isSidebarOpen ? Sidebar() : null,
            //drawer: Sidebar(name, email, pass, user),
            drawer: Sidebar(name, email, pass, side),
          );
  }
}

//SideBar Widget
class Sidebar extends StatelessWidget {
  String _name;
  String _email;
  String _pass;
  Map user;
  Sidebar(this._name, this._email, this._pass, this.user);

  @override
  Widget build(BuildContext context) {
    //print(email);

    return Drawer(
      backgroundColor: Color.fromARGB(255, 12, 94, 116),
      //border: Border.all(color: Colors.red, width: 2),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_name),
            accountEmail: Text(_email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 12, 94, 116),
              child: ClipOval(
                  child: Image.asset(
                'assets/images/profile_img.png',
                height: 1.0 * 100,
                width: 1.1 * 100,
                fit: BoxFit.cover,
              )),
            ),
            //decoration: BoxDecoration(
            //  color: Colors.blue,
            //),
            //child: Text("Sidebar"),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
            ),
            title: Text(
              "View Profile",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () async {
              //print('Hello');
              // Add your code here to handle the item press
              //Map userData = await authUser(_email, _password);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => viewProfile(userModel: user))));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mode_edit_outline,
              color: Colors.white,
            ),
            title: Text(
              "Change Password",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              //print('World');
              // Add your code here to handle the item press
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => changePass(
                            email: _email,
                            pass: _pass,
                          ))));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.white,
            ),
            title: Text(
              "More Information",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              //print('World');
              // Add your code here to handle the item press
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => moreInfo())));
            },
          ),
          Divider(
            color: Colors.black54,
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              //upon logout, 'login' is set to true, which makes the user go to login upon next app usage

              loginData.setBool('login', true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => loginPage())));
              //removes route from Stack to avoid issues
              Navigator.removeRoute(
                  context, ModalRoute.of(context) as PageRoute);

              /*
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Log Out"),
                      content: Text("Are you sure you want to log out?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Log Out"),
                          onPressed: () {
                            loginData.setBool('login', true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => loginPage())));
                            //error in removeRoute when used inside showDialog!
                            //removes route from Stack to avoid issues
                            Navigator.removeRoute(
                                context, ModalRoute.of(context) as PageRoute);
                          },
                        ),
                      ],
                    );
                  });
                  */
            },
          ),
        ],
      ),
    );
  }
}
