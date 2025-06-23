// ignore_for_file: unused_local_variable

import 'package:citizens_app/backend/hospital.dart';

void main() {
  Hospital h1 = Hospital('khartoum', 'bahri', 'Bahri hospital', {
    'pediatric': ['dr.ahmad yassin', 'dr.abobaker ahmed'],
    'dentists': ['dr mufti maamon', 'saja essam']
  });

  dynamic data = [
    'الجزيرة',
    'ود مدني',
    'Wad Madani General Hospital',
    {
      'emergency': ['dr. salah mohamed', 'dr. nour aldin ibrahim'],
      'orthopedic': ['dr. osama ali', 'dr. khalid mustafa']
    },
    'khartoum',
    'bahri',
    'Bahri hospital',
    {
      'pediatric': ['dr.ahmad yassin', 'dr.abobaker ahmed'],
      'dentists': ['dr mufti maamon', 'saja essam']
    }
  ];
  //print(h1.hospitalData.toString());
}
