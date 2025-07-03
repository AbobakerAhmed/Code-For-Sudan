//import 'hospital.dart';

///This is the appointment class it should get the data from booking the appointment
///the Appoinment class hasn't finished yet it need fromjson and tojson
class Appointment {
  String? patientName;
  String? patientAge;
  String? patientGender;
  String? patientPhoneNumber;
  String? patientAddress;
  String? selectedState;
  String? selectedLocality;
  String? selectedHospital;
  String? selectedDepartment;
  String? selectedDoctor;
  Map<String, String>? appoinmentData;

  Appointment(
      String name,
      String age,
      String gender,
      String phoneNumber,
      String address,
      String state,
      String locality,
      String hospital,
      String department,
      String doctor) {
    patientName = name;
    patientAge = age;
    patientGender = gender;
    patientPhoneNumber = phoneNumber;
    patientAddress = address;
    selectedState = state;
    selectedLocality = locality;
    selectedHospital = hospital;
    selectedDepartment = department;
    selectedDoctor = doctor;
    appoinmentData = {
      'patientName': name,
      'patientAge': age,
      'patientGender': gender,
      'patientPhoneNumber': phoneNumber,
      'patientAddress': address,
      'selectedState': state,
      'selectedLocality': locality,
      'selectedHospital': hospital,
      'selectedDepartment': department,
      'selectedDoctor': department,
    };
  }
}
