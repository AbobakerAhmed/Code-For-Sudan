// Date: 26th of Jun 2025

import 'package:flutter/material.dart';
import 'package:mobile_app/backend/citizen/citizen.dart';
import 'package:mobile_app/backend/validate_fields.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

class CitizenProfilePage extends StatefulWidget {
  final Citizen citizen; // required (see registrar.dart)

  CitizenProfilePage({super.key, required this.citizen}); // constructor
  @override
  State<CitizenProfilePage> createState() => _CitizenProfilePageState();
}

class _CitizenProfilePageState extends State<CitizenProfilePage> {
  FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
  }

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
                  widget.citizen.name.substring(0, 2).toUpperCase(),
                  style: TextStyle(fontSize: 50),
                ), // adding image or icon or anything
              ),
              const SizedBox(height: 16), // between image and the name

              // registrar name
              Text(
                widget.citizen.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10), // between name and the phone number

              // phone number
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('رقم الهاتف'),
                subtitle: Text(widget.citizen.phoneNumber),
              ),

              // address
              ListTile(
                leading: const Icon(Icons.place),
                title: const Text('العنوان'),
                subtitle: Text(widget.citizen.address),
              ),

              // birth date
              ListTile(
                  leading: const Icon(
                    Icons.cake,
                  ),
                  title: const Text('الميلاد'),
                  subtitle: Text(
                      '${widget.citizen.birthDate.year.toString()}/${widget.citizen.birthDate.month.toString().padLeft(2, '0')}/${widget.citizen.birthDate.toUtc().day.toString().padLeft(2, '0')}')),

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
                      fontWeight: FontWeight.bold),
                ),

                //the method works but there is going to be problems in appointments if the citizen changed his name or phone number
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('هذه الميزة لا تعمل حاليا')));
                  await _showEditDialog(context, widget.citizen);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  } // build fun

// this is the dialog for editing the registrar data
  Future<void> _showEditDialog(
      BuildContext context, Citizen currentCitizen) async {
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
                "تعديل بيانات المواطن",
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
                        initialValue: currentCitizen.name,
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
                        onChanged: (value) => currentCitizen.name = value,
                      ),

                      const SizedBox(
                          height: 10), // between name and phone number

                      // enter phone number
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentCitizen.phoneNumber.toString(),
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
                            currentCitizen.phoneNumber = value,
                      ),

                      const SizedBox(height: 10), // between age and password

                      // enter password
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentCitizen.password,
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
                        onChanged: (value) => currentCitizen.password = value,
                      ),

                      const SizedBox(
                          height: 10), // between phone number and gender

                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text:
                              '${currentCitizen.birthDate.year}/${currentCitizen.birthDate.month.toString().padLeft(2, '0')}/${currentCitizen.birthDate.day.toString().padLeft(2, '0')}',
                        ),
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                          labelText: 'تاريخ الميلاد',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                          suffixIcon: Icon(Icons.calendar_today,
                              color: Theme.of(context).primaryColor),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        onTap: () async {
                          final selected = await showDatePicker(
                            context: context,
                            initialDate: currentCitizen.birthDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (selected != null) {
                            setState(() {
                              currentCitizen.birthDate = selected;
                            });
                          }
                        },
                      ),

                      const SizedBox(
                          height: 10), // between phone number and gender

                      // enter password
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentCitizen.address,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                            labelText: 'العنوان',
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
                            return 'الرجاء إدخال العنوان';
                          } // if
                          return null;
                        }, // validator
                        // encode it
                        onChanged: (value) => currentCitizen.address = value,
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
                // connect to the database here to update the citizen info
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
                        'name': currentCitizen.name,
                        'phoneNumber': currentCitizen.phoneNumber,
                        'password': currentCitizen.password,
                        'address': currentCitizen.address,
                        'birthDate': currentCitizen.birthDate
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

                      await _firestoreService.updateCitizen(
                          widget.citizen.phoneNumber, updatedData);

                      setState(() {
                        widget.citizen.name = currentCitizen.name;
                        widget.citizen.phoneNumber = currentCitizen.phoneNumber;
                        widget.citizen.address = currentCitizen.address;
                        widget.citizen.birthDate = currentCitizen.birthDate;
                        widget.citizen.password = currentCitizen.password;
                      });

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(' تم تحديث بياناتك بنجاح!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('يرجى تعبئة جميع الحقول بشكل صحيح')));
                    }
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  } // _showEditDialog
} // _CitizenProfilePageState
