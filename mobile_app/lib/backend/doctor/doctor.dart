import 'package:mobile_app/backend/citizen/hospital.dart';
import 'package:mobile_app/backend/hospital_employee.dart';

class Doctor extends HospitalEmployee {
  Department _departments;

  Doctor(
    super.name,
    super.phoneNumber,
    super.password,
    super.state,
    super.locality,
    super.hospitalName,
    this._departments,
  );

  Department get departments => _departments;
}
