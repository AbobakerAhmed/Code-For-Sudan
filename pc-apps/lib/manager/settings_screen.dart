import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
              'الاعدادات', // Settings
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
              Icons.settings, // Gear icon
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

            // Settings Options List
            _buildSettingsOption(
              context,
              text: 'اللغة', // Language
              onTap: () {
                print('Language settings tapped');
                // TODO: Navigate to Language settings
              },
            ),
            _buildSettingsOption(
              context,
              text: 'المظهر', // Appearance
              onTap: () {
                print('Appearance settings tapped');
                // TODO: Navigate to Appearance settings
              },
            ),
            _buildSettingsOption(
              context,
              text: 'عن التطبيق', // About App
              onTap: () {
                print('About App tapped');
                // TODO: Navigate to About App screen
              },
            ),
            _buildSettingsOption(
              context,
              text: 'تسجيل الخروج', // Logout
              onTap: () {
                print('Logout tapped');
                // TODO: Implement logout logic (e.g., clear user session, navigate to login)
                // Example: Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a settings option item
  Widget _buildSettingsOption(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 8.0,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align text to the right
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontFamily: 'Cairo', // Example font
                  ),
                  textDirection: TextDirection.rtl, // Right-to-left for Arabic
                ),
                // You could add an arrow icon here if desired, e.g., Icons.arrow_forward_ios
                // const SizedBox(width: 10),
                // const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
        ), // Divider after each option
      ],
    );
  }
}
