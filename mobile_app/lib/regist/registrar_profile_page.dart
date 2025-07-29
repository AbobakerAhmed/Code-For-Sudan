// Date: 26th of Jun 2025

import 'package:flutter/material.dart';
import 'package:mobile_app/backend/registrar/registrar.dart';

class RegistrarProfilePage extends StatelessWidget {
  final Registrar registrar; // required (see registrar.dart)
  const RegistrarProfilePage(
      {super.key, required this.registrar}); // constructor

  // build fun
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: Scaffold(
        appBar: AppBar(
          title: Text('الملف الشخصي للمسجل'),
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
                  registrar.name.substring(0, 2).toUpperCase(),
                  style: TextStyle(fontSize: 50),
                ), // adding image or icon or anything
              ),
              const SizedBox(height: 16), // between image and the name

              // registrar name
              Text(
                registrar.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10), // between name and the phone number

              // phone number
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('رقم الهاتف'),
                subtitle: Text(registrar.phoneNumber),
              ),

              // hsopital
              ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('المستشفى'),
                subtitle: Text(registrar.hospitalName),
              ),

              // departments
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('الأقسام المسؤولة عنها'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: registrar.departmentsNames
                      .map((dep) => Text('• $dep'))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24), // between departments and the button

              // eidting button
              ElevatedButton.icon(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                label: Text(
                  'تعديل البيانات',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _showEditDialog(context);
// edit the registrar data (only name, phone number, password)
                },
              ),
            ],
          ),
        ),
      ),
    );
  } // build fun

// this is the dialog for editing the registrar data
  Future<void> _showEditDialog(BuildContext context,
      {Registrar? currentRegistrar}) async {
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
                        initialValue: currentRegistrar?.name,
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
                        onChanged: (value) => currentRegistrar?.name = value,
                      ),

                      const SizedBox(
                          height: 10), // between name and phone number

                      // enter phone number
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentRegistrar?.phoneNumber.toString(),
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
                        // validate the phone number here
                        onChanged: (value) =>
                            currentRegistrar?.phoneNumber = value,
                      ),
                      const SizedBox(
                          height: 10), // between age and neighborhood

                      // enter password
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentRegistrar?.password,
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
                          // validate the password here
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          } // if
                          return null;
                        }, // validator
                        // encode it
                        onChanged: (value) =>
                            currentRegistrar?.password = value,
                      ),

                      const SizedBox(
                          height: 10), // between phone number and gender
                    ],
                  ),
                ),
              ),
              actions: [
                // chencle
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
                  // there is a problem here
                  // when adding the new info to the same page it is not be shown directly
                  onPressed: () {}, // onPress
                ),
              ],
            ),
          );
        });
      },
    );
  } // _showEditDialog
} // RegistrarProfilePage
