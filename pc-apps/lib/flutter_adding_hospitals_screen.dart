import 'package:flutter/material.dart';

class AddingHospitalsScreen extends StatefulWidget {
  const AddingHospitalsScreen({super.key});

  @override
  State<AddingHospitalsScreen> createState() => _AddingHospitalsScreenState();
}

class _AddingHospitalsScreenState extends State<AddingHospitalsScreen> {
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
        title: const Directionality(
          textDirection: TextDirection.rtl, // Right-to-left for Arabic title
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'اضافة مستشفى', // Add Hospital (Arabic)
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
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align labels to the right
          children: [
            const Divider(thickness: 1),
            const SizedBox(height: 16),

            // Hospital Name
            _buildLabel('اسم المستشفى'), // Hospital Name (Arabic)
            _buildTextField(
              controller: _hospitalNameController,
              hintText: 'اسم مستشفى...', // Hospital name...
            ),
            const SizedBox(height: 16),

            // State
            _buildLabel('الولاية'), // State (Arabic)
            _buildTextField(
              controller: _stateNameController,
              hintText: 'اسم الولاية...', // State name...
            ),
            const SizedBox(height: 16),

            // Locality
            _buildLabel('المحلية'), // Locality (Arabic)
            _buildTextField(
              controller: _localityNameController,
              hintText: 'اسم المحلية...', // Locality name...
            ),
            const SizedBox(height: 16),

            // Additional Location Info
            _buildLabel(
              'بيانات موقع اضافية',
            ), // Additional location info (Arabic)
            _buildTextField(
              controller: _additionalLocationInfoController,
              hintText: '...', // Ellipsis as hint
              maxLines: 3,
            ),
            const SizedBox(height: 32),

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
            const Divider(thickness: 1),
            const SizedBox(height: 16),

            // Hospital Type Radio Buttons
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'مستشفى خاص',
                    style: TextStyle(color: Colors.black87),
                  ), // Private Hospital
                  Radio<String>(
                    value: 'مستشفى خاص',
                    groupValue: _hospitalType,
                    onChanged: (String? value) {
                      setState(() {
                        _hospitalType = value;
                      });
                    },
                  ),
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
                    'نوع المستشفى',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Hospital Type
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Hospital Manager Name and Phone
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _hospitalManagerPhoneController,
                    hintText: 'الرقم...', // Number...
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 16),
                _buildLabel(
                  'رقم هاتف مدير المستشفى',
                ), // Hospital Manager Phone Number (Arabic)
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _hospitalManagerNameController,
                    hintText: 'الاسم...', // Name...
                  ),
                ),
                const SizedBox(width: 16),
                _buildLabel(
                  'اسم مدير المستشفى',
                ), // Hospital Manager Name (Arabic)
              ],
            ),
            const SizedBox(height: 16),

            // Hospital Departments
            _buildLabel('اقسام المستشفى'), // Hospital Departments (Arabic)
            _buildTextField(
              controller: _hospitalDepartmentsController,
              hintText:
                  'اكتب اقسام المستشفى...', // Type hospital departments...
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Send Message Button (Add Hospital Button)
            SizedBox(
              width: double.infinity, // Full width button
              child: ElevatedButton(
                onPressed: () {
                  // Handle adding hospital logic here
                  print('Add Hospital Tapped!');
                  print('Hospital Name: ${_hospitalNameController.text}');
                  print('State: ${_stateNameController.text}');
                  print('Locality: ${_localityNameController.text}');
                  print(
                    'Additional Info: ${_additionalLocationInfoController.text}',
                  );
                  print('Hospital Type: $_hospitalType');
                  print('Manager Name: ${_hospitalManagerNameController.text}');
                  print(
                    'Manager Phone: ${_hospitalManagerPhoneController.text}',
                  );
                  print('Departments: ${_hospitalDepartmentsController.text}');
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
                  'ارسال الرسالة', // Send Message (Arabic) - Assuming this is "Add Hospital" button
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
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
