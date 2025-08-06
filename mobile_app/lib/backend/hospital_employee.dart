import 'package:mobile_app/backend/person.dart';

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
