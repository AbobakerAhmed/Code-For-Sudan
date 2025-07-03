import 'package:mobile_app/backend/citizen/citizen.dart';

class CitizensData {
  static List<Citizen> data = [
    Citizen(
      'abdoyassin',
      '0118718014',
      '123456789@Yassin',
      'ذكر',
      DateTime(2003, 10, 7),
      ['Severe Obesity', 'Weak sight'],
      'الخرطوم',
      'بحري',
      'Khartoum North, Bahri',
    ),
    Citizen(
      'saraahmed',
      '0912234567',
      'S@rA_98#',
      'أنثى',
      DateTime(1998, 4, 15),
      ['Asthma', 'Iron deficiency'],
      'الخرطوم',
      'أمدرمان',
      'Omdurman, Alshuhada',
    ),
    Citizen(
      'mohamedomar',
      '0923344556',
      'Om@r#19x!',
      'ذكر',
      DateTime(1995, 12, 1),
      ['Diabetes Type 1'],
      'الخرطوم',
      'بحري',
      'Khartoum, Almanshia',
    ),
    Citizen(
      'fatimaalhaj',
      '0909988776',
      'F@ti#June00',
      'أنثى',
      DateTime(2000, 6, 30),
      ['Anemia', 'Mild Allergies'],
      'الخرطوم',
      'بحري',
      'Khartoum North, Almazad',
    ),
    Citizen(
      'khalidmustafa',
      '0961122334',
      'K#Must@89!',
      'ذكر',
      DateTime(1989, 8, 20),
      ['Chronic back pain'],
      'الجزيرة',
      'ود مدني',
      'Port Sudan, Alsouq Almarkazi',
    ),
    Citizen(
      'imanmohsen',
      '0997766554',
      '1m@n!2025#',
      'أنثى',
      DateTime(2001, 11, 10),
      ['None'],
      'الخرطوم',
      'ام درمان',
      'Khartoum, Alamarat',
    ),
  ];

  /// Check if a citizen exists with the given name and password
  static bool isCitizenValid(String phone, String password) {
    return data.any((citizen) =>
        citizen.phoneNumber == phone && citizen.password == password);
  }
}
