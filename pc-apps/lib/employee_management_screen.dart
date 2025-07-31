import 'package:flutter/material.dart';
import 'package:pc_apps/Backend/hospital.dart';
import 'package:pc_apps/employee_data_management_screen.dart';
import 'package:pc_apps/hospital_data_screen.dart';

class EmployeeManagementScreen extends StatelessWidget {
  Hospital hospital;

  EmployeeManagementScreen({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'إدارة الموظفين', // Employee Management
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            // Placeholder for the icon on the right of the title
            Icon(
              Icons.person_add, // Or a custom icon similar to the image
              size: 30,
              color: Colors.blue, // Adjust color as needed
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Line under the title
            Container(
              height: 1.0,
              color: Colors.grey[300],
              margin: const EdgeInsets.only(bottom: 20.0),
            ),
            _buildManagementOption(
              context,
              'إدارة بيانات الموظفين', // Manage Employee Data
              Icons.person,
              () {
                // Handle navigation to manage employee data
                print('Manage Employee Data tapped!');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmployeeDataManagementScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildManagementOption(
              context,
              'بيانات المستشفى', // Hospital Data
              Icons.local_hospital,
              () {
                // Handle navigation to hospital data
                print('Hospital Data tapped!');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HospitalDataScreen(hospital: hospital),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Align content to the right
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.blue, // Adjust color as needed
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// To run this code, you'd typically have it as part of a main.dart file
// or a larger Flutter project structure.
// Example of how to use it in main.dart:
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmployeeManagementScreen(),
    );
  }
}
*/
