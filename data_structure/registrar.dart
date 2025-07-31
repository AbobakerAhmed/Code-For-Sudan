import 'hospital.dart';
import 'hospital_employee.dart';

// this is the old registrar class
class Registrar extends HospitalEmployee {
  late List<String> _departments; // departments thos

  // constructor
  Registrar(super._name, super._phoneNumber, super._password, super._hospital,
      this._departments); //constructor

  //Getter
  List<String> getDepartments() => this._departments;

  // to Json for sending an object to the database
  Map<String, dynamic> toJson() => {
        'name': super.getName(),
        'phoneNumber': super.getPhoneNumber(),
        'password': super.getPassword(),
        'hospital': getHospital().toJson(), // Convert Hospital to JSON
        'departments': this._departments
      }; //toJson

  // from Json to construct an object from the database
  static Registrar fromJson({required Map<String, dynamic> registrar}) => Registrar(
      registrar['employeeName'] as String, // Corrected key
      registrar['phoneNumber'] as String,
      registrar['password'] as String,
      Hospital.fromJson(registrar['hospital']), // Convert JSON to Hospital
      registrar['departments'] as List<String>); // from Json
} // Registrar


