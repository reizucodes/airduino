// ignore_for_file: file_names
recommendAction(String status, String aqi) {
  String action;
  //nested switch case
  //user status => aqi => action
  switch (status) {
    //if status general public
    case 'General Public':
      //Recommended action:
      switch (aqi) {
        case 'Good':
          action = 'It\'s a good day to be active outside.';
          return action;
        case 'Fair':
          action = 'It\'s a good day to be active outside.';
          return action;
        case 'Poor':
          action = 'Wear a mask when going outside.';
          return action;
        case 'Very Poor':
          action =
              'It\'s good to exercise outside as long as you take more breaks.';
          return action;
        case 'Extremely Poor':
          action = 'Reduce prolonged/heavy exertion.';
          return action;
      }
      break;
    //if status quite vulnerable
    case 'Quite Vulnerable':
      //Recommended action:
      switch (aqi) {
        case 'Good':
          action =
              'It\'s good to exercise outside as long as you take more breaks.';
          return action;
        case 'Fair':
          action = 'Wear a mask when going outside.';
          return action;
        case 'Poor':
          action = 'Reduce prolonged/heavy exertion.';
          return action;
        case 'Very Poor':
          action = 'Keep activity low';
          return action;
        case 'Extremely Poor':
          action =
              'Keep an eye out for signs of coughing or shortness of breath.';
          return action;
      }
      break;
    //if status vulnerable
    case 'Vulnerable':
      //Recommended action:
      switch (aqi) {
        case 'Good':
          action = 'Wear a mask when going outside.';
          return action;
        case 'Fair':
          action = 'Reduce prolonged/heavy exertion.';
          return action;
        case 'Poor':
          action = 'Keep activity low';
          return action;
        case 'Very Poor':
          action =
              'Keep an eye out for signs of coughing or shortness of breath.';
          return action;
        case 'Extremely Poor':
          action = 'Always have access to quick-relief medicines.';
          return action;
      }
      break;
    //if status vulnerable
    case 'Highly Vulnerable':
      //Recommended action:
      switch (aqi) {
        case 'Good':
          action = 'Wear a mask when going outside.';
          return action;
        case 'Fair':
          action = 'Keep activity low';
          return action;
        case 'Poor':
          action =
              'Keep an eye out for signs of coughing or shortness of breath, or unusual fatigue which may indicate a serious problem';
          return action;
        case 'Very Poor':
          action = 'Always have access to quick-relief medicines.';
          return action;
        case 'Extremely Poor':
          action = 'Avoid all outdoor activities.';
          return action;
      }
      break;
    default:
  }
}
