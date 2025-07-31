import 'package:flutter/material.dart';
// import 'package:firedart/firedart.dart'; /*(use only this package to connect with database)!*/

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  /// example test for connecting with database
  /*
  CollectionReference advices = Firestore.instance.collection(
    "medical_advices",
  );
  */

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
            Navigator.pop(context); // Go back to the previous screen (Dashboard)
          },
        ),
        title: const Directionality(
          textDirection: TextDirection.rtl, // Right-to-left for Arabic title
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Icon(Icons.settings, color: Colors.blue, size: 28), // Settings icon
              SizedBox(width: 8),
              Text(
                'الاعدادات', // Settings (Arabic)
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'هذه الميزة لا تعمل حاليا', // Reports (Arabic)
              style: TextStyle(fontSize: 24, color: Colors.grey[400], fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
