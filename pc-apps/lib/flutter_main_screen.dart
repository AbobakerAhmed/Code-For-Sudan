import 'package:flutter/material.dart';

// DashboardScreen is a StatelessWidget as it doesn't manage mutable state.
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
          // Settings icon button
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              print('Settings tapped');
            },
          ),
          // Profile icon button
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              print('Profile tapped');
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
      body: Padding(
        // Reduced padding to make the grid more compact and less likely to scroll
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two columns in the grid
          // Reduced spacing between cards for a more compact layout
          crossAxisSpacing: 16.0, // Horizontal spacing between cards
          mainAxisSpacing: 16.0, // Vertical spacing between cards
          // The GridView itself will automatically become scrollable if its content
          // exceeds the available screen height. This layout is optimized to fit
          // on most standard mobile screens without needing to scroll.
          children: <Widget>[
            // Dashboard Card for 'Reports'
            _buildDashboardCard(
              context,
              icon: Icons.description,
              text: 'التقارير', // Reports (Arabic)
              onTap: () {
                print('Reports tapped');
              },
            ),
            // Dashboard Card for 'Add Hospital'
            _buildDashboardCard(
              context,
              icon: Icons.add_circle,
              text: 'اضافة مستشفى', // Add Hospital (Arabic)
              onTap: () {
                print('Add Hospital tapped');
              },
            ),
            // Dashboard Card for 'Notifications'
            _buildDashboardCard(
              context,
              icon: Icons.notifications_active,
              text: 'الاشعارات', // Notifications (Arabic)
              onTap: () {
                print('Notifications tapped');
              },
            ),
            // Dashboard Card for 'Send Notifications'
            _buildDashboardCard(
              context,
              icon: Icons.send,
              text: 'ارسال الاشعارات', // Send Notifications (Arabic)
              onTap: () {
                print('Send Notifications tapped');
              },
            ),
          ],
        ),
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
              size: 60,
              color: Colors.blue, // Example color for icons
            ),
            const SizedBox(height: 16), // Vertical space
            Text(
              text, // Text for the card
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
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
