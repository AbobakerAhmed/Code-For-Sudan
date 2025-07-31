import 'package:flutter/material.dart';
import 'package:pc_apps/Backend/hospital.dart';
import 'package:pc_apps/booking_screen.dart';
import 'package:pc_apps/medical_data_screen.dart';
import 'package:pc_apps/register_medical_data_screen.dart';

class MedicalDataManagementScreen extends StatelessWidget {

  Hospital hospital;
  MedicalDataManagementScreen({super.key, required this.hospital});

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
              'إدارة البيانات الطبية', // Medical Data Management
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
              Icons.security, // Placeholder for the custom shield/person icon
              color: Colors.deepPurple,
              size: 35,
            ),
            SizedBox(width: 10), // Spacing between text and icon

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

            // Card 1: Bookings/Reservations
            CardOption(
              icon: Icons.calendar_today, // Calendar with checkmark/cross
              text: 'الحجوزات', // Bookings / Reservations
              onTap: () {
                print('Bookings tapped');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingsScreen(hospital: hospital),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Card 2: Medical Data
            CardOption(
              icon: Icons
                  .medication_liquid, // Icon for medical data (abstract molecule/data flow)
              text: 'البيانات الطبية', // Medical Data
              onTap: () {
                print('Medical Data tapped');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MedicalDataScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Card 3: Register Medical Data
            CardOption(
              icon: Icons
                  .edit_note, // Icon for registering medical data (document with pencil)
              text: 'تسجيل البيانات الطبية', // Register Medical Data
              onTap: () {
                print('Register Medical Data tapped');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterMedicalDataScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Widget for the option cards (same as used in EmployeeManagementScreen)
class CardOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const CardOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align content to the right
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
              const SizedBox(width: 15),
              Icon(icon, size: 35, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}
