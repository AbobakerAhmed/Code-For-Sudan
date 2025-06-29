// Date: 21st of Jun 2025

// importing
import 'package:flutter/material.dart';
// import 'package:registrar_app/citizen/home_page.dart'; // HomePage()
// import 'package:registrar_app/citizen/booking_page.dart'; // BookingPage()
// import 'package:registrar_app/citizen/emergency_page.dart'; // EmergencyPage()
// import 'package:registrar_app/citizen/notifications_page.dart'; // NotificationsPage()
// import 'package:registrar_app/citizen/medical_advices.dart'; // MedicalAdvicesPage()

// importing for database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registrar_app/firebase_options.dart';
// import 'package:registrar_app/regist/backend/registrar.dart';
// import 'package:registrar_app/regist/registrar_home_page.dart';
import 'registrar_login_page.dart';

// running the registrar pages here:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

  runApp(HealthCareSudan_registrar_app());
}

// app class
class HealthCareSudan_registrar_app extends StatelessWidget {
  HealthCareSudan_registrar_app({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: MaterialApp(
        home: LoginPage(),

        // to hide the defualt debugging icon in the corner
        debugShowCheckedModeBanner: false,
      ),
    );
  } // build
} // HealthCareSudan_registrar_app
