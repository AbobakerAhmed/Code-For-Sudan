class Hospital {
  String _name;
  String _phone;
  List<Department> _departments;

  Hospital(this._name, this._phone, this._departments);

  String get name => _name;
  String get phone => _phone;
  List<Department> get departments => _departments;

  List<String> departmentsToString() {
    List<String> dep = [];
    for (var department in departments) {
      dep.add(department.name);
    }
    return dep;
  }
}

class Department {
  String name;
  List<String> doctors;

  Department({required this.name, required this.doctors});
}

class HospitalEmergency {
  final String name;
  final String phone;

  const HospitalEmergency({required this.name, required this.phone});
}
