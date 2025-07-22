import 'package:mobile_app/backend/hospital_employee.dart';
import 'package:mobile_app/backend/hospital.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

class Registrar extends HospitalEmployee {
  List<Department> _departments = [];

  Registrar(
    super.name,
    super.phoneNumber,
    super.password,
    super.state,
    super.locality,
    super.hospitalName,
  );

  List<Department> get departments => _departments;

  Future<void> fetchDepartments() async {
    Hospital hos =
        await FirestoreService().getHospital(state, locality, hospitalName);
    _departments = hos.departments;
  }

  List<String> get departmentsNames {
    List<String> list = [];
    for (final dep in _departments) {
      list.add(dep.name);
    }
    return list;
  }

  // @override
  // Map<String, dynamic> toJson() {
  //   final baseJson = super.toJson();
  //   return {
  //     ...baseJson,
  //     //'departments': _departments,
  //   };
  // }

  static Future<Registrar> fromJson(Map<String, dynamic> json) async {
    Registrar reg = Registrar(
      json['name'],
      json['phoneNumber'],
      json['password'],
      json['state'],
      json['locality'],
      json['hospitalName'],
    );
    //await reg.fetchDepartments();
    return reg;
  }

//   static Future<Registrar> create(
//     String name,
//     String phoneNumber,
//     String password,
//     String state,
//     String locality,
//     String hospitalName,
//   ) async {
//     final reg = Registrar(
//       name,
//       phoneNumber,
//       password,
//       state,
//       locality,
//       hospitalName,
//     );

//     await reg.fetchDepartments();
//     return reg;
//   }
}
