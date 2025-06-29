// Date: 21st of Jun 2025

// importing
import 'package:flutter/material.dart';
import 'package:registrar_app/citizen/home_page.dart'; // HomePage()
import 'package:registrar_app/citizen/booking_page.dart'; // BookingPage()
import 'package:registrar_app/citizen/emergency_page.dart'; // EmergencyPage()
import 'package:registrar_app/citizen/notifications_page.dart'; // NotificationsPage()
import 'package:registrar_app/citizen/medical_advices.dart'; // MedicalAdvicesPage()

// importing for database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registrar_app/firebase_options.dart';
import 'package:registrar_app/regist/backend/registrar.dart';
import 'package:registrar_app/regist/registrar_home_page.dart';

// running the whole app here:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

  runApp(HealthCareSudan_citizen_app());
}

// app class
class HealthCareSudan_citizen_app extends StatelessWidget {
  HealthCareSudan_citizen_app({super.key});
  final Registrar registrar = Registrar("name", "al-sanousy",
      ["dentist", "brain", "bones"], "0128599405", "1234");

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: MaterialApp(
        home: RegistrarHomePage(
          registrar: registrar,
        ),
        routes: <String, WidgetBuilder>{
          'home': (context) => const HomePage(),
          'booking_page': (context) => const BookingPage(),
          'emergency_page': (context) =>
              const EmergencyPage(), //const EmergencyPage(),
          'notifications_page': (context) =>
              const NotificationsPage(), //const NotificationsPage(),
          'medical_advices': (context) =>
              const MedicalAdvicesPage(), //const MedicalAdvicesPage(),
        }, // routes
        // to hide the defualt debugging icon in the corner
        debugShowCheckedModeBanner: false,
// themes can be edited and added here
/*
        theme: ThemeData(
          fontFamily: 'Cairo', // تأكد من إضافة الخط إلى pubspec.yaml
          primaryColor: Color(0x3B82F6),
          scaffoldBackgroundColor: Color(0xFFF0F0F0),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.lightBlue, // 0xFF3888FF
            titleTextStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
*/
      ),
    );
  } // build
} // HealthCareSudan_citizen_app
