import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/backend/registrar/appoinment.dart';
import 'package:mobile_app/backend/hospital.dart';
import 'package:mobile_app/backend/citizen/citizen.dart';
import 'package:mobile_app/backend/registrar/registrar.dart';
import 'package:mobile_app/backend/doctor/doctor.dart';

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
const String MEDICAL_HISTORY = "medicalHistory";

const String APPOINTMENTS = "appointments";
const String CHECKED_IN_APPOINTMENTS = "checkedInAppointments";
const String CHECKED_OUT_APPOINTMENTS = "checkedOutAppointments";
const String DIAGNOSED_APPOINTMENTS = "diagnosedAppointments";

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
const String FIELD_MEDICAL_HISTORY = 'السجل الطبي';
const String FIELD_IS_LOCAL = 'حجز محلي';
const String FIELD_FOR_ME = 'حجز لي';

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

  /// Check if a registrar exists and if the password is correct
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

  /// Check if a doctor exists and if the password is correct
  Future<(bool, bool)> searchDoctor(String phoneNumber, String password) async {
    try {
      final snapshot = await _firestore
          .collection(DOCTORS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isEmpty) return (false, false);

      final data = snapshot.docs.first.data();
      return (true, data[PASSWORD] == password);
    } catch (e) {
      _logError("searchDoctor", e);
      return (false, false);
    }
  }

  /// Retrieve a Citizen object by phone and password
  Future<Citizen> getCitizen(String phoneNumber, String password) async {
    try {
      final snapshot = await _firestore
          .collection(CITIZENS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      return Citizen.fromJson(snapshot.docs.first.data());
    } catch (e) {
      _logError("getCitizen", e);
      rethrow;
    }
  }

  /// Retrieve a Registrar object by phone and password
  Future<Registrar> getRegistrar(String phoneNumber, String password) async {
    try {
      final snapshot = await _firestore
          .collection(REGISTRARS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      final Registrar reg =
          await Registrar.fromJson(snapshot.docs.first.data());
      return reg;
    } catch (e) {
      _logError("getRegistrar", e);
      rethrow;
    }
  }

  /// Retrieve a Doctor object by phone and password
  Future<Doctor> getDoctor(String phoneNumber, String password) async {
    try {
      final snapshot = await _firestore
          .collection(DOCTORS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      final Doctor doctor = await Doctor.fromJson(snapshot.docs.first.data());

      return doctor;
    } catch (e) {
      _logError("getDoctor", e);
      rethrow;
    }
  }

  ///update the contents of an existing citizen
  ///here is the mechanizem for updating:
  ///1. the method will see in the database if document exist in the citizens collection in database.
  ///if it's found the method will update the document with the correspondent id.

  ///2. the method will update the document by matching every key on the updatedDate's map
  ///and assign the matched key on the database collection with it's correspondent updated
  ///value so it's not neccessary to update every field in the collection
  Future<void> updateCitizen(
      String phoneNumber, Map<String, dynamic> updatedData) async {
    try {
      final snapshot = await _firestore
          .collection(CITIZENS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Citizen not found");
      }

      final doc = snapshot.docs.first;

      await _firestore.collection(CITIZENS).doc(doc.id).update(updatedData);
    } catch (e) {
      _logError("updateCitizen", e);
      rethrow;
    }
  }

  ///update the contents of an existing registrar
  ///here is the mechanizem for updating:
  ///1. the method will see in the database if document exist in the registrars collection in database.
  ///if it's found the method will update the document with the correspondent id.

  ///2. the method will update the document by matching every key on the updatedDate's map
  ///and assign the matched key on the database collection with it's correspondent updated
  ///value so it's not neccessary to update every field in the collection
  Future<void> updateRegistrar(
      String phoneNumber, Map<String, dynamic> updatedData) async {
    try {
      final snapshot = await _firestore
          .collection(REGISTRARS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Registrar not found");
      }

      final doc = snapshot.docs.first;

      await _firestore.collection(REGISTRARS).doc(doc.id).update(updatedData);
    } catch (e) {
      _logError("updateRegistrar", e);
      rethrow;
    }
  }

  ///update the contents of an existing doctor
  ///here is the mechanizem for updating:
  ///1. the method will see in the database if document exist in the doctors collection in database.
  ///if it's found the method will update the document with the correspondent id.

  ///2. the method will update the document by matching every key on the updatedDate's map
  ///and assign the matched key on the database collection with it's correspondent updated
  ///value so it's not neccessary to update every field in the collection
  Future<void> updateDoctor(
      String phoneNumber, Map<String, dynamic> updatedData) async {
    try {
      final snapshot = await _firestore
          .collection(DOCTORS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Doctor not found");
      }

      final doc = snapshot.docs.first;

      await _firestore.collection(DOCTORS).doc(doc.id).update(updatedData);
    } catch (e) {
      _logError("updateDoctor", e);
      rethrow;
    }
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

      await departmentDoc.reference.collection(APPOINTMENTS).add({
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
        FIELD_MEDICAL_HISTORY: appointment.medicalHistory ?? ["None"],
        FIELD_TIME: appointment.time,
        FIELD_IS_LOCAL: appointment.isLocal ?? false,
        FIELD_FOR_ME: appointment.forMe ?? true,
      });
    } catch (e) {
      _logError("createAppointment", e);
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
          await departmentDoc.reference.collection(APPOINTMENTS).get();
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
                medicalHistory: (() {
                  try {
                    return List<String>.from(doc.get(FIELD_MEDICAL_HISTORY));
                  } catch (_) {
                    return ["None"];
                  }
                })(),
                doctor: doc.get(FIELD_DOCTOR),
                time: (doc.get(FIELD_TIME) as Timestamp).toDate(),
                isLocal: (() {
                  try {
                    return doc.get(FIELD_IS_LOCAL);
                  } catch (_) {
                    return false;
                  }
                })(),
                forMe: (() {
                  try {
                    return doc.get(FIELD_FOR_ME);
                  } catch (_) {
                    return true;
                  }
                })(),
              ))
          .toList();
    } catch (e) {
      _logError("getAppointments", e);
      return [];
    }
  }

  ///Search if an appointment does exist
  ///1. if the appointment is for the user the method will check for the appointments with
  ///  the same phone number and if the appointment is for him
  ///2. if the appointment is not for the user the method will check for the appointments
  ///  with the same phone number and name **this prevent the user from creating a dublicate appointment with the same name and phone number**

  Future<bool> checkAppointmentExist(Appointment appointment) async {
    try {
      late final querySnapshot;
      if (appointment.forMe == true) {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_FOR_ME, isEqualTo: true)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_NAME, isEqualTo: appointment.name)
            .limit(1)
            .get();
      }

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      _logError("searchAppointment", e);
      return false;
    }
  }

  /// delete an existing appointment
  ///1. if the appointment is for the user the method will check for the appointments with the same phone number and if the appointment is for him
  ///2. if the appointment is not for the user the method will check for the appointments with the same phone number and name
  Future<void> deleteAppointment(Appointment appointment) async {
    try {
      late final querySnapshot;
      if (appointment.forMe == true) {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_FOR_ME, isEqualTo: true)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_NAME, isEqualTo: appointment.name)
            .limit(1)
            .get();
      }

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

  /// check In an appointment that is checked by the registrar
  Future<void> checkInAppointment(Appointment appointment) async {
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

      await departmentDoc.reference.collection(CHECKED_IN_APPOINTMENTS).add({
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
        FIELD_MEDICAL_HISTORY: appointment.medicalHistory ?? ["None"],
        FIELD_TIME: appointment.time,
        FIELD_IS_LOCAL: appointment.isLocal ?? false,
        FIELD_FOR_ME: appointment.forMe ?? true,
      });
    } catch (e) {
      _logError("checkInAppointment", e);
    }
  }

  /// Retrieve checked in appointments from a specific department
  Future<List<Appointment>> getCheckedInAppointments(
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

      final appointmentsSnapshot = await departmentDoc.reference
          .collection(CHECKED_IN_APPOINTMENTS)
          .get();
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
                medicalHistory: (() {
                  try {
                    return List<String>.from(doc.get(FIELD_MEDICAL_HISTORY));
                  } catch (_) {
                    return ["None"];
                  }
                })(),
                doctor: doc.get(FIELD_DOCTOR),
                time: (doc.get(FIELD_TIME) as Timestamp).toDate(),
                isLocal: (() {
                  try {
                    return doc.get(FIELD_IS_LOCAL);
                  } catch (_) {
                    return false;
                  }
                })(),
                forMe: (() {
                  try {
                    return doc.get(FIELD_FOR_ME);
                  } catch (_) {
                    return true;
                  }
                })(),
              ))
          .toList();
    } catch (e) {
      _logError("getCheckedInAppointments", e);
      return [];
    }
  }

  /// delete an existing appointment in checkedInAppointments
  /// it works the same way deleteAppointment works, check the documentation for
  /// deleteAppointment
  Future<void> deleteCheckedInAppointment(Appointment appointment) async {
    try {
      late final querySnapshot;
      if (appointment.forMe == true) {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(CHECKED_IN_APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_FOR_ME, isEqualTo: true)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(CHECKED_IN_APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_NAME, isEqualTo: appointment.name)
            .limit(1)
            .get();
      }

      if (querySnapshot.docs.isEmpty) {
        throw Exception(
            "Appointment not found for phone: ${appointment.phoneNumber}");
      }

      final doc = querySnapshot.docs.first;

      await doc.reference.delete();
    } catch (e) {
      _logError("deleteCheckedInAppointment", e);
    }
  }

  /// check out an appointment that is checked by the doctor
  Future<void> checkOutAppointment(Appointment appointment) async {
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

      await departmentDoc.reference.collection(CHECKED_OUT_APPOINTMENTS).add({
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
        FIELD_MEDICAL_HISTORY: appointment.medicalHistory ?? ["None"],
        FIELD_TIME: appointment.time,
        FIELD_IS_LOCAL: appointment.isLocal ?? false,
        FIELD_FOR_ME: appointment.forMe ?? true,
      });
    } catch (e) {
      _logError("checkOutAppointment", e);
    }
  }

  /// Retrieve checked out appointments from a specific department
  Future<List<Appointment>> getCheckedOutAppointments(
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

      final appointmentsSnapshot = await departmentDoc.reference
          .collection(CHECKED_OUT_APPOINTMENTS)
          .get();
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
                medicalHistory: (() {
                  try {
                    return List<String>.from(doc.get(FIELD_MEDICAL_HISTORY));
                  } catch (_) {
                    return ["None"];
                  }
                })(),
                doctor: doc.get(FIELD_DOCTOR),
                time: (doc.get(FIELD_TIME) as Timestamp).toDate(),
                isLocal: (() {
                  try {
                    return doc.get(FIELD_IS_LOCAL);
                  } catch (_) {
                    return false;
                  }
                })(),
                forMe: (() {
                  try {
                    return doc.get(FIELD_FOR_ME);
                  } catch (_) {
                    return true;
                  }
                })(),
              ))
          .toList();
    } catch (e) {
      _logError("getCheckOutAppointments", e);
      return [];
    }
  }

  /// delete an existing appointment in checkedOutAppointments
  /// it works the same way deleteAppointment works, check the documentation for
  /// deleteAppointment
  Future<void> deleteCheckedOutAppointment(Appointment appointment) async {
    try {
      late final querySnapshot;
      if (appointment.forMe == true) {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(CHECKED_OUT_APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_FOR_ME, isEqualTo: true)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(CHECKED_OUT_APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_NAME, isEqualTo: appointment.name)
            .limit(1)
            .get();
      }

      if (querySnapshot.docs.isEmpty) {
        throw Exception(
            "Appointment not found for phone: ${appointment.phoneNumber}");
      }

      final doc = querySnapshot.docs.first;

      await doc.reference.delete();
    } catch (e) {
      _logError("deleteCheckedOutAppointment", e);
    }
  }

  /// save an appointment in diagnosedAppointments after is checked by the doctor
  Future<void> diagnoseAppointment(Appointment appointment) async {
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

      await departmentDoc.reference.collection(DIAGNOSED_APPOINTMENTS).add({
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
        FIELD_MEDICAL_HISTORY: appointment.medicalHistory ?? ["None"],
        FIELD_TIME: appointment.time,
        FIELD_IS_LOCAL: appointment.isLocal ?? false,
        FIELD_FOR_ME: appointment.forMe ?? true,
      });
    } catch (e) {
      _logError("diagnoseAppointment", e);
    }
  }

  /// Retrieve diagnosed appointments from a specific department
  Future<List<Appointment>> getDiagnosedAppointments(
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

      final appointmentsSnapshot = await departmentDoc.reference
          .collection(DIAGNOSED_APPOINTMENTS)
          .get();
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
                medicalHistory: (() {
                  try {
                    return List<String>.from(doc.get(FIELD_MEDICAL_HISTORY));
                  } catch (_) {
                    return ["None"];
                  }
                })(),
                doctor: doc.get(FIELD_DOCTOR),
                time: (doc.get(FIELD_TIME) as Timestamp).toDate(),
                isLocal: (() {
                  try {
                    return doc.get(FIELD_IS_LOCAL);
                  } catch (_) {
                    return false;
                  }
                })(),
                forMe: (() {
                  try {
                    return doc.get(FIELD_FOR_ME);
                  } catch (_) {
                    return true;
                  }
                })(),
              ))
          .toList();
    } catch (e) {
      _logError("getDiagnosedAppointments", e);
      return [];
    }
  }

  ///Search if a diagnoised appointment does exist
  ///1. if the appointment is for the user the method will check for the appointments with
  ///  the same phone number and if the appointment is for him
  ///2. if the appointment is not for the user the method will check for the appointments
  ///  with the same phone number and name **this prevent the user from creating a dublicate appointment with the same name and phone number**

  Future<bool> checkDiagnosedAppointmentExist(Appointment appointment) async {
    try {
      late final querySnapshot;
      if (appointment.forMe == true) {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(DIAGNOSED_APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_FOR_ME, isEqualTo: true)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(DIAGNOSED_APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_NAME, isEqualTo: appointment.name)
            .limit(1)
            .get();
      }

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      _logError("searchDiagnosedAppointment", e);
      return false;
    }
  }

  Future<void> deleteDiagnosedAppointment(Appointment appointment) async {
    try {
      late final querySnapshot;
      if (appointment.forMe == true) {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(DIAGNOSED_APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_FOR_ME, isEqualTo: true)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection(HOSPITALS)
            .doc(appointment.state)
            .collection(LOCALITIES)
            .doc(appointment.locality)
            .collection(DATA)
            .doc(appointment.hospital)
            .collection(DEPARTMENTS)
            .doc(appointment.department)
            .collection(DIAGNOSED_APPOINTMENTS)
            .where(FIELD_PHONE, isEqualTo: appointment.phoneNumber)
            .where(FIELD_NAME, isEqualTo: appointment.name)
            .limit(1)
            .get();
      }

      if (querySnapshot.docs.isEmpty) {
        throw Exception(
            "diagnosed appointment not found for phone: ${appointment.phoneNumber}");
      }

      final doc = querySnapshot.docs.first;

      await doc.reference.delete();
    } catch (e) {
      _logError("deleteDiagnosedAppointment", e);
    }
  }

  Future<List<Appointment>> getTodayDiagnosedAppointments(
    String state,
    String locality,
    String hospitalName,
    String departmentName,
  ) async {
    try {
      // today time in sudan
      final today = DateTime.now().toUtc().add(const Duration(hours: 2));
      List<Appointment> allDiagnosedAppointments =
          await getDiagnosedAppointments(
              state, locality, hospitalName, departmentName);

      return allDiagnosedAppointments
          .where((appointment) =>
              appointment.time.add(const Duration(hours: 2)).day == today.day &&
              appointment.time.add(const Duration(hours: 2)).month ==
                  today.month &&
              appointment.time.add(const Duration(hours: 2)).year == today.year)
          .toList();
    } catch (e) {
      _logError("getTodayDiagnosedAppointments", e);
      return [];
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
