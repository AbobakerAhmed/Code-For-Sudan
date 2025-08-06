/* Date: 26th of Jun 2025 */

// import basic ui components
import 'package:flutter/material.dart';

// import backend files
import 'package:mobile_app/backend/registrar/registrar.dart';
import 'package:mobile_app/backend/validate_fields.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

// base class
class RegistrarProfilePage extends StatefulWidget {
  final Registrar registrar;

  RegistrarProfilePage({super.key, required this.registrar});

  @override
  State<RegistrarProfilePage> createState() => _RegistrarProfilePageState();
} //RegistrarProfilePage

// class
class _RegistrarProfilePageState extends State<RegistrarProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();

  // this fun initalize the page
  @override
  void initState() {
    super.initState();
  }

  // build the app
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: Scaffold(
        appBar: AppBar(
          title: Text('الملف الشخصي'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).primaryColorLight,
                radius: 50,
                child: Text(
                  widget.registrar.name.substring(0, 2).toUpperCase(),
                  style: TextStyle(fontSize: 50),
                ), // adding image or icon or anything
              ),
              const SizedBox(height: 16), // between image and the name

              // registrar name
              Text(
                widget.registrar.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10), // vertical space

              // phone number
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('رقم الهاتف'),
                subtitle: Text(widget.registrar.phoneNumber),
              ),

              // hsopital
              ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('المستشفى'),
                subtitle: Text(widget.registrar.hospitalName),
              ),

              // departments
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('الأقسام المسؤولة عنها'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.registrar.departmentsNames
                      .map((dep) => Text('• $dep'))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24), // vertical space

              // eidting button
              ElevatedButton.icon(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                label: Text(
                  'تعديل البيانات',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await _showEditDialog(context, widget.registrar);
                  setState(() {});

/***  edit the registrar data (only name, phone number, password) ***/
                },
              ),
            ],
          ),
        ),
      ),
    );
  } // build fun

  /// fun: this is the dialog for editing the registrar data
  Future<void> _showEditDialog(
      BuildContext context, Registrar currentRegistrar) async {
    final _formKey = GlobalKey<FormState>(); // global key

    // that will be pobed up only when pressing the button
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Theme.of(context).primaryColorLight,
              title: Text(
                "تعديل بيانات المسجل",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // edit the name
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentRegistrar.name,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                          labelText: 'الاسم',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        validator: (value) {
                          // validate the name here
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الاسم';
                          }
                          return null;
                        },
                        onChanged: (value) => currentRegistrar.name = value,
                      ),

                      const SizedBox(height: 10), // vertical space

                      // enter phone number
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentRegistrar.phoneNumber,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                            labelText: 'رقم الهاتف',
                            labelStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                            floatingLabelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            )),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value != null) {
                            if (!Validate.phoneNumber(value)) {
                              return 'رقم الهاتف غير صالح'; // Invalid phone number
                            }
                            return null;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) =>
                            currentRegistrar.phoneNumber = value,
                      ),

                      const SizedBox(height: 10), // vertical space

                      // enter password
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentRegistrar.password,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            labelStyle: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                            floatingLabelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ))),
                        validator: (value) {
                          if (value != null) {
                            if (!Validate.password(value)) {
                              return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل، حرف كبير، رقم ورمز';
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        }, // validator
                        // encode it
                        onChanged: (value) => currentRegistrar.password = value,
                      ),

                      const SizedBox(height: 10), // vertical space
                    ],
                  ),
                ),
              ),
              actions: [
                // cancel
                TextButton(
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                // connect to the database here to update the registrar info
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(
                    'تحديث',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final updatedData = {
                        'name': currentRegistrar.name,
                        'phoneNumber': currentRegistrar.phoneNumber,
                        'password': currentRegistrar.password,
                      };

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
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });

                      await _firestoreService.updateRegistrar(
                          widget.registrar.phoneNumber, updatedData);

                      setState(() {
                        widget.registrar.name = currentRegistrar.name;
                        widget.registrar.phoneNumber =
                            currentRegistrar.phoneNumber;
                        widget.registrar.password = currentRegistrar.password;
                      });

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(' تم تحديث بياناتك بنجاح!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('يرجى تعبئة جميع الحقول بشكل صحيح')));
                    }
                  }, // onPress
                ),
              ],
            ),
          );
        });
      },
    );
  } // _showEditDialog
} // _RegistrarProfilePageState
