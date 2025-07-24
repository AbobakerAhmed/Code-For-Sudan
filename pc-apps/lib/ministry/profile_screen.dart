import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                'الملف الشخصي', // Personal Profile (Arabic)
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.person, color: Colors.blue, size: 28), // Profile icon
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Information Section
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            _buildInfoField(
              context,
              label: 'الاسم:', // Name:
              value: 'wael mahadi monis',
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              context,
              label: 'رقم الجوال:', // Mobile Number:
              value: '+249 123456789',
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              context,
              label: 'كلمة المرور:', // Password:
              value: '************', // Placeholder for password
            ),
            const SizedBox(height: 32),

            // Office Information Section
            const Text(
              'المكتب', // Office (Arabic)
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textDirection: TextDirection.rtl,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to the right
              children: [
                _buildOfficeField(
                  context,
                  label: 'الولاية:',
                  value: 'الجزيرة',
                ), // State: Al Jazirah
                const SizedBox(width: 16),
                _buildOfficeField(
                  context,
                  label: 'المحلية:',
                  value: 'الكاملين',
                ), // Locality: Al Kamilin
              ],
            ),
            const SizedBox(height: 16),
          ],
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
        mainAxisAlignment: MainAxisAlignment.end, // Align fields to the right
        children: [
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
                textAlign: TextAlign.right, // Align text inside field to right
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

  Widget _buildPasswordField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
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
            child: const Text(
              'تعديل', // Edit (Arabic)
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
      ),
    );
  }
}
