// ignore_for_file: file_names

getStatus(var status) {
  if (status == '0') {
    return 'General Public';
  } else if (status == '1') {
    return 'Quite Vulnerable';
  } else if (status == '2' || status == '3') {
    return 'Vulnerable';
  } else if (status == '4' || status == '5') {
    return 'Highly Vulnerable';
  }
  return null;
}
