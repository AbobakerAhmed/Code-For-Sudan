/// A class that models a hospital, including its location, departments,
/// doctors, and a structured representation of this information.
class Hospital {
  /// The state in which the hospital is located.
  String? hospitalState;

  /// The locality (city or town) of the hospital.
  String? hospitalLocality;

  /// The name of the hospital.
  String? hospitalName;

  /// A list of departments in the hospital.
  // List<String>? hospitalDepartments;

  /// A map of departments and their corresponding doctors.
  Map<String, List<String>>? hospitalDepartmentToDoctors;

  /// A nested map that organizes hospital information hierarchically:
  /// {
  ///   'state': {
  ///     'locality': {
  ///       'hospitalName': {
  ///         'department1': [doctor1, doctor2],
  ///         'department2': [doctor3, doctor4]
  ///       }
  ///     }
  ///   }
  /// }
  ///
  /// Example:
  /// {
  ///   khartoum: {
  ///     bahri: {
  ///       Bahri hospital: {
  ///         pediatric: [dr.ahmad yassin, dr.abobaker ahmed],
  ///         dentists: [dr mufti maamon, saja essam]
  ///       }
  ///     }
  ///   }
  /// }

  Map<String, Map<String, Map<String, Map<String, List<String>>>>>?
      hospitalData;

  /// Constructs a [Hospital] object and builds the [hospitalData] map
  /// using the provided state, locality, name, departments, and doctor mappings.
  ///
  /// - [state]: The state of the hospital.
  /// - [locality]: The locality or city of the hospital.
  /// - [name]: The hospital name.
  /// - [departmentToDoctors]: A map of department names to doctor lists.
  Hospital(
    String state,
    String locality,
    String name,
    Map<String, List<String>> departmentToDoctors,
  ) {
    hospitalState = state;
    hospitalLocality = locality;
    hospitalName = name;
    hospitalDepartmentToDoctors = departmentToDoctors;

    hospitalData = {
      state: {
        locality: {
          name: departmentToDoctors,
        },
      },
    };
  }

  /// Returns a string representation of the [hospitalData] map.
  ///
  /// This can be used for debugging or displaying the full hospital structure.
  void hospitalInfo() {
    print(hospitalData.toString());
  }

  /// Converts the [Hospital] instance to a JSON-serializable map.
  // Map<String, dynamic> toJson() {
  //   return {
  //     'hospitalState': hospitalState,
  //     'hospitalLocality': hospitalLocality,
  //     'hospitalName': hospitalName,
  //     'hospitalDepartmentToDoctors': hospitalDepartmentToDoctors,
  //   };
  // }

  // // Creates a [Hospital] instance from a JSON map.
  // factory Hospital.fromJson(Map<String, dynamic> json) {
  //   return Hospital(json['hospitalState'], json['hospitalLocality'],
  //       json['hospitalName'], json['hospitalDepartmentToDoctors']);
  // }
}

Hospital toObject(dynamic) {
  String state = dynamic[0];
  String locality = dynamic[1];
  String name = dynamic[2];
  Map<String, List<String>> departmentToDoctors = dynamic[3];
  Hospital obj = Hospital(state, locality, name, departmentToDoctors);
  return obj;
}
