import 'package:flutter/material.dart';
import './infoBox.dart';

class moreInfo extends StatefulWidget {
  @override
  State<moreInfo> createState() => moreInfoState();
}

class moreInfoState extends State<moreInfo> {
  Map<dynamic, dynamic> info = {
    'ozone': {
      'title': 'Ozone',
      'description':
          'Ground ozone, which is formed by the reaction of sunlight with nitrogen oxides and volatile organic compounds, can have harmful effects on respiratory health. Exposure to ground-level ozone can cause irritation of the respiratory system, aggravate asthma, and increase the risk of respiratory infections. Long-term exposure to ozone was associated with an increased risk of hospitalization for asthma.',
    },
    'pm': {
      'title': 'PM 2.5',
      'description':
          'PM2.5 refers to fine particulate matter with a diameter of 2.5 micrometers or less. Exposure to PM2.5 can cause a range of respiratory and cardiovascular health effects, including aggravation of asthma, chronic bronchitis, and emphysema, as well as increased risk of lung cancer and cardiovascular disease. Long-term exposure to PM2.5 was associated with an increased risk of hospitalization for pneumonia.',
    },
    'carbon': {
      'title': 'Carbon Monoxide',
      'description':
          'Carbon monoxide is a poisonous gas that is produced by the incomplete combustion of fossil fuels. Exposure to high levels of carbon monoxide can be fatal, and even low levels can cause headaches, dizziness, nausea, and other symptoms. Exposure to carbon monoxide can exacerbate respiratory symptoms in people with pre-existing respiratory conditions, such as asthma and chronic obstructive pulmonary disease (COPD).',
    },
    'sulfur': {
      'title': 'Sulfur Dioxide',
      'description':
          'Sulfur dioxide is a gas that is produced by the combustion of fossil fuels that contain sulfur. Exposure to sulfur dioxide can cause respiratory irritation, aggravation of asthma, and increased risk of respiratory infections. Long-term exposure to sulfur dioxide was associated with an increased risk of hospitalization for tuberculosis.',
    },
    'nitrogen': {
      'title': 'Nitrogen Dioxide',
      'description':
          'Nitrogen dioxide is a gas that is produced by the combustion of fossil fuels at high temperatures. Exposure to nitrogen dioxide can cause respiratory irritation, aggravation of asthma, and increased risk of respiratory infections. Long-term exposure to nitrogen dioxide was associated with an increased risk of hospitalization for chronic bronchitis.',
    },
  };
  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 94, 116),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                  width: 11 * 7,
                  height: 13 * 7,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  'Respiratory Effects of Pollution',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5),
                ),
              ),
              InfoBox(data: info['ozone']),
              InfoBox(data: info['pm']),
              InfoBox(data: info['carbon']),
              InfoBox(data: info['sulfur']),
              InfoBox(data: info['nitrogen']),
            ]),
      )),
    );
  }
}
