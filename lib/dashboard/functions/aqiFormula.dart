/*
  Where Ip = the index for pollutant p
  Cp = the truncated concentration of pollutant p
  BPHi = the concentration breakpoint that is greater than or equal to Cp
  BPLo = the concentration breakpoint that is less than or equal to Cp
  IHi = the AQI value corresponding to BPHi
  ILo = the AQI value corresponding to BPLo
  
  //convert to formula
  Ip = ((IHi - ILo)/(BPHi - BPLo)) * (Cp - BPLo) + ILo;
  //o = ((150-101)/(0.085-0.071))*(0.078 - 0.071) + 101;
*/

//get total aqi
int getHighest(values) {
  values.sort();
  return values.last;
}

//compute pollutant index (Ip)
int computeAqi(cP, bpLo, bpHi, iLo, iHi) {
  double iP = 0;
  iP = ((iHi - iLo) / (bpHi - bpLo)) * (cP - bpLo) + iLo;
  return iP.ceil();
}

//nitrogen aqi
int assignNo2(value) {
  int aqi = 0;
  double bpHi = 0;
  double bpLo = 0;
  int iHi = 0;
  int iLo = 0;
  //assign values
  if (value <= 53) {
    //return 'Good'; //0 - 50
    bpLo = 0;
    bpHi = 53;
    iLo = 0;
    iHi = 50;
  } else if (value >= 54 && value <= 100) {
    //return 'Fair'; //51-100
    bpLo = 54;
    bpHi = 100;
    iLo = 51;
    iHi = 100;
  } else if (value >= 101 && value <= 360) {
    //return 'Poor'; //101-150
    bpLo = 101;
    bpHi = 360;
    iLo = 101;
    iHi = 150;
  } else if (value >= 361 && value <= 649) {
    //return 'Very Poor'; //151 - 200
    bpLo = 361;
    bpHi = 649;
    iLo = 151;
    iHi = 200;
  } else if (value >= 650 && value <= 1249) {
    //return 'Extremely Poor'; //201 - 300
    bpLo = 650;
    bpHi = 1249;
    iLo = 201;
    iHi = 300;
  } else if (value >= 1250 && value <= 2049) {
    //return 'Extremely Poor'; //301 - 500
    bpLo = 1250;
    bpHi = 2049;
    iLo = 301;
    iHi = 500;
  }
  aqi = computeAqi(value, bpLo, bpHi, iLo, iHi);
  return aqi;
}

//sulfur aqi
int assignSo2(value) {
  int aqi = 0;
  double bpHi = 0;
  double bpLo = 0;
  int iHi = 0;
  int iLo = 0;
  //assign values
  if (value <= 35) {
    //return 'Good'; //0 - 50
    bpLo = 0;
    bpHi = 35;
    iLo = 0;
    iHi = 50;
  } else if (value >= 36 && value <= 75) {
    //return 'Fair'; //51-100
    bpLo = 36;
    bpHi = 75;
    iLo = 51;
    iHi = 100;
  } else if (value >= 76 && value <= 185) {
    //return 'Poor'; //101-150
    bpLo = 76;
    bpHi = 185;
    iLo = 101;
    iHi = 150;
  } else if (value >= 186 && value <= 304) {
    //return 'Very Poor'; //151 - 200
    bpLo = 186;
    bpHi = 304;
    iLo = 151;
    iHi = 200;
  } else if (value >= 305 && value <= 604) {
    //return 'Extremely Poor'; //201 - 300
    bpLo = 305;
    bpHi = 604;
    iLo = 201;
    iHi = 300;
  } else if (value >= 605 && value <= 1004) {
    //return 'Extremely Poor'; //301 - 500
    bpLo = 605;
    bpHi = 1004;
    iLo = 301;
    iHi = 500;
  }
  aqi = computeAqi(value, bpLo, bpHi, iLo, iHi);
  return aqi;
}

