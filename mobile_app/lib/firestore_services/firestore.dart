import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/backend/citizen/appointment.dart';
import 'package:mobile_app/backend/citizen/hospital.dart';
import 'package:mobile_app/backend/citizen/citizen.dart';

const String HOSPITALS = "hospitals";
const String LOCALITIES = "localities";
const String DEPARTMENTS = "departments";
const String DOCTORS = "doctors";
const String PHONE = "phone";
const String DATA = "data";
const String CITIZENS = "citizens";
const String NAME = "name";
const String PHONENUMBER = "phoneNumber";
const String ADDRESS = "address";
const String GENDER = "gender";
const String STATE = "state";
const String LOCALITY = "locality";
const String PASSWORD = "password";
const String BIRTHDATE = "birthDate";

class FirestoreService {
  // get collections
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> searchCitizen(String phoneNumber, String password) async {
    try {
      QuerySnapshot citizenDoc = await _firestore
          .collection(CITIZENS)
          .where(PHONENUMBER, isEqualTo: phoneNumber)
          .where(PASSWORD, isEqualTo: password)
          .get();

      return citizenDoc.docs.first.exists;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  //get an oject from the citizen phone number and password
  Future<Citizen> getCitizen(String phoneNumber, String password) async {
    QuerySnapshot citizenDoc = await _firestore
        .collection(CITIZENS)
        .where(PHONENUMBER, isEqualTo: phoneNumber)
        .where(PASSWORD, isEqualTo: password)
        .get();

    return Citizen.fromJson(
        citizenDoc.docs.first.data() as Map<String, dynamic>);
  }

  Future<void> createCitizen(Citizen citizen) async {
    try {
      bool found = await searchCitizen(citizen.phoneNumber, citizen.password);
      if (!found) {
        CollectionReference<Map<String, dynamic>> citizenDoc =
            _firestore.collection(CITIZENS);
        citizenDoc.add(citizen.toJson());
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // CREATE
  /* Method to add appointment in specific hospital and department */
  Future<void> createAppointment(Appointment appointment) async {
    try {
      // Get the locality document
      DocumentSnapshot localityDoc = await _firestore
          .collection(HOSPITALS)
          .doc(appointment.selectedState)
          .collection(LOCALITIES)
          .doc(appointment.selectedLocality)
          .get();
      // Check if the locality document exists
      if (!localityDoc.exists) {
        throw Exception("Locality document does not exist");
      }
      // Get the hospital document from the DATA sub-collection
      DocumentSnapshot hospitalDoc = await localityDoc.reference
          .collection(DATA)
          .doc(appointment.selectedHospital)
          .get();
      // Check if the hospital document exists
      if (!hospitalDoc.exists) {
        throw Exception("Hospital document does not exist");
      }
      // Get the department document from the DEPARTMENTS sub-collection
      DocumentSnapshot departmentDoc = await hospitalDoc.reference
          .collection(DEPARTMENTS)
          .doc(appointment.selectedDepartment)
          .get();
      // Check if the department document exists
      if (!departmentDoc.exists) {
        throw Exception("Department document does not exist");
      }
      // Create a new appointment document in the appointments sub-collection
      await departmentDoc.reference.collection("appointments").add({
        "الإسم": appointment.patientName,
        "العمر": appointment.patientAge,
        "الجنس": appointment.patientGender,
        "الهاتف": appointment.patientPhoneNumber,
        "السكن": appointment.patientAddress,
        "الدكتور": appointment.selectedDoctor,
        "الولاية": appointment.selectedState,
        "المحلية": appointment.selectedLocality,
        "المستشفى": appointment.selectedHospital,
        "القسم": appointment.selectedDepartment,
        // Add other fields as necessary
      });
      print("Appointment created successfully");
    } catch (e) {
      print("Error: $e");
    }
  }

  // READ
  Future<Map<String, List<String>>> getStatesAndLocalities() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(HOSPITALS).get();
      Map<String, List<String>> statesAndLocalities = {};
      for (var stateDoc in querySnapshot.docs) {
        QuerySnapshot localitiesSnapshot =
            await stateDoc.reference.collection(LOCALITIES).get();
        List<String> localities = localitiesSnapshot.docs
            .map((localityDoc) => localityDoc.id)
            .toList();
        statesAndLocalities[stateDoc.id] = localities;
      }
      return statesAndLocalities;
    } catch (e) {
      print("Error: $e");
      return {};
    }
  }

  Future<List<Hospital>> getHospitalsWithDepartmentsAndDoctors(
      String state, String locality) async {
    try {
      DocumentSnapshot localityDoc = await _firestore
          .collection(HOSPITALS)
          .doc(state)
          .collection(LOCALITIES)
          .doc(locality)
          .get();
      if (!localityDoc.exists) {
        return [];
      }

      QuerySnapshot hospitalSnapshot =
          await localityDoc.reference.collection(DATA).get();
      List<Hospital> hospitals = [];

      for (var hospitalDoc in hospitalSnapshot.docs) {
        String hospitalName = hospitalDoc.id;
        String phone = hospitalDoc.get(PHONE);

        QuerySnapshot departmentSnapshot =
            await hospitalDoc.reference.collection(DEPARTMENTS).get();
        List<Department> departments = [];

        for (var departmentDoc in departmentSnapshot.docs) {
          String departmentName = departmentDoc.id;
          List<String> doctors = List<String>.from(departmentDoc.get(DOCTORS));
          departments.add(Department(name: departmentName, doctors: doctors));
        }
        hospitals.add(Hospital(hospitalName, phone, departments));
      }
      return hospitals;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<Hospital> getHospital(
      String state, String locality, String hospitalName) async {
    DocumentSnapshot hospitalDoc = await _firestore
        .collection(HOSPITALS)
        .doc(state)
        .collection(LOCALITIES)
        .doc(locality)
        .collection(DATA)
        .doc(hospitalName)
        .get();
    return Hospital(
        hospitalDoc.id, hospitalDoc.get("phone"), hospitalDoc.get(DEPARTMENTS));
  }

/* Method to get appointment in specific hospital and department */
  Future<List<Appointment>> getAppointments(String state, String locality,
      String hospitalName, String departmentName) async {
    try {
      // Get the locality document
      DocumentSnapshot localityDoc = await _firestore
          .collection(HOSPITALS)
          .doc(state)
          .collection(LOCALITIES)
          .doc(locality)
          .get();
      // Check if the locality document exists
      if (!localityDoc.exists) {
        return [];
      }
      // Get the hospital document from the DATA sub-collection
      DocumentSnapshot hospitalDoc =
          await localityDoc.reference.collection(DATA).doc(hospitalName).get();
      // Check if the hospital document exists
      if (!hospitalDoc.exists) {
        return [];
      }
      // Get the department document from the DEPARTMENTS sub-collection
      DocumentSnapshot departmentDoc = await hospitalDoc.reference
          .collection(DEPARTMENTS)
          .doc(departmentName)
          .get();
      // Check if the department document exists
      if (!departmentDoc.exists) {
        return [];
      }
      // Get the appointments from the appointments sub-collection
      QuerySnapshot appointmentSnapshot =
          await departmentDoc.reference.collection("appointments").get();
      List<Appointment> appointments = [];
      for (var appointmentDoc in appointmentSnapshot.docs) {
        // Retrieve the relevant fields for the Appointment object
        String patientName = appointmentDoc.get("الإسم");
        String patientAge = appointmentDoc.get('العمر');
        String patientGender = appointmentDoc.get('الجنس');
        String patientPhoneNumber = appointmentDoc.get('الهاتف');
        String patientAddress = appointmentDoc.get('السكن');
        String selectedDoctor = appointmentDoc.get('الدكتور');
        // Create an Appointment instance
        appointments.add(Appointment(
          patientName,
          patientAge,
          patientGender,
          patientPhoneNumber,
          patientAddress,
          state,
          locality,
          hospitalName,
          departmentName,
          selectedDoctor,
        ));
      }
      return appointments;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

/* Method to get advices */
  Future<List<String>> getMedicalAdvices() async {
    try {
      // Get all documents from the medical_advices collection
      QuerySnapshot adviceSnapshot =
          await _firestore.collection('medical_advices').get();
      // Create a list to hold the advices
      List<String> advices = [];
      // Iterate through the documents and extract the advice field
      for (var adviceDoc in adviceSnapshot.docs) {
        String advice = adviceDoc.get('advice');
        advices.add(advice);
      }
      return advices;
    } catch (e) {
      print("Error fetching medical advices: $e");
      return [];
    }
  }

/* Method to get emergency numbers of hospitals */
  Future<Map<String, Map<String, List<HospitalEmergency>>>>
      getHospitalsEmergencyData() async {
    Map<String, Map<String, List<HospitalEmergency>>> emergData = {};

    try {
      // Get all states (documents under "hospitals")
      QuerySnapshot stateSnapshot =
          await _firestore.collection(HOSPITALS).get();

      for (var stateDoc in stateSnapshot.docs) {
        String stateName = stateDoc.id;
        emergData[stateName] = {};

        // Get all localities (subcollections under each state)
        QuerySnapshot localitySnapshot =
            await stateDoc.reference.collection(LOCALITIES).get();

        for (var localityDoc in localitySnapshot.docs) {
          String localityName = localityDoc.id;
          emergData[stateName]![localityName] = [];

          // Get hospitals under each locality (DATA collection)
          QuerySnapshot hospitalSnapshot = await localityDoc.reference
              .collection(DATA)
              .get(); // No need to fetch departments/doctors

          for (var hospitalDoc in hospitalSnapshot.docs) {
            String name = hospitalDoc.id;
            String phone = hospitalDoc.get(PHONE);

            emergData[stateName]![localityName]!.add(
              HospitalEmergency(name: name, phone: phone),
            );
          }
        }
      }
    } catch (e) {
      print("Error in getHospitalsEmergencyData: $e");
    }

    return emergData;
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
