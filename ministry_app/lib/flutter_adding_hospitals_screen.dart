import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:ministry_app/Backend/global_var.dart';
import 'package:ministry_app/Backend/ministry_employee.dart';
import 'package:ministry_app/global_ui.dart';





/**
    Issues:
    1- idetify hospital class
    2- link with database to upload the new hospital
    3- edit depatments field, make it a list of check boxes
    4- after creating a hospital successfully, clear all fields and show the adding is done successfuly
    4- hospital manager logic?
 */



class AddingHospitalsScreen extends StatefulWidget {
  final MinistryEmployee employee;
  const AddingHospitalsScreen({super.key, required this.employee});

  @override
  State<AddingHospitalsScreen> createState() => _AddingHospitalsScreenState(employee: employee);
}

class _AddingHospitalsScreenState extends State<AddingHospitalsScreen> {
  _AddingHospitalsScreenState({required this.employee});
  late final MinistryEmployee employee;
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _stateNameController = TextEditingController();
  final TextEditingController _localityNameController = TextEditingController();
  final TextEditingController _additionalLocationInfoController =
      TextEditingController();
  final TextEditingController _hospitalManagerNameController =
      TextEditingController();
  final TextEditingController _hospitalManagerPhoneController =
      TextEditingController();
  final TextEditingController _hospitalDepartmentsController =
      TextEditingController();
  // Add these variables for dropdowns
  late String _selectedState = employee.getState();
  late String _selectedLocality = employee.getLocality();
  String? _hospitalType; // To hold 'مستشفى حكومي' or 'مستشفى خاص'


  @override
  void dispose() {
    _hospitalNameController.dispose();
    _stateNameController.dispose();
    _localityNameController.dispose();
    _additionalLocationInfoController.dispose();
    _hospitalManagerNameController.dispose();
    _hospitalManagerPhoneController.dispose();
    _hospitalDepartmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(
              context,
            ); // Go back to the previous screen (Dashboard)
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'إضافة مستشفى', // Add Hospital (Arabic)
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.add_circle,
              color: Colors.blue,
              size: 28,
            ), // Add Hospital icon
            SizedBox(width: 8),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align labels to the right
            children: [
              const Divider(thickness: 1),
              const SizedBox(height: 16),

              // Hospital Data Section
              const Text(
                'بيانات المستشفى', // Hospital Data (Arabic)
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),
              // Hospital Name
              buildLabel('اسم المستشفى'), // Hospital Name (Arabic)
              _buildTextField(
                controller: _hospitalNameController,
                hintText: 'اسم مستشفى...', // Hospital name...
              ),
              const SizedBox(height: 16),

           Row(
             children: [
               // State
               buildLabel('الولاية:'),
               SizedBox(width: 8,),
               Expanded(
                 child: buildFilterDropdown(
                   hint: 'الولاية...', // State...
                   value: _selectedState,
                   items: employee.getState() == "الكل" ? g_states : [employee.getState()],
                   onChanged: (String? newValue) {
                     setState(() {
                       _selectedState = newValue!;
                     });
                   },
                 ),
               ),
               SizedBox(width: 16,),
               // Locality dropdown
               buildLabel('المحلية:'),
               SizedBox(width: 8,),
               Expanded(
                 child: buildFilterDropdown(
                   hint: 'المحلية...', // Locality...
                   value: _selectedLocality,
                   items: this.employee.getLocality() == "الكل" ? g_localities[_selectedState]! : [employee.getLocality()],
                   onChanged: (String? newValue) {
                     setState(() {
                       _selectedLocality = newValue!;
                     });
                   },
                 ),
               ),
             ],
           ),

              const SizedBox(height: 16),

              // Additional Location Info
              buildLabel(
                'بيانات موقع اضافية',
              ), // Additional location info (Arabic)
              _buildTextField(
                controller: _additionalLocationInfoController,
                hintText: 'مثلا: حي كذا، مربع كذا، بشارع كذا، بالقرب من كذا', // Ellipsis as hint
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              // Hospital Departments
              buildLabel('اقسام المستشفى'), // Hospital Departments (Arabic)
              _buildTextField(
                controller: _hospitalDepartmentsController,
                hintText:
                'اكتب اقسام المستشفى...', // Type hospital departments...
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              // Hospital Type Radio Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'نوع المستشفى:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Hospital Type

                  SizedBox(width: 16),

                  Text(
                    'مستشفى حكومي',
                    style: TextStyle(color: Colors.black87),
                  ), // Government Hospital
                  Radio<String>(
                    value: 'مستشفى حكومي',
                    groupValue: _hospitalType,
                    onChanged: (String? value) {
                      setState(() {
                        _hospitalType = value;
                      });
                    },
                  ),
                  SizedBox(width: 16),

                  Text(
                    'مستشفى خاص',
                    style: TextStyle(color: Colors.black87),
                  ),
                  // Private Hospital
                  Radio<String>(
                    value: 'مستشفى خاص',
                    groupValue: _hospitalType,
                    onChanged: (String? value) {
                      setState(() {
                        _hospitalType = value;
                      });
                    },
                  ),
                ],
              ),
              Divider(),

              const SizedBox(height: 32),
              const Text(
                'بيانات مدير المستشفى', // Hospital Data (Arabic)
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Hospital Manager Name and Phone
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildLabel(
                    'الاسم الكامل:',
                  ), // Hospital Manager Name (Arabic)
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _hospitalManagerNameController,
                      hintText: 'محمد أحمد محمد أحمد', // Name...
                    ),
                  ),
                  const SizedBox(width: 16),

                  buildLabel(
                    'رقم الهاتف:',
                  ), // Hospital Manager Phone Number (Arabic)
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _hospitalManagerPhoneController,
                      hintText: '0123456789', // Number...
                      keyboardType: TextInputType.number, // Only numbers
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ], // Only digits
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 16),



              // Send Message Button (Add Hospital Button)
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  onPressed: () {
                    // Clear all fields
                    setState(() {
                      _hospitalNameController.clear();
                      _stateNameController.clear();
                      _localityNameController.clear();
                      _additionalLocationInfoController.clear();
                      _hospitalManagerNameController.clear();
                      _hospitalManagerPhoneController.clear();
                      _hospitalDepartmentsController.clear();
                      _hospitalType = null;
                    });

// create a hospital and send it to database here
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blueAccent.shade400, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'إضافة المستشفى', // Send Message (Arabic) - Assuming this is "Add Hospital" button
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
/*
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
*/
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters, // Add this line
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters, // Add this line
        textAlign: TextAlign.right, // Align text to the right
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
        ),
      ),
    );
  }
}
