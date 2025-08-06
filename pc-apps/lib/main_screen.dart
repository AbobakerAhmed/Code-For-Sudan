import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pc_apps/Backend/hospital.dart';
import 'package:pc_apps/Backend/hospital_manager.dart';
import 'package:pc_apps/employee_management_screen.dart'; // Import NotificationsScreen
import 'package:pc_apps/login_screen.dart';
import 'package:pc_apps/notification_screen.dart'; // Import SendNotificationsScreen
import 'package:pc_apps/medical_data_management_screen.dart';
import 'package:pc_apps/send_notifications_screen.dart';
import 'package:pc_apps/settings_screen.dart';
import 'package:pc_apps/profile_screen.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key,required this.manager});
   HospitalManager manager;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text("الصفحة الرئيسية"),

        elevation: 0, // No shadow under the app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 30),
            onPressed: () {
              print('Profile tapped');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ); // Navigate to ProfileScreen
            },
          ),
          // Settings icon button
          IconButton(
            icon: const Icon(Icons.settings, size: 30),
            onPressed: () {
              print('Settings tapped');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ); // Navigate to SettingsScreen
            },
          ),
          // Profile icon button
          IconButton(
            icon: const Icon(Icons.person, size: 30),
            onPressed: () {
              print('Profile tapped');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(manager: manager)),
              ); // Navigate to ProfileScreen
            },
          ),
          const SizedBox(width: 16), // Horizontal space
        ],
// put the logo here
//          leading:
//          leadingWidth: 150, // Adjust this based on logo size and text
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Two cards per row
                crossAxisSpacing: 16.0, // Spacing between columns
                mainAxisSpacing: 16.0, // Spacing between rows
                childAspectRatio: 2.3, // Adjust aspect ratio for card size
                children: [
                  // Employee Management (إدارة الموظفين)
                  _buildFeatureCard(
                    context,
                    icon: Icons.event_note,
                        // .person_add_alt_1, // A suitable icon for employee management
                    label: 'إدارة المرضى والحجوزات',
                    onTap: () {
                      print('Employee Management tapped');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MedicalDataManagementScreen(hospital: manager.hospital),
                        ),
                      );
                    },
                  ),
                  // Medical Data Management (إدارة البيانات الطبية)
                  _buildFeatureCard(
                    context,
                    icon: FontAwesomeIcons.userDoctor, // A suitable icon for data management
                    label: 'إدارة الطاقم الطبي',
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              EmployeeManagementScreen(hospital: manager.hospital),
                        ),
                      );
                    },
                  ),
                  // Notifications (الاشعارات)
                  _buildFeatureCard(
                    context,
                    icon: Icons.notifications,
                    label: 'الاشعارات',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  // Send Notifications (ارسال التقارير)
                  _buildFeatureCard(
                    context,
                    icon: Icons
                        .send, // A suitable icon for sending notifications
                    label: 'ارسال التقارير',
                    onTap: () {
                      print('Send Notifications tapped');

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildFeatureCard(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  bool showBadge = false,
  int badgeCount = 0,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 3,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Stack(
        children: [
          Center(
            // Add this Center widget
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.blue.shade700, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showBadge && badgeCount > 0)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
