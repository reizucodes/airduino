import 'package:flutter/material.dart';

class InfoBox extends StatefulWidget {
  Map data;
  InfoBox({required this.data});
  @override
  State<InfoBox> createState() => InfoBoxState(data);
}

class InfoBoxState extends State<InfoBox> {
  Map _data;
  InfoBoxState(this._data);
  @override
  Widget build(BuildContext context) {
    print(_data);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      //height: 300,
      width: 350,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(255, 34, 34, 34),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 4,
            offset: Offset(0, 3), // changes the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white70,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              _data['title'].toString().toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Divider(
            color: Colors.black,
            height: 1,
            thickness: 1,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            child: Text(
              _data['description'].toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
