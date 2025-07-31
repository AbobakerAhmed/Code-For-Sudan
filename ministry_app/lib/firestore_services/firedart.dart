import 'package:firedart/firedart.dart';
import 'package:ministry_app/Backend/hospital.dart';
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

  //we can optimize the code by refering to hospital collection instead if doing multiple reads
  CollectionReference _hospitalCollection(String state, String locality) {
    return _firestore
        .collection(HOSPITALS)
        .document(state)
        .collection(LOCALITIES)
        .document(locality)
        .collection(DATA);
  }

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

  /// Get all states and their localities
  Future<Map<String, List<String>>> getStatesAndLocalities() async {
    try {
      // Get all state documents. In `firedart`, `.get()` on a collection
      // returns a `List<Document>`, unlike `cloud_firestore` which returns a `QuerySnapshot`.
      final stateDocs = await _firestore.collection(HOSPITALS).get();

      // Using Future.wait to fetch localities for all states concurrently,
      // which is more performant than a sequential for-loop.
      final entries = await Future.wait(
        stateDocs.map((stateDoc) async {
          final localityDocs = await stateDoc.reference
              .collection(LOCALITIES)
              .get();
          final localityIds = localityDocs.map((doc) => doc.id).toList();
          return MapEntry(stateDoc.id, localityIds);
        }),
      );

      return Map.fromEntries(entries);
    } catch (e) {
      _logError("getStatesAndLocalities", e);
      return {};
    }
  }

  /// Get all department names
  Future<List<String>> getDepartments() async {
    try {
      final departmentDocs = await _firestore.collection(DEPARTMENTS).get();
      return departmentDocs.map((doc) => doc.id).toList();
    } catch (e) {
      _logError("getDepartments", e);
      return [];
    }
  }

  /// Get all hospital names for a specific locality.
  Future<List<String>> getHospitalNames(String state, String locality) async {
    try {
      final hospitalDocs = await _hospitalCollection(state, locality).get();
      return hospitalDocs.map((doc) => doc.id).toList();
    } catch (e) {
      _logError("getHospitalNames", e);
      return [];
    }
  }

  /// Get hospitals and their departments and doctors for a locality
  Future<List<Hospital>> getHospitalsWithDepartmentsAndDoctors(
    String state,
    String locality,
  ) async {
    try {
      final hospitalDocs = await _hospitalCollection(state, locality).get();

      // Use Future.wait to fetch subcollections concurrently for better performance
      final hospitals = await Future.wait(
        hospitalDocs.map((hospitalDoc) async {
          final emergencyPhone = hospitalDoc.map[PHONE] ?? '';
          final departmentDocs = await hospitalDoc.reference
              .collection(DEPARTMENTS)
              .get();

          final departments = departmentDocs.map((deptDoc) {
            // Use .map to access fields and provide a default empty list
            final doctors = List<String>.from(deptDoc.map[DOCTORS] ?? []);
            return Department(name: deptDoc.id, doctors: doctors);
          }).toList();

          return Hospital(hospitalDoc.id, emergencyPhone, departments);
        }),
      );

      return hospitals;
    } catch (e) {
      _logError("getHospitalsWithDepartmentsAndDoctors", e);
      return [];
    }
  }

  Future<void> createHospital({
    required String state,
    required String locality,
    required String hospitalName,

    required String emergencyPhone,
    required Map<String, List<String>> departments,
  }) async {
    try {
      final hospitalDocRef = _hospitalCollection(
        state,
        locality,
      ).document(hospitalName);

      // Set hospital-level data
      await hospitalDocRef.set({PHONE: emergencyPhone});

      // Create department subcollections in a batch for efficiency
      for (var entry in departments.entries) {
        final departmentName = entry.key;
        final doctors = entry.value;
        await hospitalDocRef
            .collection(DEPARTMENTS)
            .document(departmentName)
            .set({DOCTORS: doctors});
      }
    } catch (e) {
      _logError("createHospital", e);
      rethrow;
    }
  }
}
