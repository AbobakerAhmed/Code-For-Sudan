import 'package:flutter/material.dart';

class MedicalDataScreen extends StatefulWidget {
  const MedicalDataScreen({super.key});

  @override
  State<MedicalDataScreen> createState() => _MedicalDataScreenState();
}

class _MedicalDataScreenState extends State<MedicalDataScreen> {
  String? _selectedCaseType;
  String? _selectedDepartment;
  String? _selectedSortOption;

  // Example data for dropdowns, based on previous screens and common medical terms
  final List<String> _caseTypes = [
    'الكل',
    'وفيات',
    'عمليات',
    'دخولات',
    'خروجات',
  ]; // All, Deaths, Operations, Admissions, Discharges
  final List<String> _departments = [
    'الكل',
    'الباطنية',
    'العظام',
    'القلب',
    'الاطفال',
  ]; // All, Internal Medicine, Orthopedics, Cardiology, Pediatrics
  final List<String> _sortOptions = ['التاريخ', 'الأهمية']; // Date, Importance

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
              'البيانات الطبية', // Medical Data
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
      body: Column(
        children: [
          const Divider(
            height: 1,
            color: Colors.grey,
          ), // Thin horizontal line below app bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Filter and Sort Options Row (rearranged for Arabic display)
                Row(
                  children: [
                    // Case Type Dropdown (Right-most in UI, left-most in code for RTL)
                    Expanded(
                      child: _buildStyledDropdown(
                        hintText: 'نوع الحالة', // Case Type
                        value: _selectedCaseType,
                        items: _caseTypes,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCaseType = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Date Icon/Placeholder (middle)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.deepPurple,
                            size: 20,
                          ), // Calendar icon
                          SizedBox(width: 8),
                          Text(
                            '24-04-2025', // Example date
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Cairo',
                              fontSize: 16,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),

                    /*GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _buildStyledTextField(
                          controller: _dateController,
                          hintText: 'YYYY-MM-DD',
                          suffixIcon: Icons.calendar_today, // Calendar icon
                        ),
                      ),
                    ),*/
                    const SizedBox(width: 10),
                    // Sort Dropdown (middle-left)
                    Expanded(
                      child: _buildStyledDropdown(
                        hintText: 'ترتيب', // Sort
                        value: _selectedSortOption,
                        items: _sortOptions,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSortOption = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Department Dropdown (Left-most in UI, right-most in code for RTL)
                    Expanded(
                      child: _buildStyledDropdown(
                        hintText: 'القسم', // Department
                        value: _selectedDepartment,
                        items: _departments,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDepartment = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Spacing below filters
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: 4, // Example count
              itemBuilder: (context, index) {
                final List<Map<String, String>> medicalDataEntries = [
                  {
                    'name': 'محمد عثمان علي', // Mohammed Othman Ali
                    'gender': 'ذكر', // Male
                    'age': '48', // Age: 48
                    'department': 'الباطنية', // Internal Medicine
                    'phone': '+249123456789', // Phone
                  },
                  {
                    'name': 'خديجة ابراهيم عمر', // Khadija Ibrahim Omar
                    'gender': 'انثى', // Female
                    'age': '33', // Age: 33
                    'department': 'العظام', // Orthopedics
                    'phone': '+249123456789', // Phone
                  },
                  {
                    'name':
                        'احمد سليمان', // Example data not in image but for filling list
                    'gender': 'ذكر',
                    'age': '60',
                    'department': 'القلب',
                    'phone': '+249987654321',
                  },
                  {
                    'name':
                        'فاطمة محمد', // Example data not in image but for filling list
                    'gender': 'انثى',
                    'age': '12',
                    'department': 'الاطفال',
                    'phone': '+249112233445',
                  },
                ];
                final entry = medicalDataEntries[index];
                return MedicalDataListItem(
                  name: entry['name']!,
                  gender: entry['gender']!,
                  age: entry['age']!,
                  department: entry['department']!,
                  phone: entry['phone']!,
                );
              },
            ),
          ),
          const SizedBox(height: 20), // Spacing before the button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                print('Send Report to Ministry tapped');
                // TODO: Implement logic to send report to ministry
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
                'ارسال تقرير للوزارة', // Send Report to Ministry
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          const SizedBox(height: 20), // Spacing at the bottom
        ],
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
        borderRadius: BorderRadius.circular(10),
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
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        ),
      ),
    );
  }
}

// Reusable Widget for Medical Data List Items
class MedicalDataListItem extends StatelessWidget {
  final String name;
  final String gender;
  final String age;
  final String department;
  final String phone;

  const MedicalDataListItem({
    super.key,
    required this.name,
    required this.gender,
    required this.age,
    required this.department,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align all text to the right
          children: [
            Text(
              name, // Patient Name
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$age: العمر', // Age:
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(width: 10),
                Text(
                  '$gender: الجنس', // Gender:
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  phone, // Phone
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(width: 5),
                const Text(
                  ':الهاتف', // Phone:
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(width: 10),
                Text(
                  department, // Department
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(width: 5),
                const Text(
                  ':القسم', // Department:
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
