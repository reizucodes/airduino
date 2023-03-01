//temporary conversion for pollutant sensors and total aqi

//index: ozone(ppm)
//sensor: 10 - 1000ppb *needs conversion DONE*
String getOzone(value) {
  if (value <= 0.054) {
    return 'Good'; //up to 50
  } else if (value >= 0.055 && value <= 0.070) {
    return 'Fair'; //51-100
  } else if (value >= 0.071 && value <= 0.085) {
    return 'Poor'; //101-150
  } else if (value >= 0.086 && value <= 0.105) {
    return 'Very Poor';
  } else if (value >= 0.106 && value <= 0.200) {
    return 'Extremely Poor';
  } else if (value >= 0.201) {
    return 'Extremely Poor';
  }
  return '';
}

//index: pm2.5 (ug/m^3)
//sensor: 0 - 500 (ug/m^3)
String getPM(value) {
  if (value <= 12.0) {
    return 'Good'; //up to 50
  } else if (value >= 12.1 && value <= 35.4) {
    return 'Poor'; //51-100
  } else if (value >= 35.5 && value <= 55.4) {
    return 'Poor'; //101-150
  } else if (value >= 55.5 && value <= 150.4) {
    return 'Very Poor';
  } else if (value >= 150.5 && value <= 250.4) {
    return 'Extremely Poor';
  } else if (value >= 250.5 && value <= 500.4) {
    return 'Extremely Poor';
  }
  return '';
}

//index: carbon monoxide (ppm)
//sensor: 1-1000 ppm
String getCarbon(value) {
  if (value <= 4.4) {
    return 'Good'; //up to 50
  } else if (value >= 4.5 && value <= 9.4) {
    return 'Fair'; //51-100
  } else if (value >= 9.5 && value <= 12.4) {
    return 'Poor'; //101-150
  } else if (value >= 12.5 && value <= 15.4) {
    return 'Very Poor';
  } else if (value >= 15.5 && value <= 30.4) {
    return 'Extremely Poor';
  } else if (value >= 30.5 && value <= 50.4) {
    return 'Extremely Poor';
  }
  return '';
}

//index: sulfur dioxide (ppb)
//sensor: 1-200 ppm *needs conversion*
String getSulfur(value) {
  //value = value - 100;
  if (value <= 35) {
    return 'Good';
  } else if (value >= 36 && value <= 75) {
    return 'Fair';
  } else if (value >= 76 && value <= 185) {
    return 'Poor';
  } else if (value >= 186 && value <= 304) {
    return 'Very Poor';
  } else if (value >= 305 && value <= 604) {
    return 'Extremely Poor';
  } else if (value >= 605 && value <= 1004) {
    return 'Extremely Poor';
  }
  return '';
}

//index: nitrogen dioxide (ppb)
//sensor: 0.5 - 10ppm *needs conversion DONE*
String getNitrogen(value) {
  if (value <= 53) {
    return 'Good';
  } else if (value >= 54 && value <= 100) {
    return 'Fair';
  } else if (value >= 101 && value <= 360) {
    return 'Poor';
  } else if (value >= 361 && value <= 649) {
    return 'Very Poor';
  } else if (value >= 650 && value <= 1249) {
    return 'Extremely Poor';
  } else if (value >= 1250 && value <= 2049) {
    return 'Extremely Poor';
  }
  return '';
}

//Overall AQI
String getAqi(value) {
  if (value <= 50) {
    return 'Good';
  } else if (value >= 51 && value <= 100) {
    return 'Fair';
  } else if (value >= 101 && value <= 150) {
    return 'Poor';
  } else if (value >= 151 && value <= 200) {
    return 'Very Poor';
  } else if (value >= 201 && value <= 300) {
    return 'Extremely Poor';
  } else if (value >= 301) {
    return 'Extremely Poor';
  }
  return '';
}
