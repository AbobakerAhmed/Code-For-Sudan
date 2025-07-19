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
            _buildProfileField(
              context,
              label: 'الاسم:', // Name:
              value: 'wael mahadi monis', // Example value
              isEditable: false,
            ),
            const SizedBox(height: 20),

            // Phone Number field
            _buildProfileField(
              context,
              label: 'رقم الجوال:', // Phone Number:
              value: '+249 123456789', // Example value
              isEditable: false,
            ),
            const SizedBox(height: 20),

            // Password field with Edit button
            _buildProfileField(
              context,
              label: 'كلمة المرور:', // Password:
              value: '************', // Masked password
              isEditable: true,
              onEditTap: () {
                print('Edit password tapped');
                // TODO: Implement password edit functionality (e.g., show dialog or navigate to change password screen)
              },
            ),
            const SizedBox(height: 20),

            // Hospital field
            _buildProfileField(
              context,
              label: 'المستشفى:', // Hospital:
              value: 'مستشفى الجزيرة', // Example value
              isEditable: false,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a profile field (label, value, optional edit button)
  Widget _buildProfileField(
    BuildContext context, {
    required String label,
    required String value,
    bool isEditable = false,
    VoidCallback? onEditTap,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.end, // Align everything to the right
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontFamily: 'Cairo',
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontFamily: 'Cairo',
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: onEditTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple, // Purple background for edit button
                  foregroundColor: Colors.white, // White text
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  minimumSize: Size.zero, // Use minimum size
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // Shrink tap target
                ),
                child: const Text(
                  'تعديل', // Edit
                  style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
