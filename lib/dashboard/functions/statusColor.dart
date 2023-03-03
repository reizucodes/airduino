// ignore_for_file: file_names

import 'package:flutter/material.dart';

//for user status
statusColor(String stat) {
  switch (stat) {
    case '0':
      return Colors.green.shade800;
    case '1':
      return Colors.yellow.shade800;
    case '2':
      return Colors.orange.shade800;
    case '3':
      return Colors.orange.shade800;
    case '4':
      return Colors.red.shade700;
    case '5':
      return Colors.red.shade700;
    default:
      Colors.black;
      break;
  }
}

//for sensor readings
sensorReadings(String value) {
  print(value);
  switch (value) {
    case 'Good':
      return Colors.green.shade800;
    case 'Fair':
      return Colors.yellow.shade800;
    case 'Poor':
      return Colors.orange.shade800;
    case 'Very Poor':
      return Colors.orange.shade800;
    case 'Extremely Poor':
      return Colors.red.shade800;
    default:
      Colors.black;
      break;
  }
}
