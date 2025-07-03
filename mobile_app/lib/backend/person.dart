class Person {
  String _name;
  String _phoneNumber;
  String _password;

  Person(this._name, this._phoneNumber, this._password);

  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get password => _password;

  set name(String name) => {_name = name};

  set phoneNumber(String phoneNumber) => {_phoneNumber = phoneNumber};
  set password(String password) => {_password = password};
}
