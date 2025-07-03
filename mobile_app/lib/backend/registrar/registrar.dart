import 'package:mobile_app/backend/hospital_employee.dart';
//import 'package:mobile_app/backend/citizen/hospital.dart';

class Registrar extends HospitalEmployee {
  //late final String name;
  //late final String hospital;
  late final List<String> _departments;
  //late final String phoneNumber;
  //String? password;

  Registrar(super.name, super.phoneNumber, super.password, super.state,
      super.locality, super.hospitalName, this._departments) {
    //_departments = super.hospital.departmentsToString();
  }

  List<String> get departments => _departments;
}
