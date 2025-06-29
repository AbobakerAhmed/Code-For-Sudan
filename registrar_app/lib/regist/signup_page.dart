import 'package:flutter/material.dart';
import 'package:registrar_app/citizen/home_page.dart';
import 'package:registrar_app/styles.dart';
import 'backend/registrar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: appBar('إنشاء حساب جديد'),
        body: Padding(
          padding: defaultPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text('سجل حساب جديد', style: titleTextStyle),
                const SizedBox(height: 30),

                // Email Field
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'اسم المستخدم',
                    border:
                        OutlineInputBorder(borderRadius: defaultBorderRadius),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    filled: true,
                    fillColor: Color(0xFFF7F7F7),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'أدخل اسم المستخدم الخاص بك';
                    }
                    return null;
                  },
                  onChanged: (value) => _userName = value,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'كلمة المرور',
                    border:
                        OutlineInputBorder(borderRadius: defaultBorderRadius),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    filled: true,
                    fillColor: Color(0xFFF7F7F7),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'كلمة المرور يجب أن تكون على الأقل 8 أحرف';
                    }
                    return null;
                  },
                  onChanged: (value) => _password = value,
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'تأكيد كلمة المرور',
                    border:
                        OutlineInputBorder(borderRadius: defaultBorderRadius),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    filled: true,
                    fillColor: Color(0xFFF7F7F7),
                  ),
                  validator: (value) {
                    if (value != _password) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                  onChanged: (value) => _confirmPassword = value,
                ),
                const SizedBox(height: 20),

                // Signup Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Handle Firebase signup here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      }
                    },
                    child: const Text('إنشاء حساب'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
