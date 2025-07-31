import 'package:flutter/material.dart';
import 'package:ministry_app/Backend/ministry_employee.dart';

/*
Issues:
  1- Edit password dialog and logic and performing this change on database
  2- is that logically to show password field here even it is empty?
*/

class ProfileScreen extends StatelessWidget {
  final MinistryEmployee employee;
  const ProfileScreen({super.key, required this.employee});

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
            icon: Icon(Icons.arrow_back)),
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
                value: this.employee.getName(),
              ),
              const SizedBox(height: 16),
              _buildInfoField(
                context,
                label: 'رقم الهاتف:', // Mobile Number:
                value: this.employee.getPhoneNumber(),
              ),
              const SizedBox(height: 16),

        // Is that ture to show password here??
              _buildPasswordField(
                context,
                label: 'كلمة المرور:', // Password:
                value: '************', // Placeholder for password
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
                value: this.employee.getState(),
              ),

              const SizedBox(height: 10),

              _buildInfoField(
                context,
                label: 'المحلية:',
                value: this.employee.getLocality(),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.right,
              ),
            ),
          ),

          const SizedBox(width: 16), // Space for the "Edit" button

          TextButton(
            onPressed: () {
              print('Edit password tapped');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // Remove default padding
              minimumSize: Size.zero, // Remove minimum size constraints
              tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap, // Shrink tap target
            ),
            child: TextButton(
              child: Text('تعديل', style: TextStyle(fontSize: 14, color: Colors.blue)),
              onPressed: (){
// show edit password dialog here
              }
            ),
          ),
        ],
    );
  }


  Widget _buildOfficeField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
    );
  }
}
