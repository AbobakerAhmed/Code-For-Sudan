import 'package:flutter/material.dart';
import 'package:ministry_app/Backend/ministry_employee.dart';

/*
Issues:
  1- Edit password dialog and logic and performing this change on database
  2- is that logically to show password field here even it is empty?
*/

class ProfileScreen extends StatefulWidget {
  final MinistryEmployee employee;
  const ProfileScreen({super.key, required this.employee});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('الملف الشخصي'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              _buildInfoField(
                context,
                label: 'الاسم:',
                value: widget.employee.getName(),
              ),
              const SizedBox(height: 16),
              _buildInfoField(
                context,
                label: 'رقم الهاتف:', // Mobile Number:
                value: widget.employee.getPhoneNumber(),
              ),
              const SizedBox(height: 16),

              // Is that ture to show password here??
              _buildPasswordField(
                context,
                label: 'كلمة المرور:', // Password:
                value: widget.employee
                    .getPassword(), // Placeholder for password
              ),

              const SizedBox(height: 32),

              // Office Information Section
              const Text(
                'المكتب',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(thickness: 2),

              const SizedBox(height: 16),

              _buildInfoField(
                context,
                label: 'الولاية:',
                value: widget.employee.getState(),
              ),

              const SizedBox(height: 10),

              _buildInfoField(
                context,
                label: 'المحلية:',
                value: widget.employee.getLocality(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align fields to the right
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // No needed here
  Widget _buildPasswordField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    textDirection: TextDirection.ltr,
                    _isPasswordVisible ? value : '•' * value.length,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.right,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16), // Space for the "Edit" button
        TextButton(
          onPressed: () {
            // show edit password dialog here
            print('Edit password tapped');
          },
          child: const Text(
            'تعديل',
            style: TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
