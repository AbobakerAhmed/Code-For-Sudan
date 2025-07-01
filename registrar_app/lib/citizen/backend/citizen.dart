class Citizen {
  String? _citizenName;
  String? _phoneNumber;
  String? _password;
  String? _gender;
  String? _address;
  DateTime? _birthDate;
  List<String>? _medicalHistory;

  Citizen(
    String citizenName,
    String phoneNumber,
    String password,
    String gender,
    String address,
    DateTime birthDate,
    List<String> medicalHistory,
  ) {
    _citizenName = citizenName;
    _phoneNumber = phoneNumber;
    _password = password;
    _gender = gender;
    _address = address;
    _birthDate = birthDate;
    _medicalHistory = medicalHistory;
  }

  // Getters
  String? get citizenName => _citizenName;
  String? get phoneNumber => _phoneNumber;
  String? get password => _password;
  String? get gender => _gender;
  String? get address => _address;
  DateTime? get birthDate => _birthDate;
  List<String>? get medicalHistory => _medicalHistory;

  // Setters
  set citizenName(String? name) => _citizenName = name;
  set phoneNumber(String? phone) => _phoneNumber = phone;
  set password(String? pass) => _password = pass;
  set gender(String? gen) => _gender = gen;
  set address(String? addr) => _address = addr;
  set birthDate(DateTime? date) => _birthDate = date;
  set medicalHistory(List<String>? history) => _medicalHistory = history;
}
