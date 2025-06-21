// Date: 21st of Jun 2025

// importing
import 'package:flutter/material.dart';
import 'home_page.dart'; // HomePage()
import 'booking_page.dart'; // BookingPage()
import 'emergency_page.dart'; // EmergencyPage()
import 'notifications_page.dart'; // NotificationsPage()
import 'medical_advices.dart'; // MedicalAdvicesPage()

// running the whole app here:
void main() {
  runApp(HealthCareSudan_citizen_app());
}

// app class
class HealthCareSudan_citizen_app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: MaterialApp(
        home: HomePage(),
        routes: <String, WidgetBuilder>{
          'home': (context) => HomePage(),
          'booking_page': (context) => BookingPage(),
          'emergency_page': (context) => EmergencyPage(),
          'notifications_page': (context) => NotificationsPage(),
          'medical_advices': (context) => MedicalAdvicesPage(),
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



