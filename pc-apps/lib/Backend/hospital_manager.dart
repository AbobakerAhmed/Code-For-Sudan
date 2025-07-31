import 'package:pc_apps/Backend/hospital.dart';
import 'hospital_employee.dart';
import 'diagnosed_appointment.dart';

class HospitalManager extends HospitalEmployee {
  Hospital hospital;
  HospitalManager(super._name, super._phoneNumber, super._password, super._hospitalState,
      super._hospitalLocality, super._hospitalName, this.hospital);

  // Addding Staff
  void addDoctor(){}
  void addRegistrar(String name, String phoneNumber) {}
  void addHealthOfficer() {}
  void addManager() {}
  void addStaffDetails() {}

  // Remove Staff
  void removeDoctor() {}
  void removeRegistrar() {}
  void removeHealthOfficer() {}
  void removeManager() {}
  void editStaffDetails() {}

  // Clinical Data
  void addClinicalData() {}

  // Get Appointments list
  List<DiagnosedAppointment> getAppointmentsList() {
    return [];
  }

  // Send Reports
  void sendStaffReport() {}
  void sendMedicalReport() {}

  // Send Notifications
  void sendNotification() {}
} //HospitalManager
