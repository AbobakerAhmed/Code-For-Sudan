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

  /// Returns a string representation of the [hospitalData] map.
  ///
  /// This can be used for debugging or displaying the full hospital structure.
  void hospitalInfo() {
    print(hospitalData.toString());
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
Hospital toObject(dynamic) {
  String state = dynamic[0];
  String locality = dynamic[1];
  String name = dynamic[2];
  String number = dynamic[3];
  Map<String, List<String>> departmentToDoctors = dynamic[4];
  Hospital obj = Hospital(state, locality, name, number, departmentToDoctors);
  return obj;
}

/// Returns a String of Hospital objects
/// it's use to convert the received data into Hospital objects
/// for example:
///[
///  'الخرطوم',
///  'بحري',
///  'مستشفى بحري',
///  '0123456789',
///  {
///    'الباطنية': ['د. أحمد عمر', 'د. سامية عوض'],
///    'الأطفال': ['د. منى بابكر', 'dr.ahmad yassin', 'dr.abobaker ahmed'],
///    'dentists': ['dr mufti maamon', 'saja essam']
///  },
///  'الخرطوم',
///  'بحري',
///  'مستشفى الختمية',
///  '0123456789',
///  {
///    'الأنف والأذن': ['د. عمار صالح'],
///  },
///  'الخرطوم',
///  'أم درمان',
///  'مستشفى أم درمان',
///  '0123456789',
///  {
///    'الجراحة': ['د. حسن محمد'],
///    'النساء والتوليد': ['د. إيمان الزين'],
///  },
///  'الجزيرة',
///  'مدني',
///  'مستشفى ود مدني',
///  '0123456789',
///  {
///    'الباطنية': ['د. أحمد عمر', 'د. سامية عوض'],
///    'الجلدية': ['د. هالة حسن'],
///    'emergency': ['dr. salah mohamed', 'dr. nour aldin ibrahim'],
///    'orthopedic': ['dr. osama ali', 'dr. khalid mustafa']
///  },
///  'الجزيرة',
///  'مدني',
///  'مستشفى الأطفال',
///  '0123456789',
///  {
///    'الأطفال': ['د. منى بابكر'],
///  }
///]
List<Hospital> getHospitalsData(dynamic hospitalsData) {
  List data = [];
  List<Hospital> hospitals = [];
  int counter = 1;
  for (var element in hospitalsData) {
    if (counter % 5 == 0 && counter != 0) {
      data.add(element);
      hospitals.add(toObject(data));
      data = [];
    } else {
      data.add(element);
    }
    counter++;
  }
  return hospitals;
}

///This class is used in emergency_page
class HospitalEmergency {
  final String name;
  final String phone;
  
  const HospitalEmergency({required this.name, required this.phone});
}
