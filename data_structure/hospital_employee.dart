/* 
//__________________________Employee Hospital Class__________________________\\
A class that models a hospital Employee including:
  - state
  - locality
  - location
  - departments and dictors
  - emergency number
Also contains these functions:
  - getters for each attributer
+  - setDepartmentToDoctors
+  - addDeprtment, removeDepartment used by the ministry employee
+  - addDoctor, removeDoctor that used be the hospital manager
  - toJson, fromJson those used to database connection
*/
import 'hospital.dart';
import 'person.dart'; // name, phoneNumber,and password

class HospitalEmployee extends Person {
// All name, phoneNumber, and password in person
  final Hospital _hospital; // in which hospital this employee works

  // Constructor
  HospitalEmployee(super._name, super._phoneNumber, super._password, this._hospital);

  // Getters
  // name, phoneNumber, and password in person
  Hospital getHospital() => this._hospital;

  // no setters (hospital is final)

  // to Json for sending an object to the database
  Map<String, dynamic> toJson() => {
        'name': super.getName(),
        'phoneNumber': super.getPhoneNumber(),
        'password': super.getPassword(),
        'hospital': _hospital.toJson(), // Convert Hospital to JSON
      };

  // from Json to construct an object from the database
  static HospitalEmployee fromJson({required Map<String, dynamic> hostEmp}) => HospitalEmployee(
        hostEmp['name'] as String, // Corrected key
        hostEmp['phoneNumber'] as String,
        hostEmp['password'] as String,
        Hospital.fromJson(hostEmp['hospital']), // Convert JSON to Hospital
      );
} // HospitalEmployee

