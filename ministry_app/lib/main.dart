import 'package:flutter/material.dart';
// Import the LoginScreen from its dedicated file
import 'package:ministry_app/flutter_login_screen.dart'; // Ensure this file defines and exports LoginScreen
// Import the DashboardScreen from its dedicated file
// Note: flutter_main_screen.dart now internally imports flutter_notification_screen.dart

/* all you need to deal with database here */
import 'package:firedart/firedart.dart'; // database package

const apiKey = 'AIzaSyDQG58nyruo1dhLWcoDz2vpM3wQHjRMu5c'; // api key
const projectId = 'health-sudan-app'; // project id

// The main function that starts the Flutter application.
void main() {
  Firestore.initialize(projectId);

  runApp(const MyApp());
}

// MyApp is the root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudan Health App', // Title of the application
      theme: ThemeData(
        primarySwatch:
            Colors.blue, // Defines the primary color swatch for the app
        fontFamily: 'Inter', // Specifies the default font family for the app
      ),
      home:
          LoginScreen(), // Sets the initial screen of the app to LoginScreen (remove const if LoginScreen is not a const constructor)
      debugShowCheckedModeBanner: false,
    );
  }
}
