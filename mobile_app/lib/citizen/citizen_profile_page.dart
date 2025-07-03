// Date: 26th of Jun 2025

import 'package:flutter/material.dart';
import 'package:registrar_app/styles.dart';
import 'backend/citizen.dart';

class CitizenProfilePage extends StatelessWidget {
  final Citizen citizen; // required (see registrar.dart)
  const CitizenProfilePage({super.key, required this.citizen}); // constructor

  // build fun
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: Scaffold(
        appBar: AppBar(title: Text("الملف الشخصي")),
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
                  citizen.citizenName![0].toUpperCase(),
                  style: TextStyle(fontSize: 50),
                ), // adding image or icon or anything
              ),
              const SizedBox(height: 16), // between image and the name

              // registrar name
              Text(
                citizen.citizenName!,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10), // between name and the phone number

              // phone number
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('رقم الهاتف'),
                subtitle: Text(citizen.phoneNumber!),
              ),

              // hsopital
              ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('العنوان'),
                subtitle: Text(citizen.address!),
              ),

              // departments
              ListTile(
                  leading: const Icon(
                    Icons.category,
                  ),
                  title: const Text('الميلاد'),
                  subtitle: Text(citizen.birthDate.toString())),

              const SizedBox(height: 24), // between departments and the button

              // eidting button
              ElevatedButton.icon(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'تعديل البيانات',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
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
      {Citizen? currentCitizen}) async {
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
                      initialValue: currentCitizen?.citizenName,
                      decoration: const InputDecoration(labelText: 'الاسم'),
                      validator: (value) {
// validate the name here
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                      onChanged: (value) => currentCitizen?.citizenName = value,
                    ),

                    const SizedBox(height: 10), // between name and phone number

                    // enter phone number
                    TextFormField(
                      initialValue: currentCitizen?.phoneNumber.toString(),
                      decoration:
                          const InputDecoration(labelText: 'رقم الهاتف'),
                      keyboardType: TextInputType.phone,
// validate the phone number here
                      onChanged: (value) => currentCitizen?.phoneNumber = value,
                    ),

                    const SizedBox(height: 10), // between age and neighborhood

                    // enter neighborhood
                    TextFormField(
                      initialValue: currentCitizen?.password,
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
                      onChanged: (value) => currentCitizen?.password = value,
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
