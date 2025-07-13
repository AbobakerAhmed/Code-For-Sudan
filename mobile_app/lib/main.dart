import 'package:flutter/material.dart';

// importing for database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:mobile_app/backend/citizen/citizens_data.dart';
import 'package:mobile_app/firebase_options.dart';
//import login page
import 'package:mobile_app/login_page.dart';

//import citizens page (can be deleted later)
//import 'package:mobile_app/citizen/home_page.dart';
import 'package:mobile_app/citizen/booking_page.dart';
import 'package:mobile_app/citizen/emergency_page.dart';
import 'package:mobile_app/citizen/medical_advices.dart';
import 'package:mobile_app/citizen/test_appointments.dart';

// import provider to control all the app theme at once
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Import your theme provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: HealthCareSudan()));
}

class HealthCareSudan extends StatelessWidget {
  // final bool isConnected;
  const HealthCareSudan({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
            home: const LoginPage(),
            routes: {
              // 'home': (context) => HomePage(
              //       citizen: CitizensData.data[0],
              //     ),
              'booking_page': (context) => const BookingPage(),
              'emergency_page': (context) => const EmergencyPage(),
              'notifications_page': (context) => AppointmentTestScreen(),
              'medical_advices': (context) => const MedicalAdvicesPage(),
            },
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
          ),
        );
      },
    );
  }
}
