// import basic ui components
import 'package:flutter/material.dart';

// import backend files
import 'package:mobile_app/backend/citizen/citizen.dart';
import 'package:mobile_app/citizen/home_page.dart';
import 'package:mobile_app/backend/validate_fields.dart';
import 'package:mobile_app/backend/global_var.dart';
import 'package:mobile_app/firestore_services/firestore.dart';
import 'package:mobile_app/styles.dart';

// base class
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

// class
class _SignupPageState extends State<SignupPage> {
  final FirestoreService _firestoreService =
      FirestoreService(); // define the database objcet

  // define variables
  List<String> _dbStates = [];
  List<String> _dbLocalities = [];
  bool _alreadySignedUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _phoneNumber;
  String? _gender;
  String? _state;
  String? _locality;
  String? _address;
  DateTime? _birthDate;
  String? _password;
  // ignore: unused_field
  String? _confirmPassword;

  // text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  /// fun: get states from databse
  Future<void> _getStates() async {
    try {
      final statesAndLocalities =
          await _firestoreService.getStatesAndLocalities();
      final states = statesAndLocalities.keys.toList();
      setState(() {
        _dbStates = states;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  /// fun: get localities from databse
  Future<void> _getLocalities(String state) async {
    try {
      final statesAndLocalities =
          await _firestoreService.getStatesAndLocalities();
      final localities = statesAndLocalities[state];
      setState(() {
        _dbLocalities = localities!;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  /// fun: check if citizen already existed in database
  Future<void> _checkCitizens() async {
    if (_formKey.currentState!.validate()) {
      final (bool, bool) foundAndCorrectPassword = await _firestoreService
          .searchCitizen(_phoneController.text, _passwordController.text);
      setState(() {
        _alreadySignedUp = foundAndCorrectPassword.$1;
      });
    }
  } // _login

  // initialize the widgets state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStates();
  }

  // build the app
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

                // username
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

                // gender
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

                // birth date
                _buildDatePickerField(),

                // phone
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

                // state
                _buildDropdown(
                  label: 'الولاية',
                  value: _state,
                  items: _dbStates,
                  onChanged: (val) {
                    setState(() {
                      _state = val;
                      _dbLocalities = [];
                      _getLocalities(_state!);
                    });
                  },
                ),

                // selection a locality depending on the state
                _buildDropdown(
                  label: 'المحلية',
                  value: _locality,
                  items: _dbLocalities,
                  onChanged: (val) {
                    setState(() {
                      _locality = val;
                    });
                  },
                ),

                // address
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

                // password
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

                // confirm password
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
                    if (val == null || val.isEmpty) {
                      return 'أدخل تأكيد كلمة المرور';
                    }
                    if (val != _password) return 'كلمة المرور غير متطابقة';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // press button sign up
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _checkCitizens();
                        if (_gender == null ||
                            _birthDate == null ||
                            _state == null ||
                            _locality == null ||
                            _addressController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('الرجاء تعبئة جميع الحقول المطلوبة')),
                          );
                          return;
                        } else if (!_alreadySignedUp) {
                          _alreadySignedUp = false;
                          // Create a new citizen
                          Citizen citizen = Citizen(
                            _userName!,
                            _phoneNumber!,
                            _password!,
                            _gender!,
                            _birthDate!,
                            ['None'],
                            _state!,
                            _locality!,
                            _address!,
                          );

                          _firestoreService.createCitizen(citizen);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(citizen: citizen)),
                          );

                          // clear fields
                          setState(() {
                            _nameController.clear();
                            _phoneController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                            _gender = null;
                            _birthDate = null;
                            _state = null;
                            _locality = null;
                            _addressController.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'رقم الهاتف هذا موجود بالفعل الرجاء ادخال رقم آخر')));
                          return;
                        }
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

  // custom text field
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

  // custom dropdown
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

  // custom date picker
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
