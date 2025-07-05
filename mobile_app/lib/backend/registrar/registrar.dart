import 'package:mobile_app/backend/hospital_employee.dart';
import 'package:mobile_app/backend/citizen/hospital.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

class Registrar extends HospitalEmployee {
  List<String> _departments = [];

  Registrar(
    super.name,
    super.phoneNumber,
    super.password,
    super.state,
    super.locality,
    super.hospitalName,
  );

  Future<void> fetchDepartments() async {
    Hospital hos =
        await FirestoreService().getHospital(state, locality, hospitalName);
    _departments = hos.departmentsToString();
  }

  List<String> get departments => _departments;

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      //'departments': _departments,
    };
  }

  /// ✅ This async constructor handles the fetch safely
  static Future<Registrar> fromJson(Map<String, dynamic> json) async {
    Registrar reg = Registrar(
      json['name'],
      json['phoneNumber'],
      json['password'],
      json['state'],
      json['locality'],
      json['hospitalName'],
    );
    await reg.fetchDepartments();
    return reg;
  }

  //static Future<Registrar> fromJson(Map<String, dynamic> data) async {}

  // factory Registrar.fromJson(Map<String, dynamic> json) {
  //   return Registrar(
  //     json['name'],
  //     json['phoneNumber'],
  //     json['password'],
  //     json['state'],
  //     json['locality'],
  //     json['hospitalName'],
  //     //List<String>.from(json['departments']),
  //   );
  // }
}
