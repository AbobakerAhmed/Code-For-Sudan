// Date: 26th of Jun 2025

import 'package:flutter/material.dart';
import 'backend/registrar.dart';

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
          title: const Text('الملف الشخصي للمسجل'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/registrar_avatar.png'), // adding image or icon or anything
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
                subtitle: Text(registrar.hospital),
              ),

              // departments
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('الأقسام المسؤولة عنها'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: registrar.departments
                      .map((dep) => Text('• $dep'))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24), // between departments and the button

              // eidting button
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('تعديل البيانات'),
                onPressed: () {
                  _showEditDialog(context);
// edit the registrar data (only name, phone number, password)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('ميزة تعديل البيانات غير مفعلة حالياً')),
                  );
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
          return AlertDialog(
            title: Text("تعديل بيانات المسجل"),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // edit the name
                    TextFormField(
                      initialValue: currentRegistrar?.name,
                      decoration: const InputDecoration(labelText: 'الاسم'),
                      validator: (value) {
// validate the name here
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                      onChanged: (value) => currentRegistrar?.name = value,
                    ),

                    const SizedBox(height: 10), // between name and phone number

                    // enter phone number
                    TextFormField(
                      initialValue: currentRegistrar?.phoneNumber.toString(),
                      decoration:
                          const InputDecoration(labelText: 'رقم الهاتف'),
                      keyboardType: TextInputType.phone,
// validate the phone number here
                      onChanged: (value) =>
                          currentRegistrar?.phoneNumber = value,
                    ),

                    const SizedBox(height: 10), // between age and neighborhood

                    // enter neighborhood
                    TextFormField(
                      initialValue: currentRegistrar?.password,
                      decoration:
                          const InputDecoration(labelText: 'كلمة المرور'),
                      validator: (value) {
// validate the password here
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        } // if
                        return null;
                      }, // validator
// encode it
                      onChanged: (value) => currentRegistrar?.password = value,
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
                child: const Text('إلغاء'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // added it to the appointments list
// connect to the database here to add the new appointment
              ElevatedButton(
                child: Text('تحديث'),
// there is a problem here
// when adding the appointment to the same page it is not be shown directly
                onPressed: () {}, // onPress
              ),
            ],
          );
        });
      },
    );
  } // _showEditDialog
} // RegistrarProfilePage
