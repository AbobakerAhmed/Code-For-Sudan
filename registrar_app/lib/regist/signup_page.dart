import 'package:flutter/material.dart';

import 'package:registrar_app/citizen/home_page.dart';
import 'package:registrar_app/citizen/backend/citizen.dart';
import 'package:registrar_app/citizen/backend/validate_fields.dart';
import 'package:registrar_app/citizen/backend/globalVar.dart';

import 'package:registrar_app/styles.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _phoneNumber;
  String? _gender;
  String? _password;
  String? _confirmPassword;

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

                _buildTextField(
                    // validate the name with range of characters
                    'اسم المستخدم',
                    (val) => _userName = val, validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'أدخل اسم المستخدم الخاص بك';
                  }
                  if (val.length < 4) return 'الاسم قصير جداً';
                  return null;
                }),

                // entering gender
                _buildDropdown(
                  label: 'النوع',
                  value: _gender,
                  items: g_gender,
                  onChanged: (val) {
                    setState(() {
                      _gender = val;
                    });
                  },
                ),

                // enter phone number
                _buildTextField(
                  'رقم الهاتف (مثال: 0123456789)',
                  // validate the number (10 digits, start only with 01, 099, 092, 090, 091, or 096)
                  (val) => _phoneNumber = val,
                  inputType: TextInputType.phone,
                  direction: TextDirection.ltr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاءإدخال رقم الهاتف';
                    } else if (!Validate.phoneNumber(value)) {
                      return 'رقم الهاتف غير صالح'; // Invalid phone number
                    }
                    return null;
                  },
                ),
                // Password Field
                _buildTextField(
                  'كلمة المرور',
                  (val) => _password = val,
                  direction: TextDirection.ltr,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'أدخل كلمة المرور';
                    }
                    if (!Validate.password(val)) {
                      return 'كلمة المرور يجب أن تكون على الأقل 8 أحرف';
                    }
                    return null;
                  },
                ),

                // Confirm Password Field
                _buildTextField(
                  'تأكيد كلمة المرور',
                  (val) => _confirmPassword = val,
                  direction: TextDirection.ltr,
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return 'أدخل تأكيد كلمة المرور';
                    if (val != _password) return 'كلمة المرور غير متطابقة';
                    return null;
                  },
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

  Widget _buildTextField(
    String label,
    Function(String) onChanged, {
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    TextDirection direction = TextDirection.rtl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        textDirection: direction,
        keyboardType: inputType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  } // _buildDropdown
}
