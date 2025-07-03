import 'package:mobile_app/citizen/backend/citizen.dart';

class CitizensData {
  static List<Citizen> data = [
    Citizen(
      'abdoyassin',
      '0118718014',
      '123456789@Yassin',
      'ذكر',
      'Khartoum North, Bahri',
      DateTime(2003, 10, 7),
      ['Severe Obesity', 'Weak sight'],
    ),
    Citizen(
      'saraahmed',
      '0912234567',
      'S@rA_98#',
      'أنثى',
      'Omdurman, Alshuhada',
      DateTime(1998, 4, 15),
      ['Asthma', 'Iron deficiency'],
    ),
    Citizen(
      'mohamedomar',
      '0923344556',
      'Om@r#19x!',
      'ذكر',
      'Khartoum, Almanshia',
      DateTime(1995, 12, 1),
      ['Diabetes Type 1'],
    ),
    Citizen(
      'fatimaalhaj',
      '0909988776',
      'F@ti#June00',
      'أنثى',
      'Khartoum North, Almazad',
      DateTime(2000, 6, 30),
      ['Anemia', 'Mild Allergies'],
    ),
    Citizen(
      'khalidmustafa',
      '0961122334',
      'K#Must@89!',
      'ذكر',
      'Port Sudan, Alsouq Almarkazi',
      DateTime(1989, 8, 20),
      ['Chronic back pain'],
    ),
    Citizen(
      'imanmohsen',
      '0997766554',
      '1m@n!2025#',
      'أنثى',
      'Khartoum, Alamarat',
      DateTime(2001, 11, 10),
      ['None'],
    ),
  ];

  /// Check if a citizen exists with the given name and password
  static bool isCitizenValid(String username, String password) {
    return data.any((citizen) =>
        citizen.citizenName == username && citizen.password == password);
  }
}
