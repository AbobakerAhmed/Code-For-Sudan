/* Person Class
A class that holds any joint attribute between
citizen, hospital employee, ministry employee
which are the following:
  - name
  - phone number
  - password
 
Also contains these functions:
  - getters for each except birth date
  - setters for the password only because it is non-final attribute
  - no toJson, fromJson here because this class will not be conncted with the database directly
*/
class Person {
  final String _name;
  final String _phoneNumber;
  String _password; // (Encoded)

  // constructor
  Person(this._name, this._phoneNumber, this._password); // constructor

  // Getters
  String getName() => this._name;
  String getPhoneNumber() => this._phoneNumber;
  String getPassword() => this._password;

  String getFirstName() => _name.substring(0, _name.indexOf(" ") );

  // Setters
  void setPassword(String password) => this._password = password;

  // no toJson,fromJson here because this object will not be stored in the database directly
} //Person


/*
@startuml
class Person {
  -final String _name
  -final String _phoneNumber
  -String _password
  +Person(name: String, phoneNumber: String, password: String)
  +getName(): String
  +getPhoneNumber(): String
  +getPassword(): String
  +setPassword(password: String): void
}
@enduml
 */