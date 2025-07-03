/*
//__________________________Citizen Class__________________________\\
A class that models the citizen object structure:
  - name , phone number, and password from Person class
  - gender
  - birth date // to calculat the age
  - medical history
  - state
  - locality
  - address

Also contains these functions:
  - getters for each except birth date
  - getAge that return the age from the birth data - today date
  - setters for each non-final attribute
  - addMedicalRecord that will be used by the doctor to add
    something to the citizen's medical history
  - toJson, fromJson those used to database connection
*/
import 'person.dart'; // name, phoneNumber,and password

class Citizen extends Person {
// All name, phoneNumber, and password in person
  final String _gender; //  use genders in global_variables.dart
  final DateTime _birthDate; // Store birth date instead of age
  List<String> _medicalHistory;
  String _state;
  String _locality;
  String _address;

  // Constructor
  Citizen(
    super._name,
    super._phoneNumber,
    super._password,
    this._gender,
    this._birthDate,
    this._medicalHistory,
    this._state,
    this._locality,
    this._address,
  ); // Constructor

  // Getters
  // name, phoneNumber, and password in person
  String getGender() => this._gender;
  DateTime getBirthDate() => this._birthDate;
  List<String> getMedicalHistory() => this._medicalHistory;
  String getState() => this._state;
  String getLocality() => this._locality;
  String getAddress() => this._address;

  // Calculated Age Getter
  int getAge() {
    final now = DateTime.now();
    int age = now.year - _birthDate.year;
    if (now.month < _birthDate.month ||
        (now.month == _birthDate.month && now.day < _birthDate.day)) {
      age--;
    } // if
    return age;
  } //getAge

  // Setters (for mutable attributes)
  void setMedicalHistory(List<String> history) => this._medicalHistory = history;
  void setState(String state) => this._state = state;
  void setLocality(String locality) => this._locality = locality;
  void setAddress(String address) => this._address = address;
  // No setters for _gender and _birthDate as they are final

  // Function to add a new record to the medical history
  void addMedicalRecord(String record) => _medicalHistory.add(record);

  // Convert to JSON for sending an object to the database
  Map<String, dynamic> toJson() => {
        'citizenName': super.getName(),
        'phoneNumber': super.getPhoneNumber(),
        'password': super.getPassword(),
        'gender': _gender,
        'birthDate': _birthDate.toIso8601String(), // Store DateTime as ISO string
        'medicalHistory': _medicalHistory,
        'state': _state, // Include state
        'locality': _locality, // Include locality
        'address': _address,
      };

  // Create from JSON to construct an object from the database
  factory Citizen.fromJson(Map<String, dynamic> json) => Citizen(
        json['citizenName'] as String,
        json['phoneNumber'] as String,
        json['password'] as String,
        json['gender'] as String,
        DateTime.parse(json['birthDate'] as String), // Parse ISO string back to DateTime
        (json['medicalHistory'] as List<String>?)?.map((e) => e.toString()).toList() ??
            [], // Handle null and ensure List<String>
        json['state'] as String, // Parse state
        json['locality'] as String, // Parse locality
        json['address'] as String,
      );
} // Citizen

