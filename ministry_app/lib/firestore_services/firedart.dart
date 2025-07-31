import 'package:firedart/firedart.dart';
import 'package:ministry_app/Backend/ministry_employee.dart';

const apiKey = 'AIzaSyDQG58nyruo1dhLWcoDz2vpM3wQHjRMu5c'; // api key
const projectId = 'health-sudan-app'; // project id

const String HOSPITALS = "hospitals";
const String LOCALITIES = "localities";
const String DEPARTMENTS = "departments";
const String DOCTORS = "doctors";
const String PHONE = "phone";
const String DATA = "data";
const String CITIZENS = "citizens";
const String REGISTRARS = "registrars";
const String MINISTRY_EMPLOYEE = "ministry_employee";
const String NAME = "name";
const String PHONENUMBER = "phoneNumber";
const String ADDRESS = "address";
const String GENDER = "gender";
const String STATE = "state";
const String LOCALITY = "locality";
const String PASSWORD = "password";
const String BIRTHDATE = "birthDate";
const String MEDICAL_HISTORY = "medicalHistory";

class FirestoreService {
  void _logError(String method, Object e) => print("[$method] Error: $e");

  final _firestore = Firestore.instance;

  CollectionReference get _ministryEmployeeCollection =>
      _firestore.collection(MINISTRY_EMPLOYEE);

  Future<MinistryEmployee> getMinistryEmployee(String phone) async {
    try {
      // Query for a user with the matching phone number
      final querySnapshot = await _ministryEmployeeCollection
          .where(PHONENUMBER, isEqualTo: phone)
          .get();

      if (querySnapshot.isEmpty) {
        // No user found with that phone number
        throw Exception("No user found with that phone number");
      } else {
        // User found, now check the password
        final employeeDoc = querySnapshot.first;
        final employeeData = employeeDoc.map;

        final employee = MinistryEmployee.fromJson(MinistryEmp: employeeData);
        return employee;
      }
    } catch (e) {
      // Handle potential errors (e.g., network issues, invalid data)
      _logError("getMinistryEmployee", e);
      rethrow;
    }
  }

  /// Check if a ministry employee exists and if the password is correct
  Future<(bool, bool)> checkMinistryLogin(
    String phoneNumber,
    String password,
  ) async {
    try {
      final querySnapshot = await _ministryEmployeeCollection
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.isEmpty) {
        // No user found with that phone number
        return (false, false);
      } else {
        // User found, now check the password
        final employeeDoc = querySnapshot.first;

        final employeeData = employeeDoc.map;
        if (employeeData[PASSWORD] != password) {
          print('password is incorrect\n${employeeData[PASSWORD]}\n$password');
        }
        return (
          true,
          employeeData[PASSWORD] == password,
        ); // Employee found, check password
      }
    } catch (e) {
      _logError("checkMinistryLogin", e);
      return (false, false);
    }
  }
}
