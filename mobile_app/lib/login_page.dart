// Date: 26th of Jun 2025

import 'package:flutter/material.dart';

import 'package:mobile_app/citizen/backend/citizens_data.dart';
import 'package:mobile_app/citizen/home_page.dart';
import 'package:mobile_app/regist/registrar_home_page.dart';
import 'package:mobile_app/signup_page.dart';
import 'package:mobile_app/styles.dart';
import 'package:mobile_app/regist/backend/registrar.dart';
import 'package:mobile_app/citizen/backend/validate_fields.dart';

// test the login page here
void main() {
  runApp(const LoginPageTest());
} // main

//
class LoginPageTest extends StatelessWidget {
  const LoginPageTest({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          Directionality(textDirection: TextDirection.rtl, child: LoginPage()),

//      routes: {      }, // no routes here because we will send registrar object to the next page

      debugShowCheckedModeBanner: false, // hide debugging icon in the corner
    );
  } // build fun
} //LoginPageTest

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  // this fun will validate the username and password and check if it's in citizens_data.dart
  //TODO: instead CitizensData use firebase to validate the login
  bool _citizenLogin() {
    if (_formKey.currentState!.validate()) {
      return CitizensData.isCitizenValid(
          _usernameController.text, _passwordController.text);
    } else {
      return false;
    }
  } // _login

  // this fun will validate the username and password and check if it's a registrar or not
  //check line 183
  //TODO: instead or currentRegistrar use firebase to validate the login
  bool _registrarLogin(Registrar reg) {
    if (_formKey.currentState!.validate()) {
      return (_usernameController.text == reg.name &&
          _passwordController.text == reg.password);

// Check the username and password in the database
      // Example:
      // if (_usernameController.text == 'admin' && _passwordController.text == 'password') {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Invalid credentials')),
      //   );
      // }
    } // if
    else {
      return false;
    }
  } // _login

  //build fun
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('تسجيل الدخول'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
// add Health Ministry Logo
                Image.asset(
                  'lib/assets/images/health_ministry_loge.jpg',
                  alignment: Alignment.center,
                  height: 200,
                  width: 200,
                ),
                // Icon(
                //   Icons.now_wallpaper,
                //   size: 200,
                // ),
                const SizedBox(height: 8),
                Text(
                  "وزارة الصحة الاتحادية",
                  style: TextStyle(fontSize: 28, color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المستخدم',
                    hintText: 'أدخل اسم المستخدم الخاص بك',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
// validate username here
                      return 'الرجاء إدخال اسم المستخدم الخاص بك';
                    } //if
                    else if (Validate.password(value)) {
                      return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل، حرف كبير، رقم ورمز';
                    }
                    return null;
                  }, // validattor
                ),

                const SizedBox(
                    height: 16.0), // space between username and password fields

                // Password Field
                TextFormField(
                  textDirection: TextDirection.ltr,
                  controller: _passwordController,
                  obscureText: _obscurePassword,

                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    hintText: 'أدخل كلمة المرور الخاصة بك',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور الخاصة بك'; // Translated
// validate the password
                    }
                    return null;
                  }, // validator
                ),

                const SizedBox(
                    height: 24.0), // space between password and the button

                // Login Button
                ElevatedButton(
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    foregroundColor: Colors.white, // text color
                    backgroundColor: Colors.lightBlue, // button color
                  ),
                  onPressed: () {
// checking login data
//                 _login();
// if you find him a registrar, then create a registrar object and assign its data
// read it from the database
                    // example
                    Registrar currentRegistrar = Registrar(
                      'Mohammed abdulsalam',
                      'alamal hospital',
                      ['العيون', 'الجلدية', 'الباطنية'],
                      '0912345678',
                      '123456@Registrar', // password
                    );
                    if (_citizenLogin()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            citizen: CitizensData.data.firstWhere((citizen) =>
                                citizen.citizenName ==
                                    _usernameController.text &&
                                citizen.password == _passwordController.text),
                          ), // send the citizen object to the citizen home page
                        ),
                      );
                    } else if (_registrarLogin(currentRegistrar)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrarHomePage(
                              registrar:
                                  currentRegistrar), // send the registrar object to the registrar home page
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'حدث خطأ. لم يتم تسجيل الدخول\n الرجاء التأكد من اسم المستخدم و كلمة المرور')));
                    }
                  },
                ),

                const SizedBox(
                    height: 16.0), // space between button and forget password

                // forgot password and create account
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text('هل نسيت كلمة المرور؟'),
                      onPressed: () {
// go forgot password page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('forget password pressed')),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('ليس لديك حساب؟ أنشئ واحدا'),
                      onPressed: () {
// (it will take him to create new citizen account)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } // build fun

  // use this fun to free username and password variables from RAM
/*
    @override
    void dispose() {
      _usernameController.dispose();
      _passwordController.dispose();
      super.dispose();
    }
*/
} //_LoginPageState
