// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_final_fields, use_build_context_synchronously, no_logic_in_create_state, must_be_immutable, sort_child_properties_last, prefer_adjacent_string_concatenation, prefer_typing_uninitialized_variables, unused_local_variable, prefer_const_declarations, avoid_print
import 'package:airduino/dashboard/functions/conversionMethod.dart';
import 'package:airduino/dashboard/functions/deviceReading.dart';
import 'package:airduino/dashboard/functions/recommendAction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'functions/getStatus.dart';
import '../auth/loginPage.dart';
import './profile/viewProfile.dart';
import './profile/changePass.dart';
import 'functions/statusColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  //gloabl var fordevice data
  Map proto_01 = {};
  Map proto_02 = {};
  Map dev1 = {};
  //sidebar Variables
  var email;
  var pass;
  var name;
  var status;
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
    //PDID-02 device reading
    final String api02 =
        'https://api.thingspeak.com/channels/2036851/feeds.json?api_key=9XT7144SEWL028E4&results=1';
    //function call for latest reading fetching
    //Map pd02 = await getReadings(api02);
    //print(pd02);
    //dummy data for function testing
    Map<dynamic, dynamic> device = {
      'temp': 20,
      'timestamp': '14:55',
      'pm': 36.0,
      'ozone': 0.087,
      'carbon': 4.4,
      'nitro': 360,
      'sulfur': 606,
      'aqi': 120,
    };
    //await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isBodyLoading = false;
      proto_01 = device;
      dev1 = pd01;
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
    //stop page from loading
    print(model['name']);
    //await Future.delayed(Duration(seconds: 1));
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
                    dev1 = {};
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
                                    color: Colors.white70,
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
                                                //temperature value
                                                '${double.parse(dev1['field1'])} ° C',
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
                                      //TOTAL AQI and TIME
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
                                                    dev1['field7'])),
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade800,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.5),
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
                                              //color: Colors.blue,
                                              width: double.infinity,
                                              child: Text(
                                                //time value
                                                'As of ${dev1['created_at']}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Recommmended Actions : General Public DEFAULT
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
                                                'General Public',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 1.0),
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
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Recommended Action: User's status based
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
                                                  status,
                                                  style: TextStyle(
                                                      color: statusColor(
                                                          userModel[
                                                              'userClass']),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 1.5),
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
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  //recommended action based on total AQI
                                                  //function call recommendedAction(userStatus, totalAQI) => returns a String(recommended action)
                                                  recommendAction(
                                                      status,
                                                      getAqi(double.parse(
                                                          dev1['field7']))),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                    //backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              //PROTOYPE II - TERMINAL ROAD 2
                              Container(
                                  padding: EdgeInsets.all(20.0),
                                  //height: 400,
                                  //width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
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
                                                '45° C',
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
                                      //TOTAL AQI and TIME
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
                                                //compute total aqi value and; computeTotalAQI(sensor values) => returns a float value
                                                //compare aqi value and get index getIndex(computeTotalAQI()) => returns a string
                                                'Fair',
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade800,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.5),
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
                                              //color: Colors.blue,
                                              width: double.infinity,
                                              child: Text(
                                                //time value
                                                'As of 9:00 AM',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Recommmended Actions : General Public DEFAULT
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
                                                'General Public',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 1.0),
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
                                                //function call recommendedAction(genPub, totalAQI) => returns a String(recommended action)
                                                'Safe',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      //Recommended Action: User's status based
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
                                                  status,
                                                  style: TextStyle(
                                                      //color: Colors.green,
                                                      color: statusColor(
                                                          userModel[
                                                              'userClass']),
                                                      fontSize: 16,
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
                                                'Safe',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                'Fair',
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: Colors.green.shade800,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                'Fair',
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: Colors.green.shade800,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                'Fair',
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: Colors.green.shade800,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                'Fair',
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: Colors.green.shade800,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
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
                                                      fontSize: 16,
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
                                                'Fair',
                                                style: TextStyle(
                                                  //replace with color function for pm2.5
                                                  color: Colors.green.shade800,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
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
          Divider(),
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => loginPage())));
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
