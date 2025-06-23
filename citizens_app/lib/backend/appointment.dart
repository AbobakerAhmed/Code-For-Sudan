//import 'hospital.dart';

class Appointment {
  String? patientName;
  String? patientAge;
  String? patientGender;
  String? patientPhoneNumber;
  String? patientAddress;
  // String? selectedState;
  // String? selectedLocality;
  // String? selectedHospital;
  // String? selectedDepartment;
  // String? selectedDoctor;

  Appointment(
      this.patientName,
      this.patientAge,
      this.patientGender,
      this.patientPhoneNumber,
      this.patientAddress,
      String selectedState,
      String selectedLocality,
      String selectedHospital,
      String selectedDepartment,
      String selectedDoctor,
      Map<String, List<String>> selectedDepartmentToDoctors) {
    // hospital = Hospital(selectedState,selectedLocality,selectedHospital,selectedDepartment,selectedDoctor,selectedDepartmentToDoctors)
  }
}
