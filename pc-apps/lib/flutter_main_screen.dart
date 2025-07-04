import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudan Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter', // Assuming Inter font, or default if not available
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _performLogin() {
    // In a real app, you would validate credentials here.
    // For this example, we'll just navigate to the dashboard.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
    print(
      'Phone: ${_phoneController.text}, Password: ${_passwordController.text}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Assuming a white background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo and Ministry Text
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
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Placeholder for the logo. In a real app, you'd use Image.asset('assets/logo.png')
                    // Make sure to add your image to the pubspec.yaml under assets.
                    // For now, using a simple icon as a visual representation.
                    const Icon(
                      Icons
                          .medical_services, // Using a generic medical icon as a placeholder
                      size: 80,
                      color: Colors.green, // Example color
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'جمهورية السودان', // Republic of Sudan
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      textDirection:
                          TextDirection.rtl, // Right-to-left for Arabic
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'وزارة الصحة الاتحادية', // Federal Ministry of Health
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      textDirection:
                          TextDirection.rtl, // Right-to-left for Arabic
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Phone Number Input
              Directionality(
                textDirection: TextDirection
                    .rtl, // Set text direction for this input field
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'رقم الهاتف...', // Phone number...
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
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 20),

              // Password Input
              Directionality(
                textDirection: TextDirection
                    .rtl, // Set text direction for this input field
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hide password
                  decoration: InputDecoration(
                    hintText: 'كلمة المرور...', // Password...
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
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: _performLogin,
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
                  'تسجيل الدخول', // Login
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Forgot Password and Create New Account links
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Handle 'Create new account' tap
                        print('Create new account tapped');
                      },
                      child: const Text(
                        'انشاء حساب جديد', // Create new account
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
                        'نسيت كلمة المرور؟', // Forgot password?
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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              print('Settings tapped');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              print('Profile tapped');
            },
          ),
          const SizedBox(width: 16),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for the logo.
                const Icon(
                  Icons.medical_services,
                  size: 24,
                  color: Colors.green,
                ),
                const Text(
                  'جمهورية السودان',
                  style: TextStyle(fontSize: 8, color: Colors.black87),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const Text(
                  'وزارة الصحة الاتحادية',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 150, // Adjust this based on logo size
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 24.0,
          mainAxisSpacing: 24.0,
          children: <Widget>[
            _buildDashboardCard(
              context,
              icon: Icons.description,
              text: 'التقارير', // Reports
              onTap: () {
                print('Reports tapped');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.add_circle,
              text: 'اضافة مستشفى', // Add Hospital
              onTap: () {
                print('Add Hospital tapped');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.notifications_active,
              text: 'الاشعارات', // Notifications
              onTap: () {
                print('Notifications tapped');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.send,
              text: 'ارسال الاشعارات', // Send Notifications
              onTap: () {
                print('Send Notifications tapped');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.blue, // Example color for icons
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
