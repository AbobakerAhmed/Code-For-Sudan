// Date: 22st of Jun 2025

// importing
import 'dart:core';
// import 'package:citizens_app/backend/appointment.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/backend/registrar/appoinment.dart';
import 'package:mobile_app/styles.dart'; // appBar style
import 'package:mobile_app/backend/validate_fields.dart';
import 'package:mobile_app/backend/global_var.dart';
import 'package:mobile_app/backend/citizen/hospital.dart';
import 'package:mobile_app/firestore_services/firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// testing this page alone
void main(List<String> args) {
  runApp(const _BookingPageTest());
} // main

class _BookingPageTest extends StatelessWidget {
  const _BookingPageTest();

  @override
  Widget build(BuildContext) {
    return const MaterialApp(home: BookingPage());
  }
} // BookingPageTest

/// booking page builder
class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
} // BookingPage

/// Booking page
class _BookingPageState extends State<BookingPage> {
  // Define database object
  final FirestoreService _firestoreService = FirestoreService();
  List<String> _dbStates = [];
  List<String> _dbLocalities = [];
  List<String> _dbHospitals = [];
  List<String> _dbDepartments = [];
  List<String> _dbDoctors = [];
  bool _isConnected = false;
  bool _showMedicalHistory = false;
  int _forMe = 1;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Testing Data (Region)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Fields:
  String? fullName;
  String? age;
  String? gender;
  String? phoneNumber;
  String? selectedState;
  String? selectedLocality;
  String? address;
  String? selectedHospital;
  String? selectedDepartment;
  String? selectedDoctor;

/*
  Now we should ensure that:
    - All states in sudan will be displayed.
    - The displayed localities will be depending on the state
    - The displayed depatments will be depending on the hospital
    - The displayed doctors will be depending on the depatment

*/
  Future<void> _getStates() async {
    try {
      final statesAndLocalities =
          await _firestoreService.getStatesAndLocalities();
      final states = statesAndLocalities.keys.toList();
      setState(() {
        _dbStates = states;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _getLocalities(String state) async {
    try {
      final statesAndLocalities =
          await _firestoreService.getStatesAndLocalities();
      final localities = statesAndLocalities[state];
      setState(() {
        _dbLocalities = localities!;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _getHospitals(String state, String locality) async {
    try {
      final hospitals = await _firestoreService
          .getHospitalsWithDepartmentsAndDoctors(state, locality);
      final names = hospitals.map((hospital) => hospital.name).toList();
      setState(() {
        _dbHospitals = names;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _getDepartments(
      String state, String locality, String hospitalName) async {
    try {
      List<Hospital> hospitals = await _firestoreService
          .getHospitalsWithDepartmentsAndDoctors(state, locality);
      Hospital hospital =
          hospitals.firstWhere((hospital) => hospital.name == hospitalName);
      final names =
          hospital.departments.map((department) => department.name).toList();
      setState(() {
        _dbDepartments = names;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _getDoctors(String state, String locality, String hospitalName,
      String departmentName) async {
    try {
      List<Hospital> hospitals = await _firestoreService
          .getHospitalsWithDepartmentsAndDoctors(state, locality);
      Hospital hospital =
          hospitals.firstWhere((hospital) => hospital.name == hospitalName);
      final names = hospital.departments
          .firstWhere((department) => department.name == departmentName)
          .doctors;
      setState(() {
        _dbDoctors = names;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.mobile ||
        connectivityResult[0] == ConnectivityResult.wifi) {
      return true; // Connected to either mobile data or WiFi
    }
    return false; // Not connected
  }

  Future<void> _checkConnectivity() async {
    _isConnected = await isConnectedToInternet();
  }
/*
  /// get localities depending on the state
  List<String> get localities =>
      selectedState != null ? g_localities[selectedState!]! : [];
*/
/*
  ///get hospitals depending on the locality
  List<Hospital> hospitals() {
    List<Hospital> list = [];
    if (selectedState != null && selectedLocality != null) {
      for (Hospital hospital in hospitalsData) {
        if (hospital.hospitalState == selectedState &&
            hospital.hospitalLocality == selectedLocality) {
          list.add(hospital);
        }
      }
      return list;
    } else {
      return [];
    }
  }
*/
/*
  ///get a list of the names of the previously selected hospitals
  List<String> hospitalsName() {
    List<String> list = [];
    for (Hospital hospital in hospitals()) {
      list.add(hospital.hospitalName!);
    }
    return list;
  }

  // gtt departments depending on the hospital
  List<String> availableDepartments() {
    for (Hospital hospital in hospitals()) {
      if (hospital.hospitalName == selectedHospital) {
        return hospital.hospitalDepartmentToDoctors!.keys.toList();
      }
    }
    return [];
  }
*/
/*
  - There is a bugge here which is the available doctors must be depending on
    the specific department in a specific hospital
  - The current code displayed the abailable doctors in that department in
    in any hospital in Sudan

    *** the problem was from the Testing data (doctor), because the keys (departments) aren't depending on the local hospitals, and hence the values (doctors) aren't depending on the hospitals***
*/
/*
//  get doctors depending on the department
  List<String> availableDoctors() {
    for (Hospital hospital in hospitals()) {
      if (hospital.hospitalName == selectedHospital) {
        // Check if the map is not null before accessing it
        return hospital.hospitalDepartmentToDoctors?[selectedDepartment] ?? [];
      }
    }
    return [];
  }
*/

  /// initiate state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnectivity();
    _getStates();
  }

  /// overriding the build method
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: Scaffold(
        appBar: AppBar(title: Text("حجز موعد")),
        body: !_isConnected
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                    SizedBox(
                      height: 30,
                    ),
                    Text("كيف حالك")
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // radio buttons to choose the appointment for me/or for other one
                      Row(
                        children: [
                          _expanadedRadio(
                              title: "حجز لي",
                              value: 1,
                              groupValue: _forMe,
                              onChanged: (value) {
                                setState(() {
                                  _forMe = value!;
                                });
                              }),
                          _expanadedRadio(
                              title: "حجز لغيري",
                              value: 0,
                              groupValue: _forMe,
                              onChanged: (value) {
                                setState(() {
                                  _forMe = value!;
                                });
                              }),
                        ],
                      ),

                      // space between buttons and fields
                      const SizedBox(height: 30),

                      // entering name
                      _buildTextField(
                          // validate the name with range of characters
                          'الاسم الرباعي',
                          textDirection: TextDirection.rtl,
                          _nameController,
                          (val) => fullName = val, validator: (val) {
                        if (val == null || val.isEmpty) return 'الاسم مطلوب';
                        if (val.length < 4) return 'الاسم قصير جداً';
                        return null;
                      }),

                      // entering gender
                      _buildDropdown(
                        label: 'النوع',
                        value: gender,
                        items: g_gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        },
                      ),

                      // entering age
                      _buildTextField(
                        'العمر',
                        _ageController,
                        (val) => age = val,
                        inputType: TextInputType.number,
                        // validate the age range (0,150)
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'العمر مطلوب';
                          final num = int.tryParse(val);
                          if (num == null || num <= 0 || num > 150) {
                            return 'عمر غير صالح';
                          }
                          return null;
                        },
                      ),

                      // enter phone number
                      _buildTextField(
                        'رقم الهاتف (مثال: 0123456789)',
                        _phoneController,
                        // validate the number (10 digits, start only with 01, 099, 092, 090, 091, or 096)
                        (val) => phoneNumber = val,
                        inputType: TextInputType.phone,
                        validator: (value) {
                          if (!Validate.phoneNumber(value ?? '')) {
                            return 'رقم الهاتف غير صالح'; // Invalid phone number
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                          height:
                              20), // dividing between personal info and hospital info

                      // state
                      _buildDropdown(
                        label: 'الولاية',
                        value: selectedState,
                        items: _dbStates,
                        onChanged: (val) {
                          setState(() {
                            selectedState = val;
                            selectedLocality = null;
                            selectedHospital = null;
                            selectedDepartment = null;
                            selectedDoctor = null;
                            _dbLocalities = [];
                            _dbHospitals = [];
                            _dbDepartments = [];
                            _dbDoctors = [];
                            _getLocalities(selectedState!);
                          });
                        },
                      ),

                      // selection a locality depending on the state
                      _buildDropdown(
                        label: 'المحلية',
                        value: selectedLocality,
                        items: _dbLocalities,
                        onChanged: (val) {
                          setState(() {
                            selectedLocality = val;
                            selectedHospital = null;
                            selectedDepartment = null;
                            selectedDoctor = null;
                            _dbHospitals = [];
                            _dbDepartments = [];
                            _dbDoctors = [];
                            _getHospitals(selectedState!, selectedLocality!);
                          });
                        },
                      ),

                      // home details: neighborhod - block
                      _buildTextField(
                        'الحي - المربع (مثال: الواحة - 4)',
                        textDirection: TextDirection.rtl,
                        _addressController,
                        (val) => address = val,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'العنوان مطلوب';
                          return null;
                        },
                      ),

                      // selecting a hospital depending on the locality
                      _buildDropdown(
                        label: 'المستشفى',
                        value: selectedHospital,
                        items: _dbHospitals,
                        onChanged: (val) {
                          setState(() {
                            selectedHospital = val;
                            selectedDepartment = null;
                            selectedDoctor = null;
                            _dbDepartments = [];
                            _dbDoctors = [];
                            _getDepartments(selectedState!, selectedLocality!,
                                selectedHospital!);
                          });
                        },
                      ),

                      // selecting a department depending on the hospital
                      _buildDropdown(
                        label: 'القسم',
                        value: selectedDepartment,
                        items: _dbDepartments,
                        onChanged: (val) {
                          setState(() {
                            selectedDepartment = val;
                            selectedDoctor = null;
                            _dbDoctors = [];
                            _getDoctors(selectedState!, selectedLocality!,
                                selectedHospital!, selectedDepartment!);
                          });
                        },
                      ),

                      // selecting a doctor depending on the department
                      _buildDropdown(
                        label: 'الطبيب',
                        // look the bugg above (in the doctors testing data)
                        value: selectedDoctor,
                        items: _dbDoctors,
                        onChanged: (val) {
                          setState(() {
                            selectedDoctor = val;
                          });
                        },
                      ),
                      //const SizedBox(height: 10),

                      // show my medical history
                      CheckboxListTile(
                          value: _showMedicalHistory,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text("مشاركة السجل المرضي مع الطبيب"),
                          activeColor: Theme.of(context).primaryColorDark,
                          enabled: _forMe == 1 ? true : false,
                          onChanged: (value) {
                            setState(() {
                              _showMedicalHistory = value!;
                            });
                          }),

                      const SizedBox(height: 20),

                      // sending the appoinment
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('تأكيد الحجز'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green,
                            minimumSize: const Size(10, 10)),
                        onPressed: () {
                          /*
  Validation of a field can be in its text field or here
  */

                          if (_isFormValid() &&
                              _formKey.currentState!.validate()) {
                            // save info in database
                            _firestoreService.createAppointment(Appointment(
                                name: fullName!,
                                gender: gender!,
                                age: age!,
                                address: address!,
                                phoneNumber: phoneNumber!,
                                state: selectedState!,
                                locality: selectedLocality!,
                                hospital: selectedHospital!,
                                department: selectedDepartment!,
                                doctor: selectedDoctor!,
                                time: DateTime.now().subtract(const Duration(
                                    hours: 2)) // to convert from UTC+2 to UTC
                                ));

                            // clear fields
                            setState(() {
                              _nameController.clear();
                              _ageController.clear();
                              gender = null;
                              _phoneController.clear();
                              _addressController.clear();
                              selectedState = null;
                              selectedLocality = null;
                              selectedHospital = null;
                              selectedDepartment = null;
                              selectedDoctor = null;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('تم إرسال الحجز بنجاح 🎉')));
                          } // if
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'يرجى تعبئة جميع الحقول بشكل صحيح')));
                          } // else
                        },
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  Widget _expanadedRadio(
      {required String title,
      required int value,
      required int groupValue,
      required ValueChanged<int?> onChanged}) {
    return Expanded(
      child: RadioListTile(
          title: Text(title),
          activeColor: Theme.of(context).primaryColorDark,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged),
    );
  } // build fun

  /// checking is the form is completely full or not
  bool _isFormValid() {
    return fullName != null &&
        age != null &&
        address != null &&
        phoneNumber != null &&
        gender != null &&
        selectedState != null &&
        selectedLocality != null &&
        selectedHospital != null &&
        selectedDepartment != null &&
        selectedDoctor != null;
  } // _isFormValid

  /// build text field has been updated to handle the validation
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Function(String) onChanged, {
    TextDirection textDirection = TextDirection.ltr,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: inputType,
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        style: Theme.of(context).textTheme.labelMedium,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            floatingLabelStyle:
                TextStyle(color: Theme.of(context).primaryColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  ///
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: Theme.of(context).cardColor,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        items: items
            .map((e) => DropdownMenuItem(
                alignment: AlignmentDirectional.centerEnd,
                value: e,
                child: Text(
                  e,
                  style: Theme.of(context).textTheme.labelMedium,
                )))
            .toList(),
        onChanged: onChanged,
      ),
    );
  } // _buildDropdown
}
