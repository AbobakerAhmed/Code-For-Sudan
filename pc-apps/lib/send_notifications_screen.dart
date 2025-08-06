import 'package:flutter/material.dart';
import 'package:pc_apps/global_ui.dart';

class SendNotificationsScreen extends StatefulWidget {
  const SendNotificationsScreen({super.key});

  @override
  State<SendNotificationsScreen> createState() =>
      _SendNotificationsScreenState();
}

class _SendNotificationsScreenState extends State<SendNotificationsScreen> {
  String? _selectedDepartment;
  String? _selectedEmployee;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<String> _departments = [
    'الكل',
    'الباطنية',
    'العظام',
    'القلب',
    'الاطفال',
  ];
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'إرسال إشعارات', // Notifications
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo', // Example font
              ),
              textDirection: TextDirection.rtl, // Right-to-left for Arabic
            ),
            SizedBox(width: 10), // Spacing between text and icon
            Directionality(textDirection: TextDirection.rtl, child: Icon(
              Icons.send, // Placeholder for bell with plus
              color: Colors.deepPurple,
              size: 35,
            ),),
            SizedBox(width: 10), // Spacing between text and icon
          ],
        ),
        titleSpacing: 0, // Remove default title spacing
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(
                height: 1,
                color: Colors.grey,
              ), // Thin horizontal line below app bar
              const SizedBox(height: 30),
              Expanded(child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Department Dropdown
                    Row(
                      children: [
                        buildLabel('القسم:'),
                        const SizedBox(width: 8),
                        buildFilterDropdown(
                          hint: 'الكل', // Internal Medicine (default/selected in image)
                          value: _selectedDepartment,
                          items: _departments,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDepartment = newValue;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Employee Dropdown
                    Row(
                      children: [
                        buildLabel('نوع الوظيفة:'),
                        const SizedBox(width: 8),
                        buildFilterDropdown(
                          hint: 'الكل',
                          value: _selectedEmployee,
                          items: [
                            'الكل',
                            'دكتور',
                            'مسجل',
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              _selectedEmployee = newValue;
                            });
                          },
                        ),],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        buildLabel('الموظف:'),
                        const SizedBox(width: 8),
                        buildFilterDropdown(
                          hint: 'الكل', // Internal Medicine (default/selected in image)
                          value: _selectedDepartment,
                          items: ['الكل'],
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDepartment = newValue;
                            });
                          },
                        ),],
                    ),
                    const SizedBox(height: 20),

                    // Subject/Message Input
                    buildLabel('العنوان'),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _subjectController, hintText: "الموضوع"),
                    const SizedBox(height: 20),

                    // Subject/Message Input
                    buildLabel('الرسالة'),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _messageController, hintText: "نص الرسالة..", maxLines: 5),            const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        final department = _selectedDepartment ?? 'N/A';
                        final employee = _selectedEmployee ?? 'N/A';
                        final message = _messageController.text;
                        print(
                          'Sending message to Department: $department, Employee: $employee, Message: $message',
                        );
                        // TODO: Implement send notification logic

                        // Clear all fields
                        setState(() {
                          _selectedDepartment = null;
                          _selectedEmployee = null;
                          _messageController.clear();
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
                        'ارسال الرسالة', // Send Message
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
              )),
              // Send Message Button
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build styled dropdowns
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
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ), // Dropdown arrow
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
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
    );
  }


}
