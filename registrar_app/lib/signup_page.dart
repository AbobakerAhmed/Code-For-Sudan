import 'package:flutter/material.dart';
import 'package:registrar_app/citizen/backend/citizen.dart';

import 'package:registrar_app/citizen/home_page.dart';
import 'package:registrar_app/citizen/backend/validate_fields.dart';
import 'package:registrar_app/citizen/backend/global_var.dart';

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
  String? _address;
  DateTime? _birthDate;
  String? _password;
  String? _confirmPassword;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
            child: ListView(
              children: [
                const SizedBox(height: 40),
                const Text('سجل حساب جديد', style: titleTextStyle),
                const SizedBox(height: 30),
                _buildTextField(
                  'اسم المستخدم',
                  _nameController,
                  (val) => _userName = val,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'أدخل اسم المستخدم الخاص بك';
                    }
                    return null;
                  },
                ),
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
                _buildDatePickerField(),
                _buildTextField(
                  'رقم الهاتف (مثال: 0123456789)',
                  _phoneController,
                  (val) => _phoneNumber = val,
                  inputType: TextInputType.phone,
                  direction: TextDirection.ltr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    } else if (!Validate.phoneNumber(value)) {
                      return 'رقم الهاتف غير صالح';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'ادخل الحي - المربع (مثال: الواحة - 4)',
                  direction: TextDirection.rtl,
                  _addressController,
                  (val) => _address = val,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'العنوان مطلوب';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'كلمة المرور',
                  _passwordController,
                  (val) => _password = val,
                  direction: TextDirection.ltr,
                  obscureText: _obscurePassword,
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
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'أدخل كلمة المرور';
                    }
                    if (!Validate.password(val)) {
                      return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل، حرف كبير، رقم ورمز';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'تأكيد كلمة المرور',
                  _confirmPasswordController,
                  (val) => _confirmPassword = val,
                  direction: TextDirection.ltr,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return 'أدخل تأكيد كلمة المرور';
                    if (val != _password) return 'كلمة المرور غير متطابقة';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: handle signup to firebase
                        // //save info in database
                        // _firestoreService.createCitizen(Citizen(
                        //     _userName!,
                        //     _phoneNumber!,
                        //     _password!,
                        //     _gender!,
                        //     _address!,
                        //     _birthDate!,
                        //     ['None']));

                        // // clear fields
                        // setState(() {
                        //   _nameController.clear();
                        //   _phoneController.clear();
                        //   _gender = null;
                        //   _addressController.clear();
                        //   _birthDate = null;
                        //   _passwordController.clear();
                        //   _confirmPasswordController.clear();
                        // });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
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
    TextEditingController controller,
    Function(String) onChanged, {
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    TextDirection direction = TextDirection.rtl,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        textDirection: direction,
        keyboardType: inputType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: suffixIcon,
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
  }

  Widget _buildDatePickerField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final selected = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (selected != null) {
            setState(() {
              _birthDate = selected;
            });
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'تاريخ الميلاد',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          child: Text(
            _birthDate != null
                ? '${_birthDate!.year}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.day.toString().padLeft(2, '0')}'
                : 'اختر تاريخ الميلاد',
            style: TextStyle(
              color: _birthDate != null ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
