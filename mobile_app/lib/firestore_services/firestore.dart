import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/backend/registrar/appoinment.dart';
import 'package:mobile_app/backend/citizen/hospital.dart';
import 'package:mobile_app/backend/citizen/citizen.dart';
import 'package:mobile_app/backend/registrar/registrar.dart';

// Constants
const String HOSPITALS = "hospitals";
const String LOCALITIES = "localities";
const String DEPARTMENTS = "departments";
const String DOCTORS = "doctors";
const String PHONE = "phone";
const String DATA = "data";
const String CITIZENS = "citizens";
const String REGISTRARS = "registrars";
const String NAME = "name";
const String PHONENUMBER = "phoneNumber";
const String ADDRESS = "address";
const String GENDER = "gender";
const String STATE = "state";
const String LOCALITY = "locality";
const String PASSWORD = "password";
const String BIRTHDATE = "birthDate";

// Arabic field labels
const String FIELD_NAME = "الإسم";
const String FIELD_AGE = "العمر";
const String FIELD_GENDER = "الجنس";
const String FIELD_PHONE = "الهاتف";
const String FIELD_ADDRESS = "السكن";
const String FIELD_DOCTOR = "الدكتور";
const String FIELD_STATE = "الولاية";
const String FIELD_LOCALITY = "المحلية";
const String FIELD_HOSPITAL = "المستشفى";
const String FIELD_DEPARTMENT = "القسم";
const String FIELD_TIME = 'موعد الحجز';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _logError(String method, Object e) => print("[$method] Error: $e");

  //we can optimize the code by refering to hospital collection instead if doing multiple reads
  CollectionReference<Map<String, dynamic>> _hospitalCollection(
          String state, String locality) =>
      _firestore
          .collection(HOSPITALS)
          .doc(state)
          .collection(LOCALITIES)
          .doc(locality)
          .collection(DATA);

  /// Check if a citizen exists and if the password is correct
  Future<(bool, bool)> searchCitizen(
      String phoneNumber, String password) async {
    try {
      final snapshot = await _firestore
          .collection(CITIZENS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isEmpty) return (false, false);

      final data = snapshot.docs.first.data();
      return (true, data[PASSWORD] == password);
    } catch (e) {
      _logError("searchCitizen", e);
      return (false, false);
    }
  }

  Future<(bool, bool)> searchRegistrar(
      String phoneNumber, String password) async {
    try {
      final snapshot = await _firestore
          .collection(REGISTRARS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isEmpty) return (false, false);

      final data = snapshot.docs.first.data();
      return (true, data[PASSWORD] == password);
    } catch (e) {
      _logError("searchRegistrar", e);
      return (false, false);
    }
  }

  /// Retrieve a Citizen object by phone and password
  Future<Citizen> getCitizen(String phoneNumber, String password) async {
    final snapshot = await _firestore
        .collection(CITIZENS)
        .where(PHONENUMBER, isEqualTo: phoneNumber)
        .get();

    return Citizen.fromJson(snapshot.docs.first.data());
  }

  Future<Registrar> getRegistrar(String phoneNumber, String password) async {
    final snapshot = await _firestore
        .collection(REGISTRARS)
        .where(PHONENUMBER, isEqualTo: phoneNumber)
        .get();

    final Registrar reg = await Registrar.fromJson(snapshot.docs.first.data());

    return reg;
  }

  /// Create a new Citizen document
  Future<void> createCitizen(Citizen citizen) async {
    try {
      await _firestore.collection(CITIZENS).add(citizen.toJson());
    } catch (e) {
      _logError("createCitizen", e);
    }
  }

  /// Create a new appointment in nested hospital/department structure
  Future<void> createAppointment(Appointment appointment) async {
    try {
      final departmentDoc = await _firestore
          .collection(HOSPITALS)
          .doc(appointment.state)
          .collection(LOCALITIES)
          .doc(appointment.locality)
          .collection(DATA)
          .doc(appointment.hospital)
          .collection(DEPARTMENTS)
          .doc(appointment.department)
          .get();

      if (!departmentDoc.exists) throw Exception("Department does not exist");

      await departmentDoc.reference.collection("appointments").add({
        FIELD_NAME: appointment.name,
        FIELD_AGE: appointment.age,
        FIELD_GENDER: appointment.gender,
        FIELD_PHONE: appointment.phoneNumber,
        FIELD_ADDRESS: appointment.address,
        FIELD_DOCTOR: appointment.doctor,
        FIELD_STATE: appointment.state,
        FIELD_LOCALITY: appointment.locality,
        FIELD_HOSPITAL: appointment.hospital,
        FIELD_DEPARTMENT: appointment.department,
        FIELD_TIME: appointment.time
      });
    } catch (e) {
      _logError("createAppointment", e);
    }
  }

  /// Get all states and their localities
  Future<Map<String, List<String>>> getStatesAndLocalities() async {
    try {
      final snapshot = await _firestore.collection(HOSPITALS).get();
      final result = <String, List<String>>{};

      for (var doc in snapshot.docs) {
        final localities = await doc.reference.collection(LOCALITIES).get();
        result[doc.id] = localities.docs.map((e) => e.id).toList();
      }

      return result;
    } catch (e) {
      _logError("getStatesAndLocalities", e);
      return {};
    }
  }

  /// Get hospitals and their departments and doctors for a locality
  Future<List<Hospital>> getHospitalsWithDepartmentsAndDoctors(
      String state, String locality) async {
    try {
      final hospitalsSnapshot =
          await _hospitalCollection(state, locality).get();
      final hospitals = <Hospital>[];

      for (var hospitalDoc in hospitalsSnapshot.docs) {
        final phone = hospitalDoc.get(PHONE);
        final departmentsSnapshot =
            await hospitalDoc.reference.collection(DEPARTMENTS).get();

        final departments = departmentsSnapshot.docs.map((dept) {
          final doctors = List<String>.from(dept.get(DOCTORS));
          return Department(name: dept.id, doctors: doctors);
        }).toList();

        hospitals.add(Hospital(hospitalDoc.id, phone, departments));
      }

      return hospitals;
    } catch (e) {
      _logError("getHospitalsWithDepartmentsAndDoctors", e);
      return [];
    }
  }

  /// Get a hospital's details
  // static Future<Hospital> getHospital(
  //     String state, String locality, String hospitalName) async {
  //   final doc =
  //       await _hospitalCollection(state, locality).doc(hospitalName).get();
  //   return Hospital(doc.id, doc.get(PHONE), doc.get(DEPARTMENTS));
  // }

  Future<Hospital> getHospital(
      String state, String locality, String hospitalName) async {
    try {
      final doc =
          await _hospitalCollection(state, locality).doc(hospitalName).get();

      if (!doc.exists) throw Exception("Hospital not found");

      final phone = doc.get(PHONE);

      // Fetch the departments subcollection
      final departmentsSnapshot =
          await doc.reference.collection(DEPARTMENTS).get();
      final departments = departmentsSnapshot.docs.map((dept) {
        final doctors = List<String>.from(dept.get(DOCTORS));
        return Department(name: dept.id, doctors: doctors);
      }).toList();

      return Hospital(doc.id, phone, departments);
    } catch (e) {
      _logError("getHospital", e);
      rethrow;
    }
  }

  /// Retrieve appointments from a specific department
  Future<List<Appointment>> getAppointments(
    String state,
    String locality,
    String hospitalName,
    String departmentName,
  ) async {
    try {
      final departmentDoc = await _firestore
          .collection(HOSPITALS)
          .doc(state)
          .collection(LOCALITIES)
          .doc(locality)
          .collection(DATA)
          .doc(hospitalName)
          .collection(DEPARTMENTS)
          .doc(departmentName)
          .get();

      if (!departmentDoc.exists) return [];

      final appointmentsSnapshot =
          await departmentDoc.reference.collection("appointments").get();
      return appointmentsSnapshot.docs
          .map((doc) => Appointment(
              name: doc.get(FIELD_NAME),
              age: doc.get(FIELD_AGE),
              gender: doc.get(FIELD_GENDER),
              phoneNumber: doc.get(FIELD_PHONE),
              address: doc.get(FIELD_ADDRESS),
              state: state,
              locality: locality,
              hospital: hospitalName,
              department: departmentName,
              doctor: doc.get(FIELD_DOCTOR),
              time: (doc.get(FIELD_TIME) as Timestamp).toDate().add(
                  const Duration(hours: 2)) //to convert time from UTC to UTC+2
              ))
          .toList();
    } catch (e) {
      _logError("getAppointments", e);
      return [];
    }
  }

  /// update an existing appointment
  Future<void> updateAppointment(Appointment appointment) async {
    try {
      final querySnapshot = await _firestore
          .collection(HOSPITALS)
          .doc(appointment.state)
          .collection(LOCALITIES)
          .doc(appointment.locality)
          .collection(DATA)
          .doc(appointment.hospital)
          .collection(DEPARTMENTS)
          .doc(appointment.department)
          .collection("appointments")
          .where('الهاتف', isEqualTo: appointment.phoneNumber)
          .limit(1) // safety: get only one
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception(
            "Appointment not found for phone: ${appointment.phoneNumber}");
      }

      final doc = querySnapshot.docs.first;
      await doc.reference.update({
        FIELD_NAME: appointment.name,
        FIELD_AGE: appointment.age,
        FIELD_GENDER: appointment.gender,
        FIELD_PHONE: appointment.phoneNumber,
        FIELD_ADDRESS: appointment.address,
        FIELD_DOCTOR: appointment.doctor,
        FIELD_TIME: appointment.time,
      });
    } catch (e) {
      _logError("updateAppointment", e);
    }
  }

  /// delete an existing appointment
  Future<void> deleteAppointment(Appointment appointment) async {
    try {
      final querySnapshot = await _firestore
          .collection(HOSPITALS)
          .doc(appointment.state)
          .collection(LOCALITIES)
          .doc(appointment.locality)
          .collection(DATA)
          .doc(appointment.hospital)
          .collection(DEPARTMENTS)
          .doc(appointment.department)
          .collection("appointments")
          .where('الهاتف', isEqualTo: appointment.phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception(
            "Appointment not found for phone: ${appointment.phoneNumber}");
      }

      final doc = querySnapshot.docs.first;

      await doc.reference.delete();
    } catch (e) {
      _logError("deleteAppointment", e);
    }
  }

  /// Fetch list of medical advices
  Future<List<String>> getMedicalAdvices() async {
    try {
      final snapshot = await _firestore.collection('medical_advices').get();
      return snapshot.docs.map((doc) => doc.get('advice') as String).toList();
    } catch (e) {
      _logError("getMedicalAdvices", e);
      return [];
    }
  }

  /// Retrieve emergency contact numbers of hospitals by state and locality
  Future<Map<String, Map<String, List<HospitalEmergency>>>>
      getHospitalsEmergencyData() async {
    final data = <String, Map<String, List<HospitalEmergency>>>{};

    try {
      final stateSnapshot = await _firestore.collection(HOSPITALS).get();

      for (var stateDoc in stateSnapshot.docs) {
        final stateName = stateDoc.id;
        data[stateName] = {};

        final localitySnapshot =
            await stateDoc.reference.collection(LOCALITIES).get();

        for (var localityDoc in localitySnapshot.docs) {
          final localityName = localityDoc.id;
          data[stateName]![localityName] = [];

          final hospitalSnapshot =
              await localityDoc.reference.collection(DATA).get();

          for (var hospitalDoc in hospitalSnapshot.docs) {
            final name = hospitalDoc.id;
            final phone = hospitalDoc.get(PHONE);
            data[stateName]![localityName]!
                .add(HospitalEmergency(name: name, phone: phone));
          }
        }
      }
    } catch (e) {
      _logError("getHospitalsEmergencyData", e);
    }

    return data;
  }
}

/*
  // UPDATE
  Future<void> updateNotify(
    String docID,
    String type,
    String title,
    String mes,
  ) {
    return notifications.doc(docID).update({
      "type": type,
      "title": title,
      "time": Timestamp.now(),
      "mes": mes,
    });
  }
*/

/*
  // DELETE
  Future<void> deleteNotify(String docID) {
    return notifications.doc(docID).delete();
  }
*/
