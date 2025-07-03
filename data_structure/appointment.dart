/*
//__________________________Appointment Class__________________________\\
A class that models the Appointment object structure:
  - personal data:
    - name 
    - phone number
    - gender
    - age
+    - medical history // how to make the doctor able to add something to the medical history
  - Address info
    - state
    - locality
    - address
  - Hosital info
    - hosital
    - department
    - doctor
 
Also contains these functions:
  - getters for each attribute
  - setters for each non-final attribute
  - toJson, fromJson those used to database connection
*/

class Appointment {
  // there is no password here, so we didn't extend Person
  // personal info
  final String _patientName;
  final String _patientPhoneNumber;
  final String _patientGender;
  final int _patientAge;
  // address info
  final String _selectedState;
  final String _selectedLocality;
  final String _patientAddress;
  // where the appointment should be gone
  final String _selectedHospital;
  final String _selectedDepartment;
  final String _selectedDoctor;
  final bool _isSelfAppointment;
  // constructor 1: to creating appointment (and receive them by the registrar)
  Appointment(
      this._patientName,
      this._patientAge,
      this._patientGender,
      this._patientPhoneNumber,
      this._patientAddress,
      this._selectedState,
      this._selectedLocality,
      this._selectedHospital,
      this._selectedDepartment,
      this._selectedDoctor,
      this._isSelfAppointment); // constructor

  // Getters
  String getPatientName() => this._patientName;
  int getPatientAge() => this._patientAge;
  String getPatientPhone() => this._patientPhoneNumber;
  String getPatientGender() => this._patientGender;
  String getPatientAddress() => this._patientAddress;
  String getPatientState() => this._selectedState;
  String getPatientLocality() => this._selectedLocality;
  String getPatientHospital() => this._selectedHospital;
  String getPatientDepartment() => this._selectedDepartment;
  String getPatientDoctor() => this._selectedDoctor;
  bool isSelfAppointment() => this._isSelfAppointment;

  // Convert Appointment to JSON Map for send it to the database
  Map<String, dynamic> toJson() => {
        'patientName': _patientName,
        'patientAge': _patientAge,
        'patientGender': _patientGender,
        'patientPhoneNumber': _patientPhoneNumber,
        'patientAddress': _patientAddress,
        'selectedState': _selectedState,
        'selectedLocality': _selectedLocality,
        'selectedHospital': _selectedHospital,
        'selectedDepartment': _selectedDepartment,
        'selectedDoctor': _selectedDoctor,
        'isSelfAppointment': _isSelfAppointment
      }; // toJson

  // Construct Appointment from JSON Map
  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
      json['patientName'] as String,
      json['patientAge'] as int,
      json['patientGender'] as String,
      json['patientPhoneNumber'] as String,
      json['patientAddress'] as String,
      json['selectedState'] as String,
      json['selectedLocality'] as String,
      json['selectedHospital'] as String,
      json['selectedDepartment'] as String,
      json['selectedDoctor'] as String,
      json['isSelfAppointment'] as bool); // fromJson
} // Appointment
