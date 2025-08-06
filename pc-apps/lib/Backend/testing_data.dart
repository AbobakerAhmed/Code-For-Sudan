import 'package:pc_apps/Backend/appointment.dart';
import 'hospital_employee.dart';
import 'diagnosed_appointment.dart';
import 'package:pc_apps/Backend/notification.dart';
import 'package:pc_apps/Backend/appointment.dart';
import 'package:pc_apps/Backend/diagnosed_appointment.dart';

// --- List of 10 Appointment Objects ---
List<Appointment> testingNewAppointments = [
  Appointment(
    'أحمد محمد علي', // Patient Name
    35, // Age
    'ذكر', // Gender
    '0912345678', // Phone Number
    'الخرطوم - حي الرياض', // Address
    'الخرطوم', // State
    'الرياض', // Locality
    'مستشفى الخرطوم التعليمي', // Hospital
    'باطنية', // Department
    'د. سارة محمود', // Doctor
    true, // Is Self Appointment
  ),
  Appointment(
    'فاطمة حسن إبراهيم',
    28,
    'أنثى',
    '0923456789',
    'أم درمان - ود نوباوي',
    'الخرطوم',
    'أم درمان',
    'مستشفى أم درمان',
    'نساء وتوليد',
    'د. مريم أحمد',
    false,
  ),
  Appointment(
    'علي عثمان الطيب',
    50,
    'ذكر',
    '0934567890',
    'بحري - شمبات',
    'الخرطوم',
    'بحري',
    'مستشفى البراحة',
    'جراحة عامة',
    'د. خالد علي',
    true,
  ),
  Appointment(
    'نورا صلاح الدين',
    12,
    'أنثى',
    '0945678901',
    'الخرطوم - جبرة',
    'الخرطوم',
    'جبرة',
    'مستشفى رويال كير',
    'أطفال',
    'د. ليلى عمر',
    false,
  ),
  Appointment(
    'محمد آدم يوسف',
    65,
    'ذكر',
    '0956789012',
    'أم درمان - الثورة الحارة 19',
    'الخرطوم',
    'أم درمان',
    'مستشفى علياء التخصصي',
    'قلب وأوعية دموية',
    'د. عثمان إبراهيم',
    true,
  ),
  Appointment(
    'زينب عبد الله',
    40,
    'أنثى',
    '0967890123',
    'بحري - الحلفايا',
    'الخرطوم',
    'بحري',
    'مستشفى ابن سينا',
    'جلدية',
    'د. نور الدين',
    true,
  ),
  Appointment(
    'خالد محمود',
    22,
    'ذكر',
    '0978901234',
    'الخرطوم - المنشية',
    'الخرطوم',
    'المنشية',
    'مستشفى فضيل',
    'عيون',
    'د. أميرة فضل',
    false,
  ),
  Appointment(
    'سلمى بشير',
    30,
    'أنثى',
    '0989012345',
    'أم درمان - بيت المال',
    'الخرطوم',
    'أم درمان',
    'مستشفى الأطباء',
    'أنف وأذن وحنجرة',
    'د. ياسر كمال',
    true,
  ),
  Appointment(
    'عمر مختار',
    55,
    'ذكر',
    '0990123456',
    'الخرطوم - العمارات',
    'الخرطوم',
    'العمارات',
    'مستشفى رويال كير',
    'عظام',
    'د. عبد الرحمن',
    true,
  ),
  Appointment(
    'مها عبد العزيز',
    7,
    'أنثى',
    '0901234567',
    'بحري - الدناقلة',
    'الخرطوم',
    'بحري',
    'مستشفى الأطفال',
    'أسنان أطفال',
    'د. إيمان علي',
    false,
  ),
];

