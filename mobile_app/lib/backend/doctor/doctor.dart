import 'package:mobile_app/backend/hospital.dart';
import 'package:mobile_app/backend/hospital_employee.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

class Doctor extends HospitalEmployee {
  Department? _departments;

  Doctor(
    super.name,
    super.phoneNumber,
    super.password,
    super.state,
    super.locality,
    super.hospitalName,
  );

  Department get department => _departments!;

  Future<void> fetchDepartment() async {
    Hospital hos =
        await FirestoreService().getHospital(state, locality, hospitalName);
    _departments =
        hos.departments.where((dep) => dep.doctors.contains(name)).first;
  }

  static Future<Doctor> fromJson(Map<String, dynamic> json) async {
    Doctor doctor = Doctor(
      json['name'],
      json['phoneNumber'],
      json['password'],
      json['state'],
      json['locality'],
      json['hospitalName'],
    );
    return doctor;
  }
}
