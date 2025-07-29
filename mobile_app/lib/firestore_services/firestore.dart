import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/backend/registrar/appoinment.dart';
import 'package:mobile_app/backend/notification.dart';
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
const String NOTIFICATIONS = "notifications";
const String RECIPIENT_ID = "recipientId";

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

  /// Retrieve a Doctor's phone number by their details.
  Future<String?> getDoctorPhoneNumber(
    String doctorName,
    String state,
    String locality,
    String hospitalName,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(DOCTORS)
          .where(NAME, isEqualTo: doctorName)
          .where(STATE, isEqualTo: state)
          .where(LOCALITY, isEqualTo: locality)
          .where('hospitalName', isEqualTo: hospitalName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()[PHONENUMBER] as String?;
      }
      return null;
    } catch (e) {
      _logError("getDoctorPhoneNumber", e);
      return null;
    }
  }

  /// Retrieve a Doctor's phone number by their details.
  Future<String?> getRegistrarPhoneNumber(
    String state,
    String locality,
    String hospitalName,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(REGISTRARS)
          .where(STATE, isEqualTo: state)
          .where(LOCALITY, isEqualTo: locality)
          .where('hospitalName', isEqualTo: hospitalName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()[PHONENUMBER] as String?;
      }
      return null;
    } catch (e) {
      _logError("getRegistrarPhoneNumber", e);
      return null;
    }
  }

  /// Updates the citizen's medical history in Firestore by merging with the old history and deleted values.
  /// 1. In both old and new	Include
  /// 2. In both old and deleted	Skip
  /// 3. In old only (not new or deleted)	Include
  /// 4. In new only (not in old)	 Include
  Future<void> updateCitizenMedicalHistory(
    String phoneNumber,
    List<String> newHistory,
    List<String> deletedHistory,
  ) async {
    final citizenSnapshot = await _firestore
        .collection(CITIZENS)
        .where(PHONENUMBER, isEqualTo: phoneNumber)
        .get();

    if (citizenSnapshot.docs.isEmpty) {
      throw Exception("Citizen not found");
    }

    try {
      final doc = citizenSnapshot.docs.first;

      List<String> oldHistory =
          List<String>.from(doc.data()['medicalHistory'] ?? []);
      oldHistory.removeWhere((item) => item == "None");

      // Convert to sets for efficient lookup
      final Set<String> oldSet = oldHistory.toSet();
      final Set<String> newSet = newHistory.toSet();
      final Set<String> deletedSet = deletedHistory.toSet();

      // Apply your 4 rules
      final List<String> combined = [
        // Rule 1 and 3: From old but not in deleted (rule 2 already excluded)
        ...oldSet.where((item) => !deletedSet.contains(item)),

        // Rule 4: From new but not already included
        ...newSet.where((item) => !oldSet.contains(item)),
      ];

      await doc.reference.update({MEDICAL_HISTORY: combined});
    } catch (e) {
      _logError("updateCitizenMedicalHistory", e);
      rethrow;
    }
  }

  /// updateCitizen
  ///
  /// Updates the contents of an existing citizen document in Firestore.
  ///
  /// This method first retrieves the citizen document based on the provided phone number.
  /// Then, it applies the updates specified in the `updatedData` map to the document.
  /// If the citizen's `name` or `phoneNumber` is changed, it propagates these changes to all
  /// associated appointments across all hospitals in the Firestore database.
  /// It also updates notification recipient IDs if the phone number is changed.
  ///
  /// Parameters:
  ///   - `phoneNumber`: The phone number of the citizen to update. This is used to locate the correct document.
  ///   - `updatedData`: A map containing the fields to update and their new values.
  ///
  /// Functionality:
  ///   1. Retrieves the citizen document using the provided `phoneNumber`.
  ///   2. Updates the specified fields in the citizen document with the new values from `updatedData`.
  ///   3. If the `name` or `phoneNumber` has changed:
  ///     - It iterates through all hospitals, localities, and departments in the database.
  ///     - It queries the appointments, diagnosed appointments, checked-in appointments, and checked-out appointments
  ///       collections for entries matching the old `name` and `phoneNumber`.
  ///     - It updates the `name` and `phoneNumber` for all matching appointments.
  ///   4. If the `phoneNumber` has changed:
  ///     -It updates all notifications whose `recipientId` matches the old phone number,
  ///      setting it to the new phone number.
  ///
  /// Throws:
  ///   - `Exception` if a citizen with the given `phoneNumber` is not found.
  ///
  /// Errors are logged via [_logError] and rethrown.
  Future<void> updateCitizen(
      String phoneNumber, Map<String, dynamic> updatedData) async {
    try {
      // Step 1: Get the original citizen document
      final citizenSnapshot = await _firestore
          .collection(CITIZENS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (citizenSnapshot.docs.isEmpty) {
        throw Exception("Citizen not found");
      }

      final citizenDoc = citizenSnapshot.docs.first;
      final oldData = citizenDoc.data();

      final oldName = oldData[NAME];
      final oldPhoneNumber = oldData[PHONENUMBER];

      // Step 2: Update citizen data
      await citizenDoc.reference.update(updatedData);

      // Step 3: If name changed, propagate across hospitals
      if ((updatedData.containsKey(NAME) && updatedData[NAME] != oldName) ||
          (updatedData.containsKey(PHONENUMBER) &&
              updatedData[PHONENUMBER] != oldPhoneNumber)) {
        final newName = updatedData[NAME];
        final newPhoneNumber = updatedData[PHONENUMBER];

        final hospitalsSnapshot = await _firestore.collection(HOSPITALS).get();

        final updateFutures = <Future>[];

        for (final stateDoc in hospitalsSnapshot.docs) {
          final localitiesSnapshot =
              await stateDoc.reference.collection(LOCALITIES).get();

          for (final localityDoc in localitiesSnapshot.docs) {
            final dataSnapshot =
                await localityDoc.reference.collection(DATA).get();

            for (final hospitalDoc in dataSnapshot.docs) {
              final departmentsSnapshot =
                  await hospitalDoc.reference.collection(DEPARTMENTS).get();

              for (final departmentDoc in departmentsSnapshot.docs) {
                for (final subcol in [
                  APPOINTMENTS,
                  DIAGNOSED_APPOINTMENTS,
                  CHECKED_IN_APPOINTMENTS,
                  CHECKED_OUT_APPOINTMENTS,
                ]) {
                  final query = departmentDoc.reference
                      .collection(subcol)
                      .where(FIELD_PHONE, isEqualTo: oldPhoneNumber)
                      .where(FIELD_NAME, isEqualTo: oldName);

                  updateFutures.add(query.get().then((appointmentsSnapshot) {
                    final batch = _firestore.batch();

                    for (final doc in appointmentsSnapshot.docs) {
                      batch.update(doc.reference,
                          {FIELD_NAME: newName, FIELD_PHONE: newPhoneNumber});
                    }

                    return batch.commit(); // Executes batch
                  }));
                }
              }
            }
          }
        }

        // Run all updates in parallel
        await Future.wait(updateFutures);
      }
      if (updatedData.containsKey(PHONENUMBER) &&
          updatedData[PHONENUMBER] != oldPhoneNumber) {
        final newPhoneNumber = updatedData[PHONENUMBER] as String;
        print(
            "Updating doctor's notifications from $oldPhoneNumber to $newPhoneNumber");

        final notificationsSnapshot = await _firestore
            .collection(NOTIFICATIONS)
            .where(RECIPIENT_ID, isEqualTo: oldPhoneNumber)
            .get();
        final batch = _firestore.batch();
        for (final notificationDoc in notificationsSnapshot.docs) {
          batch.update(
              notificationDoc.reference, {RECIPIENT_ID: newPhoneNumber});
        }
        await batch.commit();
      }
    } catch (e) {
      _logError("updateCitizen", e);
      rethrow;
    }
  }

  /// updateDoctor
  ///
  /// Updates the contents of an existing doctor document in Firestore.
  ///
  /// This method first retrieves the doctor document based on the provided phone number.
  /// Then, it applies the updates specified in the `updatedData` map to the document.
  /// If the doctor's `name` is changed, it propagates these changes to all associated appointments
  /// and the doctor's entry in the department's doctor list.
  /// It also updates notification recipient IDs if the phone number is changed.
  ///
  /// Parameters:
  ///   - `phoneNumber`: The phone number of the doctor to update. This is used to locate the correct document.
  ///   - `department`: The department the doctor belongs to. This is used for propagating name changes.
  ///   - `updatedData`: A map containing the fields to update and their new values.
  ///
  /// Functionality:
  ///   1. Retrieves the doctor document using the provided `phoneNumber`.
  ///   2. Updates the specified fields in the doctor document with the new values from `updatedData`.
  ///   3. If the `name` has changed:
  ///     - It updates the doctor's name in all appointments, diagnosed appointments, checked-in appointments, and
  ///       checked-out appointments collections within the specified department.
  ///     - It updates the doctor's name in the department's doctor list.
  /// 4. If the `phoneNumber` has changed:
  ///    - It updates all notifications whose `recipientId` matches the old phone number,
  ///      setting it to the new phone number.
  ///
  /// Throws:
  ///   - `Exception` if a doctor with the given `phoneNumber` is not found.
  ///
  /// Errors are logged via [_logError] and rethrown.
  Future<void> updateDoctor(String phoneNumber, String department,
      Map<String, dynamic> updatedData) async {
    try {
      final snapshot = await _firestore
          .collection(DOCTORS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Doctor not found");
      }

      final doc = snapshot.docs.first;
      final oldData = doc.data();
      final oldName = oldData[NAME];
      final oldPhoneNumber = oldData[PHONENUMBER];

      await _firestore.collection(DOCTORS).doc(doc.id).update(updatedData);

      // --- Propagate changes to other collections ---

      // Proceed only if the doctor name is changed
      if (updatedData.containsKey(NAME) && updatedData[NAME] != oldName) {
        final newName = updatedData[NAME] as String;

        final state = oldData[STATE];
        final locality = oldData[LOCALITY];
        final hospital = oldData['hospitalName'];

        final baseDeptRef = _firestore
            .collection(HOSPITALS)
            .doc(state)
            .collection(LOCALITIES)
            .doc(locality)
            .collection(DATA)
            .doc(hospital)
            .collection(DEPARTMENTS)
            .doc(department);

        final subcollections = [
          APPOINTMENTS,
          DIAGNOSED_APPOINTMENTS,
          CHECKED_IN_APPOINTMENTS,
          CHECKED_OUT_APPOINTMENTS,
        ];

        for (String subcol in subcollections) {
          final querySnapshot = await baseDeptRef
              .collection(subcol)
              .where(FIELD_DOCTOR, isEqualTo: oldName)
              .get();

          for (final doc in querySnapshot.docs) {
            await doc.reference.update({FIELD_DOCTOR: newName});
          }
        }

        // Update department's doctor list
        final deptSnapshot = await baseDeptRef.get();
        if (deptSnapshot.exists) {
          final deptData = deptSnapshot.data()!;
          final doctorsList = deptData[DOCTORS];

          if (doctorsList is List) {
            final updatedDoctors = doctorsList.map((d) {
              if (d == oldName) return newName;
              if (d is Map && d['name'] == oldName) {
                return {...d, 'name': newName};
              }
              return d;
            }).toList();

            await baseDeptRef.update({DOCTORS: updatedDoctors});
          }
        }
      }

      // Proceed only if the phone number is changed
      if (updatedData.containsKey(PHONENUMBER) &&
          updatedData[PHONENUMBER] != oldPhoneNumber) {
        final newPhoneNumber = updatedData[PHONENUMBER] as String;

        final notificationsSnapshot = await _firestore
            .collection(NOTIFICATIONS)
            .where(RECIPIENT_ID, isEqualTo: oldPhoneNumber)
            .get();

        final batch = _firestore.batch();
        for (final notificationDoc in notificationsSnapshot.docs) {
          batch.update(
              notificationDoc.reference, {RECIPIENT_ID: newPhoneNumber});
        }
        await batch.commit();
      }
    } catch (e) {
      _logError("updateDoctor", e);
      rethrow;
    }
  }

  /// Updates the contents of an existing registrar document in Firestore.
  ///
  /// This method first retrieves the registrar document based on the provided phone number.
  /// Then, it applies the updates specified in the `updatedData` map to the document.
  ///
  /// Parameters:
  ///   - `phoneNumber`: The phone number of the registrar to update. This is used to locate the correct document.
  ///   - `updatedData`: A map containing the fields to update and their new values.
  ///
  /// Throws:
  /// Errors are logged via [_logError] and rethrown.
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
      final oldData = doc.data();
      final oldPhoneNumber = oldData[PHONENUMBER];

      await _firestore.collection(REGISTRARS).doc(doc.id).update(updatedData);

      // Proceed only if the phone number is changed
      if (updatedData.containsKey(PHONENUMBER) &&
          updatedData[PHONENUMBER] != oldPhoneNumber) {
        final newPhoneNumber = updatedData[PHONENUMBER] as String;

        final notificationsSnapshot = await _firestore
            .collection(NOTIFICATIONS)
            .where(RECIPIENT_ID, isEqualTo: oldPhoneNumber)
            .get();

        final batch = _firestore.batch();
        for (final notificationDoc in notificationsSnapshot.docs) {
          batch.update(
              notificationDoc.reference, {RECIPIENT_ID: newPhoneNumber});
        }
        await batch.commit();
      }
    } catch (e) {
      _logError("updateRegistrar", e);
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

  /// Fetch notifications for a specific recipient, ordered by most recent.
  Future<List<Notify>> getNotifications(String recipientId) async {
    try {
      final snapshot = await _firestore
          .collection(NOTIFICATIONS)
          .where(RECIPIENT_ID, isEqualTo: recipientId)
          //.orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) => Notify.fromFirestore(doc)).toList();
    } catch (e) {
      _logError("getNotifications", e);
      return [];
    }
  }

  /// Create a new notification document.
  Future<void> createNotification(Notify notification) async {
    try {
      // The toFirestore method correctly omits the ID, which is what we want
      // as Firestore will auto-generate it.
      await _firestore
          .collection(NOTIFICATIONS)
          .add(notification.toFirestore());
    } catch (e) {
      _logError("createNotification", e);
      // We might not want to rethrow here, as failing to send a notification
      // shouldn't necessarily block the user flow. Just logging is fine.
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
