import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/backend/person.dart';

// class Citizen {
//   String? _citizenName;
//   String? _phoneNumber;
//   String? _password;
//   String? _gender;
//   String? _address;
//   DateTime? _birthDate;
//   List<String>? _medicalHistory;

//   Citizen(
//     String citizenName,
//     String phoneNumber,
//     String password,
//     String gender,
//     String address,
//     DateTime birthDate,
//     List<String> medicalHistory,
//   ) {
//     _citizenName = citizenName;
//     _phoneNumber = phoneNumber;
//     _password = password;
//     _gender = gender;
//     _address = address;
//     _birthDate = birthDate;
//     _medicalHistory = medicalHistory;
//   }

//   // Getters
//   String? get citizenName => _citizenName;
//   String? get phoneNumber => _phoneNumber;
//   String? get password => _password;
//   String? get gender => _gender;
//   String? get address => _address;
//   DateTime? get birthDate => _birthDate;
//   List<String>? get medicalHistory => _medicalHistory;

//   // Setters
//   set citizenName(String? name) => _citizenName = name;
//   set phoneNumber(String? phone) => _phoneNumber = phone;
//   set password(String? pass) => _password = pass;
//   set gender(String? gen) => _gender = gen;
//   set address(String? addr) => _address = addr;
//   set birthDate(DateTime? date) => _birthDate = date;
//   set medicalHistory(List<String>? history) => _medicalHistory = history;
// }

class Citizen extends Person {
  final String _gender;
  final DateTime _birthDate;
  List<String> _medicalHistory;
  String _state;
  String _locality;
  String _address;

  Citizen(
    super.name,
    super.phoneNumber,
    super.password,
    this._gender,
    this._birthDate,
    this._medicalHistory,
    this._state,
    this._locality,
    this._address,
  );

  String get gender => _gender;
  DateTime get birthDate => _birthDate;
  List<String> get medicalHistory => _medicalHistory;
  String get state => _state;
  String get locality => _locality;
  String get address => _address;

  int get age {
    final now = DateTime.now();
    int age = now.year - _birthDate.year;
    if (now.month < _birthDate.month ||
        (now.month == _birthDate.month && now.day < _birthDate.day)) {
      age--;
    }
    return age;
  }

// Setters (all using consistent syntax)
  set medicalHistory(List<String> history) => _medicalHistory = history;
  set state(String state) => _state = state;
  set locality(String locality) => _locality = locality;
  set address(String address) => _address = address;

  void addMedicalRecord(String record) {
    _medicalHistory.add(record);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'password': password,
        'gender': gender,
        'birthDate': birthDate,
        'medicalHistory': medicalHistory,
        'state': state,
        'locality': locality,
        'address': address,
      };

  static Citizen fromJson(Map<String, dynamic> json) => Citizen(
        json['name'],
        json['phoneNumber'],
        json['password'],
        json['gender'],
        (json['birthDate'] as Timestamp).toDate(),
        List<String>.from(json['medicalHistory']),
        json['state'],
        json['locality'],
        json['address'],
      );
}
