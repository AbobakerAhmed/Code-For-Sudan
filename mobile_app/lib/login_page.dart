// Date: 26th of Jun 2025
import 'package:flutter/material.dart';
import 'package:mobile_app/backend/citizen/citizen.dart';
import 'package:mobile_app/backend/doctor/doctor.dart';
import 'package:mobile_app/backend/registrar/registrar.dart';

import 'package:mobile_app/citizen/home_page.dart';
import 'package:mobile_app/doctor/doctor_home_page.dart';
import 'package:mobile_app/regist/registrar_home_page.dart';
import 'package:mobile_app/signup_page.dart';

//import 'package:mobile_app/styles.dart';
import 'package:mobile_app/backend/validate_fields.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

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
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  bool _citizenFoundInDb = false;
  bool _registrarFoundInDb = false;
  bool _doctorFoundInDb = false;
  bool _correctCitizenPassword = false;
  bool _correctRegistrarPassword = false;
  bool _correctDoctorPassword = false;

  /// this method will validate the username and password and check if it's in citizens_data.dart
  Future<void> _checkCitizenLogin() async {
    if (_formKey.currentState!.validate()) {
      final (bool, bool) foundAndCorrectPassword = await _firestoreService
          .searchCitizen(_phoneNumberController.text, _passwordController.text);
      setState(() {
        _citizenFoundInDb = foundAndCorrectPassword.$1;
        _correctCitizenPassword = foundAndCorrectPassword.$2;
      });
    }
  } // _checkCitizenLogin

  /// this method will validate the username and password and check if it's a registrar or not
  Future<void> _checkRegistrarLogin() async {
    if (_formKey.currentState!.validate()) {
      final (bool, bool) foundAndCorrectPassword =
          await _firestoreService.searchRegistrar(
              _phoneNumberController.text, _passwordController.text);
      setState(() {
        _registrarFoundInDb = foundAndCorrectPassword.$1;
        _correctRegistrarPassword = foundAndCorrectPassword.$2;
      });
    }
  } // _checkRegistrarLogin

  /// this method will validate the username and password and check if it's a doctor or not
  Future<void> _checkDoctorLogin() async {
    if (_formKey.currentState!.validate()) {
      final (bool, bool) foundAndCorrectPassword = await _firestoreService
          .searchDoctor(_phoneNumberController.text, _passwordController.text);
      setState(() {
        _doctorFoundInDb = foundAndCorrectPassword.$1;
        _correctDoctorPassword = foundAndCorrectPassword.$2;
      });
    }
  } // _checkDoctorLogin

  //build fun
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(title: Text('تسجيل الدخول')),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Guest Mode Button - top right under AppBar
            // Guest Mode Button - top right under AppBar
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      textStyle: const TextStyle(fontSize: 12),
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Material(
                              type: MaterialType.transparency,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            );
                          });

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text('وضع الضيف'),
                  ),
                ],
              ),
            ),

            // The rest of your original content
            Expanded(
              child: Center(
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
                          'lib/assets/images/final_health_ministry_loge.jpg',
                          alignment: Alignment.center,
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "وزارة الصحة الاتحادية",
                          style: TextStyle(
                              fontSize: 28,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),

                        // Username Field
                        TextFormField(
                          controller: _phoneNumberController,
                          cursorColor: Theme.of(context).secondaryHeaderColor,
                          decoration: InputDecoration(
                            labelText: 'رقم الهاتف',
                            labelStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                            hintText: 'أدخل رقم الهاتف الخاص بك',
                            hintStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
                            prefixIcon: const Icon(Icons.phone),
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
                        ),

                        const SizedBox(
                            height:
                                16.0), // space between username and password fields

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          cursorColor: Theme.of(context).secondaryHeaderColor,

                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            labelStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                            hintText: 'أدخل كلمة المرور الخاصة بك',
                            hintStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
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
                            } else if (!Validate.password(value)) {
                              return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل، حرف كبير، رقم ورمز';
                            } else {
                              return null;
                            }
                          }, // validator
                        ),

                        SizedBox(height: 16),

                        // Login Button
                        ElevatedButton(
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              foregroundColor: Colors.white, // text color
                              backgroundColor:
                                  Theme.of(context).primaryColor // button color
                              ),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Material(
                                    type: MaterialType.transparency,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          Text("كيف حالك"),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
// checking login data
//                 _login();
// if you find him a registrar, then create a registrar object and assign its data
// read it from the database
                            // example
                            await _checkCitizenLogin();
                            await _checkRegistrarLogin();
                            await _checkDoctorLogin();

                            if (_citizenFoundInDb && _correctCitizenPassword) {
                              _registrarFoundInDb = false;
                              _citizenFoundInDb = false;
                              _doctorFoundInDb = false;
                              _correctCitizenPassword = false;
                              _correctRegistrarPassword = false;
                              _correctDoctorPassword = false;
                              Citizen currentCitizen =
                                  await _firestoreService.getCitizen(
                                      _phoneNumberController.text,
                                      _passwordController.text);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      citizen:
                                          currentCitizen), // send the citizen object to the citizen home page
                                ),
                              );
                            } else if (_registrarFoundInDb &&
                                _correctRegistrarPassword) {
                              _registrarFoundInDb = false;
                              _citizenFoundInDb = false;
                              _doctorFoundInDb = false;
                              _correctCitizenPassword = false;
                              _correctRegistrarPassword = false;
                              _correctDoctorPassword = false;
                              Registrar currentRegistrar =
                                  await _firestoreService.getRegistrar(
                                      _phoneNumberController.text,
                                      _passwordController.text);
                              await currentRegistrar.fetchDepartments();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrarHomePage(
                                      registrar:
                                          currentRegistrar), // send the registrar object to the registrar home page
                                ),
                              );
                            } else if (_doctorFoundInDb &&
                                _correctDoctorPassword) {
                              _registrarFoundInDb = false;
                              _citizenFoundInDb = false;
                              _doctorFoundInDb = false;
                              _correctCitizenPassword = false;
                              _correctRegistrarPassword = false;
                              _correctDoctorPassword = false;

                              Doctor currentDoctor =
                                  await _firestoreService.getDoctor(
                                      _phoneNumberController.text,
                                      _passwordController.text);
                              await currentDoctor.fetchDepartment();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DoctorHomePage(doctor: currentDoctor)),
                              );
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'حدث خطأ. لم يتم تسجيل الدخول\n الرجاء التأكد من اسم المستخدم و كلمة المرور'),
                              ));
                            }
                          },
                        ),

                        const SizedBox(
                            height:
                                24.0), // space between password and the button

                        const SizedBox(
                            height:
                                16.0), // space between button and forget password

                        // forgot password and create account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: Text(
                                'هل نسيت كلمة المرور؟',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              onPressed: () {
                                // go forgot password page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('هذه الميزة غير متاحة حالياً')),
                                );
                              },
                            ),
                            TextButton(
                              child: Text(
                                'ليس لديك حساب؟ أنشئ واحداً',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
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
            ),
          ]),
        ));
  } // build fun
} //_LoginPageState
