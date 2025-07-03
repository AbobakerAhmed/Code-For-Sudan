import 'package:flutter/material.dart';

// importing for database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_app/firebase_options.dart';
//import login page
import 'package:mobile_app/login_page.dart';

//import citizens page (can be deleted later)
import 'package:mobile_app/citizen/home_page.dart';
import 'package:mobile_app/citizen/booking_page.dart';
import 'package:mobile_app/citizen/emergency_page.dart';
import 'package:mobile_app/citizen/medical_advices.dart';
import 'package:mobile_app/citizen/test_appointments.dart';

//current login data
// Registrar(
//   'Mohammed abdulsalam',
//   'alamal hospital',
//   ['العيون', 'الجلدية', 'الباطنية'],
//   '0912345678',
//   '123456@Registrar', // password
// );

//the data for citizens are in citizen-->backend-->citizens_data
//they are temporary data until we connect the database to login and signup successfully

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

  runApp(HealthCareSudan());
}

class HealthCareSudan extends StatelessWidget {
  // final bool isConnected;
  const HealthCareSudan({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        home: const LoginPage(),
        routes: {
          'home': (context) => const HomePage(),
          'booking_page': (context) => const BookingPage(),
          'emergency_page': (context) => const EmergencyPage(),
          'notifications_page': (context) => AppointmentTestScreen(),
          'medical_advices': (context) => const MedicalAdvicesPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
