class Registrar {
  late final String name;
  late final String hospital;
  late final List<String> departments;
  late final String phoneNumber;
  String? password;

  Registrar(String name, String hospital, List<String> departments,
      String phoneNumber, String password) {
    this.name = name;
    this.hospital = hospital;
    this.departments = departments;
    this.phoneNumber = phoneNumber;
    this.password = password;
  }
}
