/// A utility class for validating user input such as phone numbers and passwords.
class Validate {
  /// Validates a Sudanese phone number.
  ///
  /// Accepts:
  /// - Zain or MTN numbers starting with `099`, `092`, `090`, `091`, or `096` followed by 7 digits.
  /// - Sudani numbers starting with `01` followed by 8 digits.
  ///
  /// Example valid inputs:
  /// - `0991234567`
  /// - `0123456789`
  static bool phoneNumber(String phoneNumber) {
    final zainNumbers = RegExp(r'^(|099|092|090|091|096)\d{7}$');
    final sudaniNumbers = RegExp(r'^(01)\d{8}$');

    return sudaniNumbers.hasMatch(phoneNumber) ||
        zainNumbers.hasMatch(phoneNumber);
  }

  /// Validates the strength of a password using common security rules.
  ///
  /// A valid password must:
  /// - Be at least 8 characters long
  /// - Contain at least one lowercase letter
  /// - Contain at least one uppercase letter
  /// - Contain at least one digit
  /// - Contain at least one special character (e.g., !, @, #, $, %, etc.)
  ///
  /// Returns `true` if the password meets all requirements, otherwise `false`.
  ///
  /// Example valid passwords:
  /// - `Passw0rd!`
  /// - `Aa1@Strong`
  static bool password(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );

    return passwordRegex.hasMatch(password);
  }
}
