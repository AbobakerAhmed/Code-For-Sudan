// Date: 21st of Jun 2025

// importing
import 'package:flutter/material.dart';
import 'styles.dart'; // appBar style

// testing this page alone
void main(List<String> args) {
  runApp(_BookingPageTest());
} // main

class _BookingPageTest extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return MaterialApp(home: BookingPage());
  }
} // BookingPageTest

// booking page builder
class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
} // BookingPage

// Booking page
class _BookingPageState extends State<BookingPage> {
  // Testing Data (Region)
  final Map<String, Map<String, List<String>>> hospitalData = {
    'الخرطوم': {
      'بحري': ['مستشفى بحري', 'مستشفى الختمية'],
      'أم درمان': ['مستشفى أم درمان']
    },
    'الجزيرة': {
      'مدني': ['مستشفى ود مدني', 'مستشفى الأطفال']
    }
  }; // hospitalData

  // Testing Data (Departments in each hospital)
  final Map<String, List<String>> departments = {
    'مستشفى بحري': ['الباطنية', 'الأطفال'],
    'مستشفى أم درمان': ['الجراحة', 'النساء والتوليد'],
    'مستشفى ود مدني': ['الباطنية', 'الجلدية'],
    'مستشفى الأطفال': ['الأطفال'],
    'مستشفى الختمية': ['الأنف والأذن']
  }; // depatments

  // Testing Data (Doctors in each department)
  final Map<String, List<String>> doctors = {
    'الباطنية': ['د. أحمد عمر', 'د. سامية عوض'],
    'الأطفال': ['د. منى بابكر'],
    'الجراحة': ['د. حسن محمد'],
    'النساء والتوليد': ['د. إيمان الزين'],
    'الجلدية': ['د. هالة حسن'],
    'الأنف والأذن': ['د. عمار صالح']
  }; // doctors

  // Fields:
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

  // git localities depending on the state
  List<String> get localities =>
      selectedState != null ? hospitalData[selectedState!]!.keys.toList() : [];

  // git hospitals depending on the locality
  List<String> get hospitals =>
      (selectedState != null && selectedLocality != null)
          ? hospitalData[selectedState!]![selectedLocality!] ?? []
          : [];

  // git departments depending on the hospital
  List<String> get availableDepartments =>
      selectedHospital != null ? departments[selectedHospital!] ?? [] : [];

/*
  - There is a bugge here which is the available doctors must be depending on
    the specific department in a specific hospital
  - The current code displayed the abailable doctors in that department in
    in any hospital in Sudan
*/
  // git doctors depending on the department
  List<String> get availableDoctors =>
      selectedDepartment != null ? doctors[selectedDepartment!] ?? [] : [];

  // build fun
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: Scaffold(
        appBar: appBar('حجز موعد'), // styles.dart
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // entering name
              _buildTextField(
// validate the name with range of characters
                'الاسم الرباعي',
                (val) => fullName = val,
              ),

              // entering gender
              _buildDropdown(
                label: 'النوع',
                value: gender,
                items: ['ذكر', 'أنثى'],
                onChanged: (val) {
                  setState(() {
                    gender = val;
                  });
                },
              ),

              // entering age
              _buildTextField(
                'العمر',
// validate the age range (0,150)
                (val) => age = val,
                inputType: TextInputType.number,
              ),

              // enter phone number
              _buildTextField(
                'رقم الهاتف (مثال: 0123456789)',
// validate the number (10 digits, start only with 01, 099, 092, 090, 091, or 096)
                (val) => phoneNumber = val,
                inputType: TextInputType.phone,
              ),

              SizedBox(
                  height:
                      20), // dividing between personal info and hospital info

              // state
              _buildDropdown(
                label: 'الولاية',
                value: selectedState,
                items: hospitalData.keys.toList(),
                onChanged: (val) {
                  setState(() {
                    selectedState = val;
                    selectedLocality = null;
                    selectedHospital = null;
                    selectedDepartment = null;
                    selectedDoctor = null;
                  });
                },
              ),

              // selection a locality depending on the state
              _buildDropdown(
                label: 'المحلية',
                value: selectedLocality,
                items: localities,
                onChanged: (val) {
                  setState(() {
                    selectedLocality = val;
                    selectedHospital = null;
                    selectedDepartment = null;
                    selectedDoctor = null;
                  });
                },
              ),

              // home details: neighborhod - block
              _buildTextField(
                  'الحي - المربع (مثال: الواحة - 4)', (val) => address = val),

              // selecting a hospital depending on the locality
              _buildDropdown(
                label: 'المستشفى',
                value: selectedHospital,
                items: hospitals,
                onChanged: (val) {
                  setState(() {
                    selectedHospital = val;
                    selectedDepartment = null;
                    selectedDoctor = null;
                  });
                },
              ),

              // selecting a department depending on the hospital
              _buildDropdown(
                label: 'القسم',
                value: selectedDepartment,
                items: availableDepartments,
                onChanged: (val) {
                  setState(() {
                    selectedDepartment = val;
                    selectedDoctor = null;
                  });
                },
              ),

              // selecting a doctor depending on the department
              _buildDropdown(
                label: 'الطبيب',
// look the bugg above (in the doctors testing data)
                value: selectedDoctor,
                items: availableDoctors,
                onChanged: (val) {
                  setState(() {
                    selectedDoctor = val;
                  });
                },
              ),

              SizedBox(height: 30),

              // sending the appoinment
              ElevatedButton.icon(
                icon: Icon(Icons.check_circle_outline),
                label: Text('تأكيد الحجز'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green[700],
                    minimumSize: Size(10, 10)),
                onPressed: () {
/*
Validation of a field can be in its text field or here
*/

                  if (_isFormValid()) {
// save info in database
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إرسال الحجز بنجاح 🎉')));
                  } // if
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('يرجى تعبئة جميع الحقول')));
                  } // else
                },
              ),
            ],
          ),
        ),
      ),
    );
  } // build fun

  // checking is the form is completely full or not
  bool _isFormValid() {
    return fullName != null &&
        age != null &&
        address != null &&
        phoneNumber !=
            null && // we must validate the phone number (10 chars, and start with ...)
        gender != null &&
        selectedState != null &&
        selectedLocality != null &&
        selectedHospital != null &&
        selectedDepartment != null &&
        selectedDoctor != null;
  } // _isFormValid

// build text field must be updated to reseve a validation of each one
  Widget _buildTextField(String label, Function(String) onChanged,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        keyboardType: inputType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: label,
//          labelStyle: TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: onChanged,
      ),
    );
  }

// ready (after solving the bug above line 92)
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
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  } // _buildDropdown
} // _BookingPageTest
