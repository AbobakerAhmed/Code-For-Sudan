import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:ministry_app/Backend/validate_fields.dart';
import 'package:ministry_app/flutter_main_screen.dart'; // Assuming your project name is my_health_app
import 'package:ministry_app/Backend/ministry_employee.dart';
import 'package:ministry_app/firestore_services/firedart.dart';

/**
Issues:
    1- registrartion dialog box is not working
    2- edit forget password dialog
    3- link with database to find the ministry employee
    4- perform login logic
 */

/**
 *     MinistryEmployee employee = MinistryEmployee(
        "محمد أحمد خالد",
        "0123456789",
        "123123",
        'الخرطوم',
        "الكل"
    );
 */

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

  // A GlobalKey for the Form widget to manage its state and perform validation.
  final _formKey = GlobalKey<FormState>();

  // Instance of the Firestore service
  final _firestoreService = FirestoreService();

  // State variable to manage the loading indicator
  bool _isLoading = false;

  // State variable to toggle password visibility
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    // to prevent memory leaks.
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle the login logic.
  void _performLogin() async {
    // Validate the form. If the inputs are not valid, do not proceed.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final phone = _phoneController.text;
      final password = _passwordController.text;

      // Use the service to check credentials
      final (found, correctPassword) = await _firestoreService
          .checkMinistryLogin(phone, password);

      if (!found) {
        _showErrorSnackBar('رقم الهاتف غير مسجل');
      } else if (!correctPassword) {
        _showErrorSnackBar('كلمة المرور غير صحيحة');
      } else {
        // Login successful, fetch the full employee object to navigate
        final employee = await _firestoreService.getMinistryEmployee(phone);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(employee: employee),
            ),
          );
        }
      }
    } catch (e) {
      _showErrorSnackBar(
        'حدث خطأ أثناء تسجيل الدخول. الرجاء المحاولة مرة أخرى.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl),
        backgroundColor: Colors.red,
      ),
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
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Center children horizontally
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
                        // Constrain the width of the form elements to be more compact.
                        SizedBox(
                          width: 550, // You can adjust this width as needed.
                          child: Column(
                            children: [
                              const SizedBox(height: 40), // Vertical space
                              // Phone Input Field
                              TextFormField(
                                textDirection: TextDirection.ltr,
                                controller:
                                    _phoneController, // Assigns the controller
                                decoration: InputDecoration(
                                  hintText: 'أدخل رقم الهاتف', // Hint text
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor:
                                      Colors.grey[200], // Light grey background
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      12.0,
                                    ), // Rounded corners
                                    borderSide:
                                        BorderSide.none, // No border line
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    // validate username here
                                    return 'الرجاء إدخال رقم الهاتف الخاص بك';
                                  } //if
                                  else if (!Validate.phoneNumber(value)) {
                                    return 'رقم هاتف غير صحيح ادخل رقم الهاتف يبتدئ ب09 او 01 (مثال: 0123456789)';
                                  }
                                  return null;
                                }, // validattor
                                keyboardType: TextInputType
                                    .phone, // Sets keyboard type to phone
                              ),
                              const SizedBox(height: 20), // Vertical space
                              // Password Input Field.
                              TextFormField(
                                textDirection: TextDirection.ltr,
                                controller:
                                    _passwordController, // Assigns the controller
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  hintText: 'أدخل كلمة المرور',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor:
                                      Colors.grey[200], // Light grey background
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      12.0,
                                    ), // Rounded corners
                                    borderSide:
                                        BorderSide.none, // No border line
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 20.0,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال كلمة المرور';
                                  }
                                  // Password format validation is not needed on login.
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Login Button - Wrapped to fill the constrained width.
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _performLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blue, // Button background color
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
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Text(
                                          'تسجيل الدخول', // Login (Arabic)
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ), // Text style
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20), // Vertical spac
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Forgot Password and Create New Account links.
                                  TextButton(
                                    onPressed: () {
                                      // Handle 'Create new account' tap
                                      print('Create new account tapped');
                                    },
                                    child: const Text(
                                      'انشاء حساب جديد', // Create new account (Arabic)
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
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
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
