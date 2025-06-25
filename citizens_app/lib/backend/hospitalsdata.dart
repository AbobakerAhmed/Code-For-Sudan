import 'hospital.dart';
import 'globalVar.dart';

//This class contains a sample of all hospital data and some data manipulation function

class HospitalsData {
  static Hospital toObject(dynamic) {
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
  static List<Hospital> getHospitalsData(dynamic hospitalsData) {
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

  //this is the sample data that have been used in booking_page and emergency_page
  //getHospitalsData method is defined in hospital.dart
  static final List<Hospital> hospitalsData = getHospitalsData([
    'الخرطوم',
    'بحري',
    'مستشفى بحري',
    '0123456789',
    {
      'الباطنية': ['د. أحمد عمر', 'د. سامية عوض'],
      'الأطفال': ['د. منى بابكر', 'dr.ahmad yassin', 'dr.abobaker ahmed'],
      'dentists': ['dr mufti maamon', 'saja essam']
    },
    'الخرطوم',
    'بحري',
    'مستشفى الختمية',
    '0123456789',
    {
      'الأنف والأذن': ['د. عمار صالح'],
    },
    'الخرطوم',
    'أم درمان',
    'مستشفى أم درمان',
    '0123456789',
    {
      'الجراحة': ['د. حسن محمد'],
      'النساء والتوليد': ['د. إيمان الزين'],
    },
    'الجزيرة',
    'مدني',
    'مستشفى ود مدني',
    '0123456789',
    {
      'الباطنية': ['د. أحمد عمر', 'د. سامية عوض'],
      'الجلدية': ['د. هالة حسن'],
      'emergency': ['dr. salah mohamed', 'dr. nour aldin ibrahim'],
      'orthopedic': ['dr. osama ali', 'dr. khalid mustafa']
    },
    'الجزيرة',
    'مدني',
    'مستشفى الأطفال',
    '0123456789',
    {
      'الأطفال': ['د. منى بابكر'],
    }
  ]);

  ///This method changes the data so the data can be used in the format used in emergency_page
  ///{
//   'الخرطوم': {
//     'بحري': [
//       HospitalEmergency(name: 'مستشفى بحري', phone: '0912345678'),
//       HospitalEmergency(name: 'مستشفى الختمية', phone: '0923456789'),
//     ],
//     'أم درمان': [
//       HospitalEmergency(name: 'مستشفى أم درمان', phone: '0934567890'),
//     ],
//   },
//   'الجزيرة': {
//     'مدني': [
//       HospitalEmergency(name: 'مستشفى ود مدني', phone: '0945678901'),
//       HospitalEmergency(name: 'مستشفى الأطفال', phone: '0956789012'),
//     ],
//   },
// }
  static Map<String, Map<String, List<HospitalEmergency>>>
      getHospitalsEmergencyData() {
    Map<String, Map<String, List<HospitalEmergency>>> emergData = {};
    for (String state in g_states) {
      List<String> localities = g_localities[state]!;
      for (String locality in localities) {
        for (Hospital hospital in hospitalsData) {
          if (hospital.hospitalState == state &&
              hospital.hospitalLocality == locality) {
            // Initialize state map if not exists
            emergData[state] ??= {};
            // Initialize locality list if not exists
            emergData[state]![locality] ??= [];
            // Add hospital emergency entry
            emergData[state]![locality]!.add(
              HospitalEmergency(
                  name: hospital.hospitalName!,
                  phone: hospital.hospitalEmergencyNumber!),
            );
          }
        }
      }
    }
    return emergData;
  }

  static final Map<String, Map<String, List<HospitalEmergency>>>
      hospitalsEmergencyData = HospitalsData.getHospitalsEmergencyData();

  ///get hospitals object depending on the state and locality
  static List<Hospital> hospitals(
      String? selectedState, String? selectedLocality) {
    List<Hospital> list = [];
    if (selectedState != null && selectedLocality != null) {
      for (Hospital hospital in hospitalsData) {
        if (hospital.hospitalState == selectedState &&
            hospital.hospitalLocality == selectedLocality) {
          list.add(hospital);
        }
      }
      return list;
    } else {
      return [];
    }
  }

  ///get a list of the names of the previously selected hospitals
  static List<String> availablehospitals(
      String? selectedState, String? selectedLocality) {
    List<String> list = [];
    for (Hospital hospital in hospitals(selectedState, selectedLocality)) {
      list.add(hospital.hospitalName!);
    }
    return list;
  }

  /// get departments depending on the hospital
  static List<String> availableDepartments(String? selectedState,
      String? selectedLocality, String? selectedHospital) {
    for (Hospital hospital in hospitals(selectedState, selectedLocality)) {
      if (hospital.hospitalName == selectedHospital) {
        return hospital.hospitalDepartmentToDoctors!.keys.toList();
      }
    }
    return [];
  }

  ///  get doctors depending on the department
  static List<String> availableDoctors(
      String? selectedState,
      String? selectedLocality,
      String? selectedHospital,
      String? selectedDepartment) {
    for (Hospital hospital in hospitals(selectedState, selectedLocality)) {
      if (hospital.hospitalName == selectedHospital) {
        // Check if the map is not null before accessing it
        return hospital.hospitalDepartmentToDoctors?[selectedDepartment] ?? [];
      }
    }
    return [];
  }
}
