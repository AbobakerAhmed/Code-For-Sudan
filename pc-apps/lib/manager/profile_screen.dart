import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              'الملف الشخصي', // Profile
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo', // Example font, use a suitable Arabic font
              ),
              textDirection: TextDirection.rtl, // Right-to-left for Arabic
            ),
            SizedBox(width: 10), // Spacing between text and icon
            Icon(
              Icons.person, // Person icon
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

            // Name field
            _buildInfoField(
              context,
              label: 'الاسم:', // Name:
              value: 'wael mahadi monis', // Example value
              isEditable: false,
            ),
            const SizedBox(height: 20),

            // Phone Number field
            _buildInfoField(
              context,
              label: 'رقم الجوال:', // Phone Number:
              value: '+249 123456789', // Example value
              isEditable: false,
            ),
            const SizedBox(height: 20),

            // Password field with Edit button
            _buildPasswordField(
              context,
              label: 'كلمة المرور:', // Password:
              value: '************', // Masked password
              //isEditable: true,
              onEditTap: () {
                print('Edit password tapped');
                // TODO: Implement password edit functionality (e.g., show dialog or navigate to change password screen)
              },
            ),
            const SizedBox(height: 20),

            // Hospital field
            _buildOfficeField(
              context,
              label: 'المستشفى:', // Hospital:
              value: 'مستشفى الجزيرة', // Example value
              //isEditable: false,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a profile field (label, value, optional edit button)
  Widget _buildInfoField(
    BuildContext context, {
    required String label,
    required String value,
    bool isEditable = false,
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
    required VoidCallback onEditTap,
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
          TextButton(
            onPressed: onEditTap,
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
