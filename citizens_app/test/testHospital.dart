// ignore_for_file: unused_local_variable

import 'package:citizens_app/backend/hospital.dart';

void main() {
  Hospital h1 = Hospital('khartoum', 'bahri', 'Bahri hospital', '0966831291', {
    'pediatric': ['dr.ahmad yassin', 'dr.abobaker ahmed'],
    'dentists': ['dr mufti maamon', 'saja essam']
  });

  List<Hospital> hospitalsData = getHospitalsData([
    'الجزيرة',
    'ود مدني',
    'Wad Madani General Hospital',
    '0123456789',
    {
      'emergency': ['dr. salah mohamed', 'dr. nour aldin ibrahim'],
      'orthopedic': ['dr. osama ali', 'dr. khalid mustafa']
    },
    'khartoum',
    'bahri',
    'Bahri hospital',
    '0111111111',
    {
      'pediatric': ['dr.ahmad yassin', 'dr.abobaker ahmed'],
      'dentists': ['dr mufti maamon', 'saja essam']
    }
  ]);
  print(hospitalsData);
}
