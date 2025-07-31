/*
  Diagnosed Appointment Class
  - this calss will be used when the doctor add the diseases and epidemic to any appointment
  - it will hold this data to drive it to be used by the health officer and in the reports for the hospital manager

+  - addMedicalRecord that will be used by the doctor to add
    something to the citizen's medical history

*/

import 'appointment.dart';

class DiagnosedAppointment extends Appointment {
  late final List<String>? _diseases; // nullable and will be setted by the doctor
  late final String? _epidemic; // nullable and will be setted by the doctor

  // constructor
  DiagnosedAppointment(
    super._patientName,
    super._patientAge,
    super._patientGender,
    super._patientPhoneNumber,
    super._patientAddress,
    super._selectedState,
    super._selectedLocality,
    super._selectedHospital,
    super._selectedDepartment,
    super._selectedDoctor,
    super._isSelfAppointment,
    this._diseases,
    this._epidemic,
  ); // constructor

  // Getters
  List<String> getDiseases() => this._diseases!; // used by the health officer + hospital manager
  String getEpidemic() => this._epidemic!; // used by the health officer + hospital manager

  // Setters
  void setDiseases(List<String> diseses) => this._diseases = diseses; // used by the doctor
  void setEpidemic(String epidemic) => this._epidemic = epidemic; // used by the doctor

  @override
  // Convert Diagnosed Appointment to JSON Map for send it to the database
  Map<String, dynamic> toJson() => {
        'patientName': getPatientName(),
        'patientAge': getPatientAge(),
        'patientGender': getPatientGender(),
        'patientPhoneNumber': getPatientPhone(),
        'patientAddress': getPatientAddress(),
        'selectedState': getPatientState(),
        'selectedLocality': getPatientLocality(),
        'selectedHospital': getPatientHospital(),
        'selectedDepartment': getPatientDepartment(),
        'selectedDoctor': getPatientDoctor(),
        'isSelfAppointment': isSelfAppointment(),
        '_diseases': _diseases,
        'epidemic': _epidemic,
      }; // toJson

  // Construct Appointment from JSON Map
  factory DiagnosedAppointment.fromJson(Map<String, dynamic> json) => DiagnosedAppointment(
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
      json['isSelfAppointment'] as bool,
      json['_diseases'] as List<String>,
      json['epidemic'] as String); // fromJson
} // DiagnosedAppointment
