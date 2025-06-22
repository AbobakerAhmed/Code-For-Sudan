bool validatePhoneNumber(String phoneNumber) {
  final zainNumbers = RegExp(r'^(|099|092|090|091|096)\d{7}$');
  final sudaniNumbers = RegExp(r'^(01)\d{8}$');

  return (sudaniNumbers.hasMatch(phoneNumber) ||
      zainNumbers.hasMatch(phoneNumber));
}
