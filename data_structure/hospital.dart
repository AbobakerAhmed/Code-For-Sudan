/* 
//__________________________Hospital Class__________________________\\
A class that models a hospital including:
  - state
  - locality
  - location
  - departments and dictors
  - emergency number
Also contains these functions:
  - getters for each attributer
+  - setDepartmentToDoctors
+  - addDeprtment, removeDepartment used by the ministry employee
+  - addDoctor, removeDoctor that used be the hospital manager
  - toJson, fromJson those used to database connection
*/
class Hospital {
  final String _hospitalName; // The name of the hospital.
  final String _hospitalState; // The state in which the hospital is located.
  final String _hospitalLocality; // The locality (city or town) of the hospital.
  final String _locationDetails; // such as the road name, neighbourhood or any thing like that
  final String _hospitalEmergencyNumber; //The emergency number of the hospital.
  // A map of departments and their corresponding doctors.
  Map<String, List<String>>? _hospitalDepartmentAndDoctors; // this map is nullable

  // constructor
  Hospital(this._hospitalName, this._hospitalState, this._hospitalLocality, this._locationDetails,
      this._hospitalEmergencyNumber, this._hospitalDepartmentAndDoctors); // constructor

  // Getters
  String getHospitalName() => this._hospitalName;
  String getHospitalState() => this._hospitalState;
  String getHospitalLocality() => this._hospitalLocality;
  String getHospitalLocationDetails() => this._locationDetails;
  String getHospitalEmergencyNumber() => this._hospitalEmergencyNumber;
  Map<String, List<String>> getDepartmentsWithDoctors() => this._hospitalDepartmentAndDoctors!;

  void setDepartmentAndDoctors(Map<String, List<String>> departmentsAndDoctors) =>
      this._hospitalDepartmentAndDoctors = departmentsAndDoctors;

//  void addDeprtment(Map<String, List<String>> departmentAndItsDoctors) {} // addDepartment
//     this._hospitalDepartmentAndDoctors!.addAll(departmentAndItsDoctors);

  void removeDepartment(String department) =>
      this._hospitalDepartmentAndDoctors!.removeWhere((key, value) => key == department);

//  void addDoctor(String department, String doctor) => this._hospitalDepartmentAndDoctors!.update();
//  void removeDoctor(){}

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'hospitalName': _hospitalName,
      'hospitalState': _hospitalState,
      'hospitalLocality': _hospitalLocality,
      'locationDetails': _locationDetails,
      'hospitalEmergencyNumber': _hospitalEmergencyNumber,
      'hospitalDepartmentAndDoctors': _hospitalDepartmentAndDoctors,
    };
  }

  // Create from JSON
  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        json['hospitalName'] as String,
        json['hospitalState'] as String,
        json['hospitalLocality'] as String,
        json['hospitalEmergencyNumber'] as String,
        json['locationDetails'] as String,
        (json['hospitalDepartmentAndDoctors'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(
            key,
            (value as List<dynamic>).map((e) => e.toString()).toList(),
          ),
        ),
      );
} // Hospital

/* UML
  @startuml
class Hospital {
  - final String _hospitalName
  - final String _hospitalState
  - final String _hospitalLocality
  - final String _hospitalEmergencyNumber
  - Map<String, List<String>>? _hospitalDepartmentAndDoctors
  --
  + Hospital(
    String _hospitalName,
    String _hospitalState,
    String _hospitalLocality,
    String _hospitalEmergencyNumber,
    Map<String, List<String>>? _hospitalDepartmentAndDoctors
  )
  + String getHospitalName()
  + String getHospitalState()
  + String getHospitalLocality()
  + String getHospitalEmergencyNumber()
  + Map<String, List<String>> getDepartmentsWithDoctors()
  + Map<String, dynamic> toJson()
  + {static} Hospital fromJson(Map<String, dynamic> json)
}
@enduml
*/