import 'package:flutter/material.dart';
import 'package:pc_apps/ministry/main_screen.dart'; // Assuming your project name is my_health_app
// Make sure DashboardScreen is defined in flutter_main_screen.dart or import the correct file where DashboardScreen is defined.

// LoginScreen is a StatefulWidget to manage its internal state (text controllers).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// The state class for LoginScreen.
class _LoginScreenState extends State<LoginScreen> {
  // Controllers for the phone number and password input fields.
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    // to prevent memory leaks.
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle the login logic.
  void _performLogin() {
    // In a real application, you would perform authentication here (e.g., API call).
    // For this example, we simply navigate to the DashboardScreen.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
    // Print the entered credentials to the console for demonstration purposes.
    print(
      'Phone: ${_phoneController.text}, Password: ${_passwordController.text}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Sets the background color of the screen to white
      body: Center(
        // Centers the content on the screen.
        child: SingleChildScrollView(
          // Allows the content to be scrollable if it overflows the screen.
          padding: const EdgeInsets.all(
            24.0,
          ), // Adds padding around the content.
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers children vertically.
            children: <Widget>[
              // Logo and Ministry Text Section.
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Background color for the logo container
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ), // Rounded corners for the container
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(
                        0.2,
                      ), // Shadow color with opacity
                      spreadRadius: 2, // Extends the shadow
                      blurRadius: 5, // Blurs the shadow
                      offset: const Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Placeholder for the logo. Replace with Image.asset('assets/logo.png') in a real app.
                    const Icon(
                      Icons
                          .medical_services, // Using a generic medical icon as a placeholder
                      size: 80, // Size of the icon
                      color: Colors.green, // Color of the icon
                    ),
                    const SizedBox(height: 16), // Vertical space
                    const Text(
                      'جمهورية السودان', // Republic of Sudan (Arabic)
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection
                          .rtl, // Right-to-left text direction for Arabic
                    ),
                    const SizedBox(height: 8), // Vertical space
                    const Text(
                      'وزارة الصحة الاتحادية', // Federal Ministry of Health (Arabic)
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection
                          .rtl, // Right-to-left text direction for Arabic
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40), // Vertical space
              // Phone Number Input Field.
              Directionality(
                textDirection: TextDirection
                    .rtl, // Sets text direction for the input field
                child: TextFormField(
                  controller: _phoneController, // Assigns the controller
                  decoration: InputDecoration(
                    hintText:
                        'رقم الهاتف...', // Hint text (Arabic: Phone number...)
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200], // Light grey background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ), // Rounded corners
                      borderSide: BorderSide.none, // No border line
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                  ),
                  keyboardType:
                      TextInputType.phone, // Sets keyboard type to phone
                ),
              ),
              const SizedBox(height: 20), // Vertical space
              // Password Input Field.
              Directionality(
                textDirection: TextDirection
                    .rtl, // Sets text direction for the input field
                child: TextFormField(
                  controller: _passwordController, // Assigns the controller
                  obscureText: true, // Hides the entered text (for passwords)
                  decoration: InputDecoration(
                    hintText:
                        'كلمة المرور...', // Hint text (Arabic: Password...)
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200], // Light grey background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ), // Rounded corners
                      borderSide: BorderSide.none, // No border line
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Vertical space
              // Login Button - This button connects the two pages.
              ElevatedButton(
                onPressed: _performLogin, // Calls _performLogin when pressed
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 40.0,
                  ),
                ),
                child: const Text(
                  'تسجيل الدخول', // Login (Arabic)
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ), // Text style
                ),
              ),
              const SizedBox(height: 20), // Vertical space
              // Forgot Password and Create New Account links.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Distributes children evenly
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Handle 'Create new account' tap
                        print('Create new account tapped');
                      },
                      child: const Text(
                        'انشاء حساب جديد', // Create new account (Arabic)
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle 'Forgot password' tap
                        print('Forgot password tapped');
                      },
                      child: const Text(
                        'نسيت كلمة المرور؟', // Forgot password? (Arabic)
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
