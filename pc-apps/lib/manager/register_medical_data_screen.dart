import 'package:flutter/material.dart';

class RegisterMedicalDataScreen extends StatefulWidget {
  const RegisterMedicalDataScreen({super.key});

  @override
  State<RegisterMedicalDataScreen> createState() =>
      _RegisterMedicalDataScreenState();
}

class _RegisterMedicalDataScreenState extends State<RegisterMedicalDataScreen> {
  String? _selectedCaseType;
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientIdPhoneController =
      TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();

  final List<String> _caseTypes = [
    'وفيات', // Deaths
    'عمليات', // Operations
    'دخولات', // Admissions
    'خروجات', // Discharges
  ];

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientIdPhoneController.dispose();
    _departmentController.dispose();
    _dateController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Transparent to blend with background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align title to the right
          children: [
            Text(
              'تسجيل البيانات الطبية', // Register Medical Data
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo', // Example font
              ),
              textDirection: TextDirection.rtl, // Right-to-left for Arabic
            ),
            SizedBox(width: 10), // Spacing between text and icon
            Icon(
              Icons.assignment, // Placeholder for clipboard with pencil icon
              color: Colors.deepPurple,
              size: 35,
            ),
          ],
        ),
        titleSpacing: 0, // Remove default title spacing
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
              height: 1,
              color: Colors.grey,
            ), // Thin horizontal line below app bar
            const SizedBox(height: 30),

            // Case Type Dropdown
            _buildLabel('نوع الحالة'), // Case Type
            const SizedBox(height: 8),
            _buildStyledDropdown(
              hintText: 'النوع ...', // Type ...
              value: _selectedCaseType,
              items: _caseTypes,
              onChanged: (newValue) {
                setState(() {
                  _selectedCaseType = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Patient Name Input
            _buildLabel('اسم المريض'), // Patient Name
            const SizedBox(height: 8),
            _buildStyledTextField(
              controller: _patientNameController,
              hintText: 'الاسم ...', // Name ...
            ),
            const SizedBox(height: 20),

            // Patient ID/Phone Input
            _buildLabel('رقم الهوية/الهاتف'), // ID/Phone Number
            const SizedBox(height: 8),
            _buildStyledTextField(
              controller: _patientIdPhoneController,
              hintText: 'الرقم ...', // Number ...
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Department Input
            _buildLabel('القسم'), // Department
            const SizedBox(height: 8),
            _buildStyledTextField(
              controller: _departmentController,
              hintText: 'القسم ...', // Department ...
            ),
            const SizedBox(height: 20),

            // Date Input with Calendar Icon
            _buildLabel('التاريخ'), // Date
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildStyledTextField(
                  controller: _dateController,
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: Icons.calendar_today, // Calendar icon
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Diagnosis Input
            _buildLabel('التشخيص'), // Diagnosis
            const SizedBox(height: 8),
            _buildStyledTextField(
              controller: _diagnosisController,
              hintText: 'التشخيص ...', // Diagnosis ...
              maxLines: 5, // Allow multi-line input
            ),
            const SizedBox(height: 40),

            // Send Button
            ElevatedButton(
              onPressed: () {
                // TODO: Implement send data logic
                print('Case Type: $_selectedCaseType');
                print('Patient Name: ${_patientNameController.text}');
                print('ID/Phone: ${_patientIdPhoneController.text}');
                print('Department: ${_departmentController.text}');
                print('Date: ${_dateController.text}');
                print('Diagnosis: ${_diagnosisController.text}');

                // Clear all fields
                setState(() {
                  _selectedCaseType = null;
                  _patientNameController.clear();
                  _patientIdPhoneController.clear();
                  _departmentController.clear();
                  _dateController.clear();
                  _diagnosisController.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Purple background
                foregroundColor: Colors.white, // Text color
                minimumSize: const Size(
                  double.infinity,
                  60,
                ), // Full width, fixed height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                elevation: 2, // Slight shadow
              ),
              child: const Text(
                'ارسال', // Send
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text labels
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
          fontFamily: 'Cairo',
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  // Helper method to build styled TextFields
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
    IconData? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textAlign: TextAlign.right, // Align text to the right for Arabic input
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
          border: InputBorder.none, // Remove default TextField border
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon,
                  color: Colors.deepPurple,
                ) // Suffix icon (e.g., calendar)
              : null,
        ),
        style: const TextStyle(fontSize: 16, fontFamily: 'Cairo'),
        textDirection: TextDirection.rtl, // Right-to-left for Arabic input
      ),
    );
  }

  // Helper method to build styled dropdowns (reused from other screens)
  Widget _buildStyledDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hintText,
            style: const TextStyle(color: Colors.black87, fontFamily: 'Cairo'),
            textDirection: TextDirection.rtl,
          ),
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String itemValue) {
            return DropdownMenuItem<String>(
              value: itemValue,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  itemValue,
                  style: const TextStyle(fontFamily: 'Cairo'),
                  textDirection: TextDirection.rtl,
                ),
              ),
            );
          }).toList(),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ), // Dropdown arrow
        ),
      ),
    );
  }
}
