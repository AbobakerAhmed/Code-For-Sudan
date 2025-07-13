// نموذج Appointment
class Appointment {
  String name;
  String gender; // 'ذكر', 'أنثى'
  String age;
  String address;
  String phoneNumber;
  String state;
  String locality;
  String hospital;
  String department;
  String doctor;
  DateTime time;
  bool isLocal; // مضافة لتحديد الحجوزات التي أُضيفت محليًا

  Appointment({
    required this.name,
    required this.gender,
    required this.age,
    required this.address,
    required this.phoneNumber,
    required this.state,
    required this.locality,
    required this.hospital,
    required this.department,
    required this.doctor,
    required this.time,
    this.isLocal = false,
  });
}
