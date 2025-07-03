import 'package:mobile_app/backend/person.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mobile_app/backend/citizen/hospital.dart';
// import 'package:mobile_app/firestore_services/firestore.dart';

class HospitalEmployee extends Person {
  String _state;
  String _locality;
  String _hospitalName;
  //late final Hospital _hospital;

  HospitalEmployee(String name, String phoneNumber, String password,
      this._state, this._locality, this._hospitalName)
      : super(name, phoneNumber, password) {
    //_hospital = FirestoreService.getHospital(_state, _locality, _hospitalName);
  }

  String get state => _state;
  String get locality => _locality;
  String get hospitalName => _hospitalName;

  //Hospital get hospital => _hospital;
}
