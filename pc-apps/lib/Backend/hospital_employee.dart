/* 
//__________________________Employee Hospital Class__________________________\\
A class that models a hospital Employee including:
  - Name
  - Phone
  - Password
  - hospital state
  - hospital locality
  - hospital name
Also contains these functions:
  - getters for each attributer
  - toJson, fromJson those used to database connection
*/

import 'person.dart'; // name, phoneNumber,and password

class HospitalEmployee extends Person {
  String _state;
  String _locality;
  String _hospitalName;
  // DocumentReference
  //     ?_hospitalReference; // This is not saved in Firestore, just for internal use

  HospitalEmployee(
      super.name,
      super.phoneNumber,
      super.password,
      this._state,
      this._locality,
      this._hospitalName,
      );
  String get state => _state;
  String get locality => _locality;
  String get hospitalName => _hospitalName;

  set state(String state) => _state = state;
  set locality(String locality) => _locality = locality;
  set hospitalName(String hospitalName) => _hospitalName = hospitalName;


  // toJson()

  /// Reconstructs HospitalEmployee from Firestore data
  factory HospitalEmployee.fromJson(Map<String, dynamic> json) {
    return HospitalEmployee(
      json['name'],
      json['phoneNumber'],
      json['password'],
      json['state'],
      json['locality'],
      json['hospitalName'],
    );
  }
} // HospitalEmployee