//co2 aqi
int assignCo2(value) {
  int aqi = 0;
  double bpHi = 0;
  double bpLo = 0;
  int iHi = 0;
  int iLo = 0;
  //assign values
  if (value <= 4.4) {
    //return 'Good'; //0 - 50
    bpLo = 0;
    bpHi = 4.4;
    iLo = 0;
    iHi = 50;
  } else if (value >= 4.5 && value <= 9.4) {
    //return 'Fair'; //51-100
    bpLo = 4.5;
    bpHi = 9.4;
    iLo = 51;
    iHi = 100;
  } else if (value >= 9.5 && value <= 12.4) {
    //return 'Poor'; //101-150
    bpLo = 9.5;
    bpHi = 12.4;
    iLo = 101;
    iHi = 150;
  } else if (value >= 12.5 && value <= 15.4) {
    //return 'Very Poor'; //151 - 200
    bpLo = 12.5;
    bpHi = 15.4;
    iLo = 151;
    iHi = 200;
  } else if (value >= 15.5 && value <= 30.4) {
    //return 'Extremely Poor'; //201 - 300
    bpLo = 15.5;
    bpHi = 30.4;
    iLo = 201;
    iHi = 300;
  } else if (value >= 30.5 && value <= 50.4) {
    //return 'Extremely Poor'; //301 - 500
    bpLo = 30.5;
    bpHi = 50.4;
    iLo = 301;
    iHi = 500;
  }
  aqi = computeAqi(value, bpLo, bpHi, iLo, iHi);
  return aqi;
}

//pm 2.5 aqi
int assignPm(value) {
  int aqi = 0;
  double bpHi = 0;
  double bpLo = 0;
  int iHi = 0;
  int iLo = 0;
  //assign values
  if (value <= 12.0) {
    //return 'Good'; //0 - 50
    bpLo = 0;
    bpHi = 12.0;
    iLo = 0;
    iHi = 50;
  } else if (value >= 12.1 && value <= 35.4) {
    //return 'Fair'; //51-100
    bpLo = 12.1;
    bpHi = 35.4;
    iLo = 51;
    iHi = 100;
  } else if (value >= 35.5 && value <= 55.4) {
    //return 'Poor'; //101-150
    bpLo = 35.5;
    bpHi = 55.4;
    iLo = 101;
    iHi = 150;
  } else if (value >= 55.5 && value <= 150.4) {
    //return 'Very Poor'; //151 - 200
    bpLo = 55.5;
    bpHi = 150.4;
    iLo = 151;
    iHi = 200;
  } else if (value >= 150.5 && value <= 250.4) {
    //return 'Extremely Poor'; //201 - 300
    bpLo = 150.5;
    bpHi = 250.4;
    iLo = 201;
    iHi = 300;
  } else if (value >= 250.5 && value <= 500.4) {
    //return 'Extremely Poor'; //301 - 500
    bpLo = 250.5;
    bpHi = 500.4;
    iLo = 301;
    iHi = 500;
  }
  aqi = computeAqi(value, bpLo, bpHi, iLo, iHi);
  return aqi;
}

//ozone aqi
int assignOzone(value) {
  int aqi = 0;
  double bpHi = 0;
  double bpLo = 0;
  int iHi = 0;
  int iLo = 0;
  //assign values
  if (value <= 0.054) {
    //return 'Good'; //0 - 50
    bpLo = 0;
    bpHi = 0.054;
    iLo = 0;
    iHi = 50;
  } else if (value >= 0.055 && value <= 0.070) {
    //return 'Fair'; //51-100
    bpLo = 0.055;
    bpHi = 0.070;
    iLo = 51;
    iHi = 100;
  } else if (value >= 0.071 && value <= 0.085) {
    //return 'Poor'; //101-150
    bpLo = 0.071;
    bpHi = 0.085;
    iLo = 101;
    iHi = 150;
  } else if (value >= 0.086 && value <= 0.105) {
    //return 'Very Poor'; //151 - 200
    bpLo = 0.086;
    bpHi = 0.105;
    iLo = 151;
    iHi = 200;
  } else if (value >= 0.106 && value <= 0.200) {
    //return 'Extremely Poor'; //201 - 300
    bpLo = 0;
    bpHi = 0.054;
    iLo = 201;
    iHi = 300;
  } else if (value >= 0.201) {
    //return 'Extremely Poor'; //301 - 500
    bpLo = 0.201;
    bpHi = 0.404;
    iLo = 301;
    iHi = 500;
  }
  aqi = computeAqi(value, bpLo, bpHi, iLo, iHi);
  return aqi;
}

void main() {
  //variables
  double ozone = 0.078;
  double pm = 35.9;
  double co2 = 8.4;
  double so2 = 38;
  double no2 = 23;
  int totalAqi = 0;
  print('Ozone AQI: ${assignOzone(ozone)} ');
  print('PMI AQI: ${assignPm(pm)} ');
  print('Carbon AQI: ${assignCo2(co2)} ');
  print('Sulfur AQI: ${assignSo2(so2)} ');
  print('Nitrogen AQI: ${assignNo2(no2)} ');

  var arr = [
    assignOzone(ozone),
    assignPm(pm),
    assignCo2(co2),
    assignSo2(so2),
    assignNo2(no2)
  ];
  //        [126,102,90]
  totalAqi = getHighest(arr);
  print('Total AQI: $totalAqi');
}
