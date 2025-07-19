import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background as per image
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'الاعدادات', // Settings
              style: TextStyle(
                color: Colors.black,
                fontSize: 24, // Larger font size for title
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.settings, color: Colors.blue.shade700, size: 30),
          ],
        ),
      ),
      body: Column(
        children: [
          // Divider line below the app bar content
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.grey, height: 1, thickness: 0.5),
          ),
          // Settings options list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              children: [
                // Language
                ListTile(
                  title: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اللغة', // Language
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  ),
                  onTap: () {
                    // Handle language settings
                    print('Language tapped');
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                // Appearance
                ListTile(
                  title: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'المظهر', // Appearance
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  ),
                  onTap: () {
                    // Handle appearance settings (e.g., dark/light mode)
                    print('Appearance tapped');
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                // About App
                ListTile(
                  title: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'عن التطبيق', // About the app
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  ),
                  onTap: () {
                    // Handle about app information
                    print('About App tapped');
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                // Logout
                ListTile(
                  title: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'تسجيل الخروج', // Logout
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  ),
                  onTap: () {
                    // Handle logout logic
                    print('Logout tapped');
                    // Example: Navigate back to login screen and clear session
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const LoginPage()),
                    //   (Route<dynamic> route) => false,
                    // );
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
