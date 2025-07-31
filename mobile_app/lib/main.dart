// import basic ui components
import 'package:flutter/material.dart';

// import for database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_app/firebase_options.dart';
import 'package:mobile_app/citizen/booking_page.dart';
import 'package:mobile_app/citizen/notifications_page.dart';
import 'package:mobile_app/citizen/emergency_page.dart';
import 'package:mobile_app/citizen/medical_advices.dart';
import 'package:mobile_app/login_page.dart';

// import provider to control all the app theme
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Import your theme provider

void main() async {
  // initialize the database setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: HealthCareSudan()));
}

class HealthCareSudan extends StatelessWidget {
  const HealthCareSudan({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
            home: LoginPage(),
            routes: {
              'booking_page': (context) => BookingPage(),
              'emergency_page': (context) => EmergencyPage(),
              'notifications_page': (context) => NotificationsPage(),
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
