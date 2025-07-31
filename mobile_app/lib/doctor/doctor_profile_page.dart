// Date: 18th of Jul 2025

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/backend/doctor/doctor.dart';
import 'package:mobile_app/backend/validate_fields.dart';

import 'package:mobile_app/firestore_services/firestore.dart';

class DoctorProfilePage extends StatefulWidget {
  final Doctor doctor; // required (see doctor.dart)

  DoctorProfilePage({super.key, required this.doctor}); // constructor

  @override
  State<StatefulWidget> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (!mounted) return;
    setState(() {
      _isConnected = (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi));
    });
  }

  // build fun
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: Scaffold(
        appBar: AppBar(
          title: Text('الملف الشخصي'),
        ),
        body: Column(
          children: [
            if (!_isConnected)
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.red,
                child: const Text(
                  'لا يوجد اتصال بالإنترنت. لا يمكنك تعديل بياناتك.',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).primaryColorLight,
                      radius: 50,
                      child: Text(
                        widget.doctor.name.substring(0, 2).toUpperCase(),
                        style: TextStyle(fontSize: 50),
                      ), // adding image or icon or anything
                    ),
                    const SizedBox(height: 16), // between image and the name

                    // doctor name
                    Text(
                      widget.doctor.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(
                        height: 10), // between name and the phone number

                    // phone number
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('رقم الهاتف'),
                      subtitle: Text(widget.doctor.phoneNumber),
                    ),

                    // hsopital
                    ListTile(
                      leading: const Icon(Icons.local_hospital),
                      title: const Text('المستشفى'),
                      subtitle: Text(widget.doctor.hospitalName),
                    ),

                    // departments
                    ListTile(
                      leading: const Icon(Icons.category),
                      title: const Text('القسم'),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.doctor.department.name),
                          ]),
                    ),

                    const SizedBox(
                        height: 24), // between departments and the button

                    // eidting button
                    ElevatedButton.icon(
                      icon: Icon(Icons.edit,
                          color: Theme.of(context).primaryColor),
                      label: Text(
                        'تعديل البيانات',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),

                      //the method works but there is going to be problems in appointments if the doctor changed his name
                      onPressed: _isConnected
                          ? () async {
                              await _showEditDialog(context, widget.doctor);
                              setState(() {});
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } // build fun

// this is the dialog for editing the doctor data
  Future<void> _showEditDialog(
      BuildContext context, Doctor currentDoctor) async {
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
                "تعديل بيانات الدكتور",
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
                        initialValue: currentDoctor.name,
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
                        onChanged: (value) => currentDoctor.name = value,
                      ),

                      const SizedBox(
                          height: 10), // between name and phone number

                      // enter phone number
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentDoctor.phoneNumber.toString(),
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
                        onChanged: (value) => currentDoctor.phoneNumber = value,
                      ),
                      const SizedBox(
                          height: 10), // between age and neighborhood

                      // enter password
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        initialValue: currentDoctor.password,
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
                        onChanged: (value) => currentDoctor.password = value,
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
                // connect to the database here to update the doctor info
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
                  onPressed: _isConnected
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            final updatedData = {
                              'name': currentDoctor.name,
                              'phoneNumber': currentDoctor.phoneNumber,
                              'password': currentDoctor.password,
                              'hospitalName': widget.doctor.hospitalName,
                              'state': widget.doctor.state,
                              'locality': widget.doctor.locality,
                            };

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
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });

                            try {
                              await _firestoreService.updateDoctor(
                                  widget.doctor.phoneNumber,
                                  widget.doctor.department.name,
                                  updatedData);

                              if (!mounted) return;
                              Navigator.of(context).pop(); // Pop loading dialog
                              Navigator.of(context).pop(); // Pop edit dialog

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('تم تحديث بياناتك بنجاح!')));
                            } catch (e) {
                              if (!mounted) return;
                              Navigator.of(context).pop(); // Pop loading dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('حدث خطأ أثناء التحديث: ${e}')));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'يرجى تعبئة جميع الحقول بشكل صحيح')));
                          }
                        }
                      : null, // onPress // onPress
                ),
              ],
            ),
          );
        });
      },
    );
  } // _showEditDialog
} // doctorProfilePage
