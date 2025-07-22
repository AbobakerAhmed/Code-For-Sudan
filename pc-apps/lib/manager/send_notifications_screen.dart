import 'package:flutter/material.dart';

class SendNotificationsScreen extends StatefulWidget {
  const SendNotificationsScreen({super.key});

  @override
  State<SendNotificationsScreen> createState() =>
      _SendNotificationsScreenState();
}

class _SendNotificationsScreenState extends State<SendNotificationsScreen> {
  String? _selectedDepartment;
  String? _selectedEmployee;
  final TextEditingController _messageController = TextEditingController();

  final List<String> _departments = [
    'الباطنية',
    'العظام',
    'القلب',
    'الاطفال',
  ]; // Internal Medicine, Orthopedics, Cardiology, Pediatrics
  final List<String> _employees = [
    'دكتور',
    'ممرض',
    'فني',
    'الكل',
  ]; // Doctor, Nurse, Technician, All

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
          mainAxisAlignment: MainAxisAlignment.end, // Align title to the right
          children: [
            Text(
              'ارسال الاشعارات', // Send Notifications
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
              Icons.send, // Placeholder for clipboard with arrow icon
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
            _buildStyledDropdown(
              hintText:
                  'الباطنية', // Internal Medicine (default/selected in image)
              value: _selectedDepartment,
              items: _departments,
              onChanged: (newValue) {
                setState(() {
                  _selectedDepartment = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Employee Dropdown
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الموظف', // Employee
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontFamily: 'Cairo',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 8),
            _buildStyledDropdown(
              hintText: 'دكتور', // Doctor (default/selected in image)
              value: _selectedEmployee,
              items: _employees,
              onChanged: (newValue) {
                setState(() {
                  _selectedEmployee = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Subject/Message Input
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الموضوع', // Subject
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 5, // Allows for multiple lines of text
                textAlign:
                    TextAlign.right, // Align text to the right for Arabic input
                decoration: InputDecoration(
                  hintText: 'نص الرسالة...', // Message Text...
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                  border: InputBorder.none, // Remove default TextField border
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
                style: const TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                textDirection:
                    TextDirection.rtl, // Right-to-left for Arabic input
              ),
            ),
            const SizedBox(height: 40),

            // Send Message Button
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
}
