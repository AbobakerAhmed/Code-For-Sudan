/* 
//__________________________Hospital Class__________________________\\
A class that models a hospital including:
  - state
  - locality
  - location
  - departments and doctors
  - emergency number
Also contains these functions:
  - getters for each attributer
+  - setDepartmentToDoctors
+  - addDeprtment, removeDepartment used by the ministry employee
+  - addDoctor, removeDoctor that used be the hospital manager
  - toJson, fromJson those used to database connection
*/

class Department {
  String name;
  List<String> doctors;
  Department({required this.name, required this.doctors});
}

class Hospital {
  final String _hospitalName; // The name of the hospital.
  final String _locationDetails; // such as the road name, neighbourhood or any thing like that
  final String _emergencyNumber; //The emergency number of the hospital.

  // A map of departments and their corresponding doctors.
  List<Department> _departments; // department(String name, List<String> doctor)

  // constructor
  Hospital(
      this._hospitalName,
      this._locationDetails,
      this._emergencyNumber,
      this._departments
      ); // constructor

  // Getters
  String getHospitalName() => this._hospitalName;
  String getHospitalLocationDetails() => this._locationDetails;
  String getHospitalEmergencyNumber() => this._emergencyNumber;
  List<Department> get departments => _departments;

  List<String> departmentsToString() {
    List<String> dep = [];
    for (var department in departments) {
      dep.add(department.name);
    }
    return dep;
  }

  List<String> getDepartmentsNames(){
    List<String> departs = ["الكل"];
    for(int i = 0; i < _departments.length ; i++){
      departs.add(_departments[i].name);
    }
    return departs;
  }
  static List<Department> departmentsFromString(String string){
    return [];
  }


  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'hospitalName': _hospitalName,
      'locationDetails': _locationDetails,
      'hospitalEmergencyNumber': _emergencyNumber,
      'hospitalDepartmentAndDoctors': _departments.toString(),
    };
  }

  // Create from JSON
  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        json['hospitalName'] as String,
        json['emergencyNumber'] as String,
        json['locationDetails'] as String,
        departmentsFromString(json['departmentsAndDoctors']),
      );
} // Hospital