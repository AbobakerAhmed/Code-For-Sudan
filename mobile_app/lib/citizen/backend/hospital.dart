/// A class that models a hospital, including its location, departments,
/// doctors, and a structured representation of this information.
/// ///the Hospital class hasn't finished yet it need fromjson and tojson
class Hospital {
  /// The state in which the hospital is located.
  String? hospitalState;

  /// The locality (city or town) of the hospital.
  String? hospitalLocality;

  /// The name of the hospital.
  String? hospitalName;

  ///The emergency number of the hospital.
  String? hospitalEmergencyNumber;

  /// A map of departments and their corresponding doctors.
  Map<String, List<String>>? hospitalDepartmentToDoctors;

  /// A nested map that organizes hospital information hierarchically:
  /// {
  ///   'state': {
  ///     'locality': {
  ///       'hospitalName': {
  ///         'hospitalEmergencyNumber' : number,
  ///         'Departments' : {
  ///           'department1': [doctor1, doctor2],
  ///           'department2': [doctor3, doctor4]
  ///          }
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
  ///         'Hospital Emergency Number': 0123456789,
  ///         'Department and doctors':{
  ///           pediatric: [dr.ahmad yassin, dr.abobaker ahmed],
  ///           dentists: [dr mufti maamon, saja essam]
  ///          }
  ///       }
  ///     }
  ///   }
  /// }

  Map<String, Map<String, Map<String, Map<String, dynamic>>>>? hospitalData;

  /// Constructs a [Hospital] object and builds the [hospitalData] map
  /// using the provided state, locality, name, departments, and doctor mappings.
  ///
  /// - [state]: The state of the hospital.
  /// - [locality]: The locality or city of the hospital.
  /// - [name]: The hospital name.
  /// - [number]: The hospital emergency number
  /// - [departmentToDoctors]: A map of department names to doctor lists.
  Hospital(
    String state,
    String locality,
    String name,
    String number,
    Map<String, List<String>> departmentToDoctors,
  ) {
    hospitalState = state;
    hospitalLocality = locality;
    hospitalName = name;
    hospitalEmergencyNumber = number;
    hospitalDepartmentToDoctors = departmentToDoctors;

    hospitalData = {
      state: {
        locality: {
          name: {
            'Hospital Emergency Number': number,
            'Department and doctors': departmentToDoctors
          },
        },
      }
    };
  }
}

///Return a Hospital object from data in the following hierarechy
///  'الخرطوم',
///  'بحري',
///  'مستشفى بحري',
///  '0123456789',
///  {
///    'الباطنية': ['د. أحمد عمر', 'د. سامية عوض'],
///    'الأطفال': ['د. منى بابكر', 'dr.ahmad yassin', 'dr.abobaker ahmed'],
///    'dentists': ['dr mufti maamon', 'saja essam']
///  }

///This class is used in emergency_page
class HospitalEmergency {
  final String name;
  final String phone;

  const HospitalEmergency({required this.name, required this.phone});
}
