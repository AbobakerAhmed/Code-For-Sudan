import 'hospital.dart';
import 'globalVar.dart';

//This file contains a sample data and some data manipulation function

//this is the sample data that have been used in booking_page and emergency_page
//getHospitalsData method is defined in hospital.dart
final List<Hospital> hospitalsData = getHospitalsData([
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
Map<String, Map<String, List<HospitalEmergency>>> emergencyData() {
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
