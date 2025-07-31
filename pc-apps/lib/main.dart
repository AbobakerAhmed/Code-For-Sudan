import 'package:flutter/material.dart';
import 'package:pc_apps/login_screen.dart';

void main(){
  runApp(HospitalManagerApp());
}

class HospitalManagerApp extends StatelessWidget{
  const HospitalManagerApp();
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
} // HospitalManagerApp