import 'package:flutter/material.dart';
import 'package:pc_apps/doctor/flutter_booking_screen.dart';
import 'package:pc_apps/doctor/flutter_notification_screen.dart';
import 'package:pc_apps/doctor/flutter_settings_screen.dart';
import 'package:pc_apps/doctor/flutter_profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for the dashboard
      appBar: AppBar(
        backgroundColor: Colors.white, // White app bar background
        elevation: 0, // No shadow under the app bar
        actions: [
          // Settings icon button - Navigates to SettingsScreen
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          // Profile icon button - Navigates to ProfileScreen
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 16), // Horizontal space
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for the logo in the app bar.
                const Icon(
                  Icons.medical_services,
                  size: 24,
                  color: Colors.green,
                ),
                const Text(
                  'جمهورية السودان',
                  style: TextStyle(fontSize: 8, color: Colors.black87),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const Text(
                  'وزارة الصحة الاتحادية',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 150, // Adjust this based on logo size and text
      ),
      body: Column(
        // Wrapped the body content in a Column
        children: [
          Expanded(
            // Make the content take up remaining vertical space
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: GridView.count(
                crossAxisCount: 2, // Two columns in the grid
                crossAxisSpacing: 24.0, // Horizontal spacing between cards
                mainAxisSpacing: 24.0, // Vertical spacing between cards
                childAspectRatio: 1.0, // Make cards square
                children: <Widget>[
                  // Dashboard Card for 'Notifications'
                  _buildDashboardCard(
                    context,
                    icon: Icons.notifications_active,
                    text: 'الاشعارات', // Notifications (Arabic)
                    onTap: () {
                      // Navigate to the NotificationsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  // Dashboard Card for 'Reservations'
                  _buildDashboardCard(
                    context,
                    icon: Icons
                        .event_note, // Using event_note icon for reservations
                    text: 'الحجوزات', // Reservations (Arabic)
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a dashboard card.
  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // Handles tap events on the card
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers content within the card
          children: [
            Icon(
              icon, // Icon for the card
              size: 80, // Increased icon size to match the new image
              color: Colors.blue, // Example color for icons
            ),
            const SizedBox(height: 16), // Increased vertical space
            Text(
              text, // Text for the card
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ), // Increased font size
              textAlign: TextAlign.center,
              textDirection:
                  TextDirection.rtl, // Right-to-left text direction for Arabic
            ),
          ],
        ),
      ),
    );
  }
}