// --- List of 10 DiagnosedAppointment Objects ---
List<DiagnosedAppointment> testingDiagnosedAppointment = [
  DiagnosedAppointment(
    'أحمد علي',
    45,
    'ذكر',
    '0911223344',
    'الخرطوم - الصحافة',
    'الخرطوم',
    'الصحافة',
    'مستشفى الخرطوم التعليمي',
    'باطنية',
    'د. عمر فاروق',
    true,
    ['ضغط الدم', 'سكر الدم'], // Diseases
    ''
  ),
  DiagnosedAppointment(
    'ليلى خالد',
    30,
    'أنثى',
    '0911334455',
    'أم درمان - العرضة',
    'الخرطوم',
    'أم درمان',
    'مستشفى أم درمان',
    'نساء وتوليد',
    'د. نادية حسين',
    false,
    ['التهاب المسالك البولية'],
      ''
  ),
  DiagnosedAppointment(
    'يوسف إبراهيم',
    70,
    'ذكر',
    '0911445566',
    'بحري - كوبر',
    'الخرطوم',
    'بحري',
    'مستشفى البراحة',
    'جراحة عامة',
    'د. مروان الطيب',
    true,
    ['فتق إربي'],
      ''
  ),
  DiagnosedAppointment(
    'سارة محمد',
    5,
    'أنثى',
    '0911556677',
    'الخرطوم - الرياض',
    'الخرطوم',
    'الرياض',
    'مستشفى رويال كير',
    'أطفال',
    'د. منى عبد الرحمن',
    false,
    ['التهاب اللوزتين'],
      ''
  ),
  DiagnosedAppointment(
    'عثمان آدم',
    60,
    'ذكر',
    '0911667788',
    'أم درمان - أبوسعد',
    'الخرطوم',
    'أم درمان',
    'مستشفى علياء التخصصي',
    'قلب وأوعية دموية',
    'د. عبد الله أحمد',
    true,
    ['جلطة قلبية سابقة'],
      ''
  ),
  DiagnosedAppointment(
    'مريم علي',
    25,
    'أنثى',
    '0911778899',
    'بحري - الصافية',
    'الخرطوم',
    'بحري',
    'مستشفى ابن سينا',
    'جلدية',
    'د. سامي حسن',
    true,
    ['إكزيما'],
      ''
  ),
  DiagnosedAppointment(
    'أحمد حسن',
    38,
    'ذكر',
    '0911889900',
    'الخرطوم - أركويت',
    'الخرطوم',
    'أركويت',
    'مستشفى فضيل',
    'عيون',
    'د. هدى كمال',
    false,
    ['التهاب الملتحمة'],
    ""
  ),
  DiagnosedAppointment(
    'فاطمة عبد القادر',
    52,
    'أنثى',
    '0911990011',
    'أم درمان - ود البنا',
    'الخرطوم',
    'أم درمان',
    'مستشفى الأطباء',
    'أنف وأذن وحنجرة',
    'د. أيمن صلاح',
    true,
    ['التهاب الجيوب الأنفية'],
      ''

  ),
  DiagnosedAppointment(
    'علي محمد',
    68,
    'ذكر',
    '0911001122',
    'الخرطوم - الطائف',
    'الخرطوم',
    'الطائف',
    'مستشفى رويال كير',
    'عظام',
    'د. نزار حسين',
    true,
    ['خشونة الركبة'],
      ''

  ),
  DiagnosedAppointment(
    'زينب عمر',
    10,
    'أنثى',
    '0911223300',
    'بحري - شمبات',
    'الخرطوم',
    'بحري',
    'مستشفى الأطفال',
    'أطفال',
    'د. إيمان محمد',
    false,
    ['ملاريا'],
      ''
  ),
];


