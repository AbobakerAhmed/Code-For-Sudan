class MinistryOffice {
  // Placeholder class - expand as needed
}

class MinistryEmployee {
  String _employeeName;
  String _phoneNumber;
  String _password;
  final MinistryOffice _ministryOffice;

  MinistryEmployee(
    this._employeeName,
    this._phoneNumber,
    this._password,
    this._ministryOffice,
  );

  // Getters using Dart's arrow syntax
  String get name => _employeeName;
  String get phone => _phoneNumber;
  String get password => _password;
  MinistryOffice get office => _ministryOffice;

  // Setters
  void setEmployeeName(String name) {
    _employeeName = name;
  }

  void setEmployeePhone(String phone) {
    _phoneNumber = phone;
  }

  void setPassword(String password) {
    _password = password;
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() => {
        'employeeName': _employeeName,
        'phoneNumber': _phoneNumber,
        'password': _password,
        'ministryOffice': _ministryOffice
            .toString(), // Replace with actual .toJson() if needed
      };

  // Create object from JSON
  static MinistryEmployee formJson(Map<String, dynamic> json) {
    return MinistryEmployee(
      json['employeeName'],
      json['phoneNumber'],
      json['password'],
      MinistryOffice(), // Replace with actual deserialization
    );
  }
}
