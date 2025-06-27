// نموذج Appointment
class Appointment {
  String name;
  String gender; // 'ذكر', 'أنثى'
  int age;
  String neighborhood;
  String? phoneNumber;
  String hospital;
  String department;
  String doctor;
  DateTime? time;
  bool isLocal; // مضافة لتحديد الحجوزات التي أُضيفت محليًا

  Appointment({
    required this.name,
    required this.gender,
    required this.age,
    required this.neighborhood,
    this.phoneNumber,
    required this.hospital,
    required this.department,
    required this.doctor,
    required this.time,
    this.isLocal = false,
  });
}
