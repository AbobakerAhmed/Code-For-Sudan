// ignore_for_file: constant_identifier_names

///This is the global variables file
///there is some varibles that are going to be added
final List<String> _states = [
  'الخرطوم',
  'الجزيرة',
  'النيل الأبيض',
  'كسلا',
  'البحر الأحمر',
  'القضارف',
  'سنار',
  'النيل الأزرق',
  'شمال كردفان',
  'جنوب كردفان',
  'غرب كردفان',
  'شمال دارفور',
  'جنوب دارفور',
  'شرق دارفور',
  'غرب دارفور',
  'وسط دارفور',
  // Add more states as needed
];

const List<String> g_states = ['الكل', 'الخرطوم', 'الجزيرة'];
const Map<String, List<String>> g_localities = {
  'الكل' : ["الكل"],
  'الخرطوم': ['بحري', 'أم درمان'],
  'الجزيرة': ['مدني']
};
const List<String> g_gender = ['ذكر', 'انثى'];

const List<String> epidemics = [
  'الاسهال المائي الحاد',
  'الشلل الرخو الحاد',
  'الحصبة/الحصباء',
  'التسمم الغذائي الوبائي',
  'الكوليرا',
  'الحميات النزفية',
  'الالتهاب الكبدي الفيروسي الوبائي',
  'الملاريا',
  'التيفويد',
  'الكوليرا (الإسهال الدموي)',
  'شلل الأطفال',
  'الجمرة الخبيثة (الجلدية)',
  'الجمرة الخبيثة (الجهاز التنفسي)',
  'التسمم الغذائي (البكتيري)',
  'التسمم الغذائي (الكيماوي)',
  'التسمم الغذائي (غير محدد)',
  'السعال الديكي',
  'البروسيلا',
  'الحمى الصفراء',
  'التهاب السحايا',
  'الربو',
  'الجرب',
  'مجهرية',
  'الجمرة الخبيثة (الإستنشاق)'
];

// any epidemic with its threshold where that is the No cases before setting a locality with that epidemic
const Map<String, int> epidemicThresholds = {
  'الاسهال المائي الحاد': 1,     // Acute Watery Diarrhea
  'الشلل الرخو الحاد': 1,         // Acute Flaccid Paralysis
  'الحصبة/الحصباء': 1,            // Measles
  'التسمم الغذائي الوبائي': 5,    // Epidemic Food Poisoning
  'الكوليرا': 1,                  // Cholera
  'الحميات النزفية': 1,           // Hemorrhagic Fevers
  'الالتهاب الكبدي الفيروسي الوبائي': 5, // Epidemic Viral Hepatitis
  'الملاريا': 10,                 // Malaria
  'التيفويد': 5,                  // Typhoid
  'الكوليرا (الإسهال الدموي)': 1, // Cholera (Bloody Diarrhea)
  'شلل الأطفال': 1,               // Polio
  'الجمرة الخبيثة (الجلدية)': 1,  // Cutaneous Anthrax
  'الجمرة الخبيثة (الجهاز التنفسي)': 1, // Respiratory Anthrax
  'التسمم الغذائي (البكتيري)': 5, // Bacterial Food Poisoning
  'التسمم الغذائي (الكيماوي)': 3, // Chemical Food Poisoning
  'التسمم الغذائي (غير محدد)': 5, // Unspecified Food Poisoning
  'السعال الديكي': 5,             // Whooping Cough
  'البروسيلا': 5,                 // Brucellosis
  'الحمى الصفراء': 1,             // Yellow Fever
  'التهاب السحايا': 5,            // Meningitis
  'الربو': 10,                    // Asthma (cluster investigation)
  'الجرب': 10,                    // Scabies
  'مجهرية': 5,                    // Microscopic (generic lab-confirmed)
  'الجمرة الخبيثة (الإستنشاق)': 1, // Inhalation Anthrax
};

Map<String, int> epidemicsAsMap() {
  Map<String, int> _epidemics = {epidemics[0]: 0};
  for (int i = 1; i < epidemics.length; i++) {
    _epidemics.addAll({epidemics[i]: 0});
  } // for
  return _epidemics;
} // epidemicsAsMap

