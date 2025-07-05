// import 'package:mobile_app/backend/person.dart';
// //import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:mobile_app/backend/citizen/hospital.dart';
// // import 'package:mobile_app/firestore_services/firestore.dart';

// class HospitalEmployee extends Person {
//   String _state;
//   String _locality;
//   String _hospitalName;
//   //late final Hospital _hospital;

//   HospitalEmployee(String name, String phoneNumber, String password,
//       this._state, this._locality, this._hospitalName)
//       : super(name, phoneNumber, password) {
//     //_hospital = FirestoreService.getHospital(_state, _locality, _hospitalName);
//   }

//   String get state => _state;
//   String get locality => _locality;
//   String get hospitalName => _hospitalName;

//   set state(String state) => _state = state;
//   set locality(String locality) => _locality = locality;
//   set hospitalName(String hospitalName) => _hospitalName = hospitalName;

//   //Hospital get hospital => _hospital;
// }

import 'package:mobile_app/backend/person.dart';
import 'package:mobile_app/backend/citizen/hospital.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

class HospitalEmployee extends Person {
  String _state;
  String _locality;
  String _hospitalName;
  //Hospital? _hospital; // This is not saved in Firestore, just for internal use

  HospitalEmployee(
    String name,
    String phoneNumber,
    String password,
    this._state,
    this._locality,
    this._hospitalName,
  ) : super(name, phoneNumber, password);

  String get state => _state;
  String get locality => _locality;
  String get hospitalName => _hospitalName;

  set state(String state) => _state = state;
  set locality(String locality) => _locality = locality;
  set hospitalName(String hospitalName) => _hospitalName = hospitalName;

  //Hospital? get hospital => _hospital;

  /// Fetches the hospital from Firestore based on state, locality, and hospital name.
  // Future<void> fetchHospital() async {
  //   Hospital hospital =
  //       await FirestoreService().getHospital(_state, _locality, _hospitalName);
  //   _hospital = hospital;
  // }

  /// Used when storing this employee in Firestore. Only stores the reference, not the Hospital object.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'state': _state,
      'locality': _locality,
      'hospitalName': _hospitalName,
    };
  }

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
}
