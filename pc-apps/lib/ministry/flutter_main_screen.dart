import 'package:flutter/material.dart';
import 'package:pc_apps/ministry/Backend/ministry_employee.dart'; // MinistryEmployee
import 'package:pc_apps/ministry/flutter_login_screen.dart';
import 'package:pc_apps/ministry/flutter_notification_screen.dart';
import 'package:pc_apps/ministry/flutter_profile_screen.dart';
import 'package:pc_apps/ministry/flutter_settings_screen.dart';
import 'package:pc_apps/ministry/flutter_notification_sending_screen.dart';
import 'package:pc_apps/ministry/flutter_reporting_screen.dart';
import 'package:pc_apps/ministry/flutter_adding_hospitals_screen.dart';

/**
    Issues:
    1- the truth way is not passing the ministry employee in each page, but it is work ;)
    2- when going to notifications, waiting screen while downloading notifications
    3- edit the header (setting is not work and logout icon)
 */


// HomePage is a StatelessWidget as it doesn't manage mutable state.
class HomePage extends StatelessWidget {
  final MinistryEmployee employee;
  const HomePage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white, // White background for the dashboard
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text("الصفحة الرئيسية"),

          elevation: 0, // No shadow under the app bar
          actions: [
            // logout button
            IconButton(
              icon: const Icon(Icons.logout, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ); // Navigate to SettingsScreen
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
                  MaterialPageRoute(builder: (context) => ProfileScreen(employee:this.employee)),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Wrapped the body content in a Column
            children: [
              Expanded(flex:2, child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(""),
                  Image.asset(
                    'assets/health_ministry_loge.jpg',
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                  ),
                ],
              )),
              Expanded(
                flex: 2,
                child: Row(
                      children: [
                        Expanded(child: Text("")),

                        // Dashboard Card for 'Add Hospital'
                        _buildCard(
                          context,
                          icon: Icons.add_circle,
                          text: 'اضافة مستشفى', // Add Hospital (Arabic)
                          onTap: () {
                            print('Add Hospital tapped');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddingHospitalsScreen(employee: employee,),
                              ),
                            ); // Navigate to AddingHospitalScreen
                          },
                        ),
                        // Dashboard Card for 'Reports'
                        _buildCard(
                          context,
                          icon: Icons.description,
                          text: 'التقارير', // Reports (Arabic)
                          onTap: () {
                            print('Reports tapped');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportingScreen(employee: employee),
                              ),
                            ); // Navigate to ReportingScreen
                          },
                        ),
                        Expanded(flex:2, child: Text("")),

                      ],
                    ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(child: Text("")),

                    // Dashboard Card for 'Send Notifications'
                    _buildCard(
                      context,
                      icon: Icons.send,
                      text: 'ارسال الاشعارات', // Send Notifications (Arabic)
                      onTap: () {
                        print('Send Notifications tapped');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationSendingScreen(employee: this.employee),
                          ),
                        ); // Navigate to notification sending screen
                      },
                    ),
                    // Dashboard Card for 'Notifications'
                    _buildCard(
                      context,
                      icon: Icons.notifications_active,
                      text: 'الاشعارات', // Notifications (Arabic)
                      onTap: () {
                        print('Notifications tapped');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsScreen(employee: this.employee),
                          ),
                        ); // Navigate to NotificationScreen
                      },
                    ),
                    Expanded(flex:2, child: Text("")),
                  ],
                ),
              ),
              Expanded(child: Text("")),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a dashboard card.
  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      flex: 5,
      child: GestureDetector(
        onTap: onTap, // Handles tap events on the card
        child: Card(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers content within the card
            children: [
              Icon(
                icon, // Icon for the card
                size: 60,
                color: Colors.lightBlue, // Example color for icons
              ),
              const SizedBox(height: 16), // Vertical space
              Text(
                text, // Text for the card
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                    color: Colors.blueGrey
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