List<DiagnosedAppointment> diagnosedAppointmentWithEpidemics = [
  DiagnosedAppointment(
      'أحمد علي',
      45,
      'ذكر',
      '0911223344',
      'الخرطوم - الصحافة',
      'الخرطوم',
      'الصحافة',
      'مستشفى الخرطوم التعليمي',
      'باطنية',
      'د. عمر فاروق',
      true,
      ['ضغط الدم', 'سكر الدم'], // Diseases
      'وباء 1'
  ),
  DiagnosedAppointment(
      'ليلى خالد',
      30,
      'أنثى',
      '0911334455',
      'أم درمان - العرضة',
      'الخرطوم',
      'أم درمان',
      'مستشفى أم درمان',
      'نساء وتوليد',
      'د. نادية حسين',
      false,
      ['التهاب المسالك البولية'],
      '1'
  ),
  DiagnosedAppointment(
      'يوسف إبراهيم',
      70,
      'ذكر',
      '0911445566',
      'بحري - كوبر',
      'الخرطوم',
      'بحري',
      'مستشفى البراحة',
      'جراحة عامة',
      'د. مروان الطيب',
      true,
      ['فتق إربي'],
      'وباء 3'
  ),
  DiagnosedAppointment(
      'سارة محمد',
      5,
      'أنثى',
      '0911556677',
      'الخرطوم - الرياض',
      'الخرطوم',
      'الرياض',
      'مستشفى رويال كير',
      'أطفال',
      'د. منى عبد الرحمن',
      false,
      ['التهاب اللوزتين'],
      ''
  ),
  DiagnosedAppointment(
      'عثمان آدم',
      60,
      'ذكر',
      '0911667788',
      'أم درمان - أبوسعد',
      'الخرطوم',
      'أم درمان',
      'مستشفى علياء التخصصي',
      'قلب وأوعية دموية',
      'د. عبد الله أحمد',
      true,
      ['جلطة قلبية سابقة'],
      ''
  ),
  DiagnosedAppointment(
      'مريم علي',
      25,
      'أنثى',
      '0911778899',
      'بحري - الصافية',
      'الخرطوم',
      'بحري',
      'مستشفى ابن سينا',
      'جلدية',
      'د. سامي حسن',
      true,
      ['إكزيما'],
      ''
  ),
  DiagnosedAppointment(
      'أحمد حسن',
      38,
      'ذكر',
      '0911889900',
      'الخرطوم - أركويت',
      'الخرطوم',
      'أركويت',
      'مستشفى فضيل',
      'عيون',
      'د. هدى كمال',
      false,
      ['التهاب الملتحمة'],
      ""
  ),
  DiagnosedAppointment(
      'فاطمة عبد القادر',
      52,
      'أنثى',
      '0911990011',
      'أم درمان - ود البنا',
      'الخرطوم',
      'أم درمان',
      'مستشفى الأطباء',
      'أنف وأذن وحنجرة',
      'د. أيمن صلاح',
      true,
      ['التهاب الجيوب الأنفية'],
      ''

  ),
  DiagnosedAppointment(
      'علي محمد',
      68,
      'ذكر',
      '0911001122',
      'الخرطوم - الطائف',
      'الخرطوم',
      'الطائف',
      'مستشفى رويال كير',
      'عظام',
      'د. نزار حسين',
      true,
      ['خشونة الركبة'],
      ''

  ),
  DiagnosedAppointment(
      'زينب عمر',
      10,
      'أنثى',
      '0911223300',
      'بحري - شمبات',
      'الخرطوم',
      'بحري',
      'مستشفى الأطفال',
      'أطفال',
      'د. إيمان محمد',
      false,
      ['ملاريا'],
      ''
  ),
];

List<Appointment> testingCanseldAppointments = [];




List<Notification> incomingNotifications = [
  Notification(
    receiverState: 'الخرطوم', // Khartoum
    receiverLocality: 'أم درمان', // Omdurman
    sender: 'مستشفى الأمل', // Hope Hospital
    title: 'تنبيهات صحية عاجلة', // Urgent Health Alerts
    massage:
    'تقارير عن انتشار وباء و حالة طوارئ صحية', // Reports on epidemic spread and health emergency
    isImportant: true,
    creationTime: DateTime(2025, 6, 10, 2, 45),
    isRed: false, // Initial state
  ),
  Notification(
    receiverState: 'الخرطوم', // Khartoum
    receiverLocality: 'بحري', // Bahri
    sender: 'مستشفى النور', // Al-Noor Hospital
    title: 'توجيهات إدارية', // Administrative Directives
    massage:
    'تحديثات على النظام الإلكتروني أو طريقة رفع البيانات', // Updates on the electronic system or data submission method
    isImportant: false,
    creationTime: DateTime(2025, 6, 10, 2, 45),
    isRed: false,
  ),
  Notification(
    receiverState: 'الخرطوم', // Khartoum
    receiverLocality: 'الخرطوم', // Khartoum
    sender: 'مستشفى السلام', // Al-Salam Hospital
    title: 'تحديثات تقنية', // Technical Updates
    massage:
    'طلب مراجعة بيانات معينة بسبب خلل تقني', // Request to review specific data due to technical glitch
    isImportant: false,
    creationTime: DateTime(2025, 6, 3, 2, 45),
    isRed: false,
  ),
  Notification(
    receiverState: 'الخرطوم', // Khartoum
    receiverLocality: 'أم درمان', // Omdurman
    sender: 'مستشفى الحياة', // Al-Hayat Hospital
    title: 'شكر وتقدير', // Thanks and Appreciation
    massage:
    'شكر على جهود الفريق بعد حالة طارئة', // Thanks for team efforts after an emergency
    isImportant: false,
    creationTime: DateTime(2025, 6, 10, 2, 45),
    isRed: false,
  ),
];

