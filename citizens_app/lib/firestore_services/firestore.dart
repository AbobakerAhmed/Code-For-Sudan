import 'package:cloud_firestore/cloud_firestore.dart';

const String HOSPITALS = "hospitals";
const String LOCALITIES = "localities";
const String DEPARTMENTS = "departments";
const String DOCTORS = "doctors";
const String PHONE = "phone";
const String DATA = "data";

class FirestoreService {
  // get collections
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
/*
  // CREATE
  Future<void> addNotify(String type, String title, String mes) {
    return notifications.doc(type).set({
      "type": type,
      "title": title,
      "time": Timestamp.now(),
      "mes": mes,
    });
  }
*/

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
        hospitals.add(Hospital(
            name: hospitalName, phone: phone, departments: departments));
      }
      return hospitals;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

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

  // Future<Map<String, Map<String, List<HospitalEmergency>>>>
  //     getHospitalsEmergencyData() async {
  //   Map<String, Map<String, List<HospitalEmergency>>> emergData = {};

  //   try {
  //     // Step 1: Get all states and their localities
  //     // Map<String, List<String>> statesAndLocalities =
  //     //     await getStatesAndLocalities();
  //     Map<String, List<String>> statesAndLocalities =
  //         await getStatesAndLocalities();
  //     for (String state in statesAndLocalities.keys) {
  //       List<String> localities = statesAndLocalities[state]!;

  //       for (String locality in localities) {
  //         // Step 2: Get hospitals for this state/locality
  //         List<Hospital> hospitals =
  //             await getHospitalsWithDepartmentsAndDoctors(state, locality);

  //         for (Hospital hospital in hospitals) {
  //           // Step 3: Initialize nested maps/lists if needed
  //           emergData[state] ??= {};
  //           emergData[state]![locality] ??= [];

  //           // Step 4: Add HospitalEmergency entry
  //           emergData[state]![locality]!.add(
  //             HospitalEmergency(
  //               name: hospital.name,
  //               phone: hospital.phone,
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print("Error in getHospitalsEmergencyData: $e");
  //   }

  //   return emergData;
  // }
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

class Hospital {
  String name;
  String phone;
  List<Department> departments;

  Hospital(
      {required this.name, required this.phone, required this.departments});
}

class Department {
  String name;
  List<String> doctors;

  Department({required this.name, required this.doctors});
}

class HospitalEmergency {
  final String name;
  final String phone;

  const HospitalEmergency({required this.name, required this.phone});
}
