import 'package:flutter/material.dart';
import 'package:pc_apps/ministry/flutter_main_screen.dart'; // Assuming your project name is my_health_app
import 'package:pc_apps/ministry/Backend/ministry_employee.dart';

// Make sure DashboardScreen is defined in flutter_main_screen.dart or import the correct file where DashboardScreen is defined.

// LoginScreen is a StatefulWidget to manage its internal state (text controllers).
class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key}); //Constructor

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
  void _performLogin(MinistryEmployee employee) {
    // In a real application, you would perform authentication here (e.g., API call).
    // For this example, we simply navigate to the DashboardScreen.


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(employee: employee)),
    );
    // Print the entered credentials to the console for demonstration purposes.
    print(
      'Phone: ${_phoneController.text}, Password: ${_passwordController.text}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Arabic lang
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.lightBlue,
        ),

        backgroundColor:
            Colors.white, // Sets the background color of the screen to white
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center, // Centers children vertically.
            children: <Widget>[
              Padding(

                padding: const EdgeInsets.all(16.0),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ministry Logo
                    Image.asset(
                      'assets/health_ministry_loge.jpg',
                      alignment: Alignment.center,
                      height: 200,
                      width: 200,
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
                    ),
                  ],
                ),
              ),
Row(
  children: [
    Expanded(child: SizedBox.shrink()),
    Expanded(child: Column( children: [const SizedBox(height: 40), // Vertical space
      // Phone Input Field
      TextFormField(
        controller: _phoneController, // Assigns the controller
        decoration: InputDecoration(
          hintText: 'أدخل رقم الهاتف', // Hint text
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200], // Light grey background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12.0,
            ), // Rounded corners
            borderSide: BorderSide.none, // No border line
          ),
        ),
        validator: (val) {
          if(val == "") return "الرجاء إدخال رقم الهاتف"; // empty phone field
          if (   // start with a wrong prefix
          !(
              val!.startsWith('01') ||
                  val.startsWith('090') ||
                  val.startsWith('091') ||
                  val.startsWith('092') ||
                  val.startsWith('096') ||
                  val.startsWith('099')
          )
          ) return "الرجاء إدخال رقم الهاتف الصحيح";
        },
        keyboardType: TextInputType.phone, // Sets keyboard type to phone
      ),
      const SizedBox(height: 20), // Vertical space
      // Password Input Field.
      TextFormField(
        controller: _passwordController, // Assigns the controller
        obscureText: true, // Hides the entered text (for passwords)
        decoration: InputDecoration(
          hintText: 'أدخل كلمة المرور',
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
      const SizedBox(height: 20),
      // Login Button - This button connects the two pages.
      ElevatedButton(

        onPressed: () {
          // Load Ministry Employee object here
          MinistryEmployee employee = MinistryEmployee(
              "محمد أحمد خالد",
              "0123456789",
              "123123",
              'الكل',
              "أمدرمان"

          );
          _performLogin(employee);
        }, // Calls _performLogin when pressed
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
      const SizedBox(height: 20), // Vertical spac
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Forgot Password and Create New Account links.
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

    ])),
    Expanded(child: SizedBox.shrink())
  ],
),
            ],
          ),
        )
          ),
    );

  }


}
