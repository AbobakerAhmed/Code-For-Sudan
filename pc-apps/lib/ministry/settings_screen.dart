import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                'الاعدادات', // Settings (Arabic)
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.settings,
                color: Colors.blue,
                size: 28,
              ), // Settings icon
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align items to the right
          children: [
            const Divider(thickness: 1),
            const SizedBox(height: 24),
            _buildSettingsItem(context, 'اللغة', () {
              print('Language settings tapped');
            }),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'المظهر', () {
              print('Appearance settings tapped');
            }),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'عن التطبيق', () {
              print('About App tapped');
            }),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'تسجيل الخروج', () {
              print('Logout tapped');
              // In a real app, you would handle logout logic here,
              // e.g., clear user session and navigate to login screen.
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        width: double.infinity, // Take full width
        alignment: Alignment.centerRight, // Align text to the right
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