List<Notification> outcomingNotifications = [
  Notification(
    receiverState: 'الخرطوم', // Khartoum
    receiverLocality: 'أم درمان', // Omdurman
    sender: 'اشعار تجريبي', // Hope Hospital
    title: 'تنبيه 1', // Urgent Health Alerts
    massage:
    'تقارير عن انتشار وباء و حالة طوارئ صحية', // Reports on epidemic spread and health emergency
    isImportant: true,
    creationTime: DateTime(2025, 6, 10, 2, 45),
    isRed: false, // Initial state
  ),
  Notification(
    receiverState: 'الخرطوم', // Khartoum
    receiverLocality: 'بحري', // Bahri
    sender: 'مستشفى النور', // Al-Noor Hospital
    title: 'توجيهات إدارية', // Administrative Directives
    massage:
    'تحديثات على النظام الإلكتروني أو طريقة رفع البيانات', // Updates on the electronic system or data submission method
    isImportant: false,
    creationTime: DateTime(2025, 6, 10, 2, 45),
    isRed: false,
  ),
  Notification(
    receiverState: 'الخرطوم', // Khartoum
    receiverLocality: 'الخرطوم', // Khartoum
    sender: 'مستشفى السلام', // Al-Salam Hospital
    title: 'تحديثات تقنية', // Technical Updates
    massage:
    'طلب مراجعة بيانات معينة بسبب خلل تقني', // Request to review specific data due to technical glitch
    isImportant: false,
    creationTime: DateTime(2025, 6, 3, 2, 45),
    isRed: false,
  ),
  Notification(
    receiverState: 'الخرطوم', // Khartoum
    receiverLocality: 'أم درمان', // Omdurman
    sender: 'مستشفى الحياة', // Al-Hayat Hospital
    title: 'شكر وتقدير', // Thanks and Appreciation
    massage:
    'شكر على جهود الفريق بعد حالة طارئة', // Thanks for team efforts after an emergency
    isImportant: false,
    creationTime: DateTime(2025, 6, 10, 2, 45),
    isRed: false,
  ),
];

final testingEmployeers = [
  HospitalEmployee(
    'محمد أحمد',                // name
    '+249911234567',            // phoneNumber
    'pass1234',                 // password
    'الخرطوم',                 // _state
    'بحري',                    // _locality
    'مستشفى بحري التعليمي',   // _hospitalName
  ),
  HospitalEmployee(
    'سارة عبد الرحمن',
    '+249922345678',
    'sara@2025',
    'الخرطوم',
    'الخرطوم شرق',
    'مستشفى الأمل',
  ),
  HospitalEmployee(
    'محمود يوسف',
    '+249933456789',
    'mahmoud!12',
    'الجزيرة',
    'ود مدني',
    'مستشفى ود مدني العام',
  ),
  HospitalEmployee(
    'آمنة الطيب',
    '+249944567890',
    'amna@4321',
    'كسلا',
    'كسلا',
    'مستشفى كسلا المرجعي',
  ),
  HospitalEmployee(
    'حسن علي',
    '+249955678901',
    'hassan#123',
    'شمال دارفور',
    'الفاشر',
    'مستشفى الفاشر',
  ),
  HospitalEmployee(
    'علياء عبد الله',
    '+249966789012',
    'alya',
    'النيل الأبيض',
    'كوستي',
    'مستشفى كوستي',
  ),
  HospitalEmployee(
    'خالد إبراهيم',
    '+249977890123',
    'khalid@321',
    'سنار',
    'سنجة',
    'مستشفى سنار',
  ),
  HospitalEmployee(
    'نهى الزين',
    '+249988901234',
    'noha_5678',
    'القضارف',
    'القضارف',
    'مستشفى القضارف',
  ),
  HospitalEmployee(
    'عبد الباسط محمد',
    '+249999012345',
    'abdelb@2025',
    'جنوب كردفان',
    'كادوقلي',
    'مستشفى كادوقلي',
  ),
  HospitalEmployee(
    'ريم حسن',
    '+249901123456',
    'reem#1995',
    'النيل الأزرق',
    'الدمازين',
    'مستشفى الدمازين',
  ),
];

