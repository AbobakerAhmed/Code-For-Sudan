import 'package:flutter/material.dart';

class EmployeeDataManagementScreen extends StatefulWidget {
  const EmployeeDataManagementScreen({super.key});

  @override
  State<EmployeeDataManagementScreen> createState() =>
      _EmployeeDataManagementScreenState();
}

class _EmployeeDataManagementScreenState
    extends State<EmployeeDataManagementScreen> {
  String? _selectedJobTitle;
  String? _selectedDepartment;

  final List<String> _jobTitles = [
    'دكتور',
    'ممرض',
    'فني',
  ]; // Doctor, Nurse, Technician
  final List<String> _departments = [
    'العظام',
    'القلب',
    'الاطفال',
  ]; // Orthopedics, Cardiology, Pediatrics

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
              'إدارة بيانات الموظفين', // Employee Data Management
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
              Icons.person_pin_outlined, // Placeholder for the custom icon
              color: Colors.deepPurple,
              size: 35,
            ),
          ],
        ),
        titleSpacing: 0, // Remove default title spacing
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
              height: 1,
              color: Colors.grey,
            ), // Thin horizontal line below app bar
            const SizedBox(height: 30),

            // Job Title Dropdown
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الوظيفة', // Job Title
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontFamily: 'Cairo',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text(
                    'دكتور', // Doctor (default/selected value in image)
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Cairo',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  value: _selectedJobTitle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedJobTitle = newValue;
                    });
                  },
                  items: _jobTitles.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          value,
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
            ),
            const SizedBox(height: 20),

            // Department Dropdown
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'القسم', // Department
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontFamily: 'Cairo',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text(
                    'العظام', // Orthopedics (default/selected value in image)
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Cairo',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  value: _selectedDepartment,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDepartment = newValue;
                    });
                  },
                  items: _departments.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          value,
                          style: const TextStyle(fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Add Employee Button
            ElevatedButton.icon(
              onPressed: () {
                print('Add Employee tapped');
                // TODO: Implement add employee logic/navigation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background
                foregroundColor: Colors.deepPurple, // Icon and text color
                minimumSize: const Size(
                  double.infinity,
                  60,
                ), // Full width, fixed height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                elevation: 2, // Slight shadow
              ),
              icon: const Icon(
                Icons.person_add, // Person with plus icon
                size: 30,
              ),
              label: const Text(
                'اضافة موظف', // Add Employee
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 30),

            // Current Employees List Title
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'قائمة الموظفين الحاليين', // List of Current Employees
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontFamily: 'Cairo',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 20),

            // Employee List (Using ListView.builder for scrollability and efficiency)
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Example count
                itemBuilder: (context, index) {
                  // Example data for demonstration
                  final List<Map<String, String>> employees = [
                    {'name': 'د. احمد علي احمد', 'phone': '+249123456789'},
                    {'name': 'د.تسنيم هاشم الطيب', 'phone': '+249123456789'},
                    {'name': 'د.الظاهر الطيب حسن', 'phone': '+249123456789'},
                    {'name': 'د.تسنيم هاشم الطيب', 'phone': '+249123456789'},
                    {'name': 'د. احمد علي احمد', 'phone': '+249123456789'},
                  ];
                  final employee = employees[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Buttons (Edit and Delete)
                        Row(
                          children: [
                            SizedBox(
                              width: 80, // Fixed width for consistency
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Edit ${employee['name']}');
                                  // TODO: Implement edit logic
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Blue for Edit
                                  padding:
                                      EdgeInsets.zero, // Remove default padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'تعديل', // Edit
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: 'Cairo',
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 80, // Fixed width for consistency
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Delete ${employee['name']}');
                                  // TODO: Implement delete logic
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red, // Red for Delete
                                  padding:
                                      EdgeInsets.zero, // Remove default padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'حذف الموظف', // Delete Employee
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: 'Cairo',
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Employee Phone and Name
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                employee['phone']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                textDirection:
                                    TextDirection.ltr, // LTR for phone number
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                child: Text(
                                  employee['name']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontFamily: 'Cairo',
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Handle long names
                                  textDirection:
                                      TextDirection.rtl, // RTL for name
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
