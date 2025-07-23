import 'package:flutter/material.dart';
//import 'package:mobile_app/backend/citizen/hospital.dart';
import 'package:mobile_app/backend/registrar/registrar.dart';
import 'package:mobile_app/backend/registrar/appoinment.dart'; // similate appointment class
import 'package:mobile_app/backend/global_var.dart';
import 'package:mobile_app/backend/validate_fields.dart';

import 'package:mobile_app/firestore_services/firestore.dart';

// booked appointments page
class BookedAppointmentsPage extends StatefulWidget {
  final Registrar
      registrar; // which registrar (look registrar.dart in the backend folder)
  const BookedAppointmentsPage(
      {super.key, required this.registrar}); // constructor

  // create state fun
  @override
  State<BookedAppointmentsPage> createState() => BookedAppointmentsPageState();
} //BookedAppointmentsPage

// booked appointments content
class BookedAppointmentsPageState extends State<BookedAppointmentsPage> {
  final FirestoreService _firestore = FirestoreService();

  /// this method load the appointments from the database
  /// and put all appointments in the empty _allApointments variable
  Future<void> _fetchAppointments() async {
    for (final dep in widget.registrar.departmentsNames) {
      _allAppointments.addAll(await _firestore.getAppointments(
          widget.registrar.state,
          widget.registrar.locality,
          widget.registrar.hospitalName,
          dep));
    }
  }

  ///this method load the appointments for the registrar
  Future<void> _loadInitialAppointments() async {
    await _fetchAppointments(); // this sets _allAppointments internally
    setState(() {}); // make sure UI updates after loading
  }

  int _selectedDepartmentIndex =
      0; // to split taps of each departments with its doctors
  List<Appointment> _allAppointments = []; // appointments registrar have
  List<Appointment> _checkedInAppointments = []; // who goes to the doctor

  // this fun initalize the page when creating
  @override
  void initState() {
    super.initState();
    _loadInitialAppointments();
  } // initState

  ///this fun bring doctros of each department
  List<String> _getDoctorsInSelectedDepartment() {
    final selectedDept =
        widget.registrar.departmentsNames[_selectedDepartmentIndex];
    return _allAppointments
        .where((a) => a.department == selectedDept)
        .map((a) => a.doctor)
        .toSet()
        .toList();
  } // _getDoctorsInSelectedDepartment

  List<Appointment> _sortAppointmentsByTime(List<Appointment> appointments) {
    appointments.sort((a, b) => a.time.compareTo(b.time));
    return appointments;
  } // _sortAppointmentsByTime

  // after an appointment go to the doctor
  void _checkInAppointment(Appointment appointment) {
    if (!_checkedInAppointments.contains(appointment)) {
      setState(() {
        _checkedInAppointments.add(appointment);
      });

// connect to the database here to send its data to the database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تسجيل دخول ${appointment.name}.')),
      );
    } //if
  } // _checkInAppointment

  /// this is the dialog that poped up when pressing "إضافة حجز جديد" button
  Future<void> _showAddEditAppointmentDialog(
      {Appointment? existingAppointment}) async {
    String selectedDepartment = (existingAppointment?.department != null)
        ? existingAppointment!.department
        : widget.registrar.departmentsNames[0];

    List<String> getDoctorsForDepartment(String dep) =>
        widget.registrar.departments.where((a) => a.name == dep).first.doctors;

    List<String> doctorsForDepartment =
        getDoctorsForDepartment(selectedDepartment);

    String? selectedDoctor =
        (existingAppointment?.doctor) ?? (doctorsForDepartment[0]);

    String name = existingAppointment?.name ?? '';
    String? gender = existingAppointment?.gender;
    String age = existingAppointment?.age ?? '';
    String address = existingAppointment?.address ?? '';
    String phoneNumber = existingAppointment?.phoneNumber ?? '';
    //DateTime? appointmentDate = existingAppointment?.time;
    //TimeOfDay? appointmentTime = existingAppointment != null
    // ? TimeOfDay.fromDateTime(existingAppointment.time)
    // : null;

    final _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Theme.of(context).primaryColorLight,
              title: Text(
                existingAppointment == null
                    ? 'إضافة موعد جديد'
                    : 'تعديل الموعد',
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
                      // enter name
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        initialValue: name,
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
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء إدخال الاسم'
                            : null,
                        onChanged: (value) => name = value,
                      ),

                      const SizedBox(height: 10), // between name and age

                      // enter age
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        initialValue: age,
                        decoration: InputDecoration(
                          labelText: 'العمر',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال العمر';
                          final n = int.tryParse(value);
                          if (n == null || n <= 0 || n > 150)
                            return 'الرجاء إدخال عمر صحيح';
                          return null;
                        },
                        onChanged: (value) => age = value,
                      ),

                      const SizedBox(
                          height: 10), // between age and neighborhood

                      // enter address
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        initialValue: address,
                        decoration: InputDecoration(
                          labelText: 'السكن',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء إدخال السكن'
                            : null,
                        onChanged: (value) => address = value,
                      ),

                      const SizedBox(
                          height: 10), // between niebourhod and phone number

                      // enter phone number
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        initialValue: phoneNumber,
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => phoneNumber = value,
                        validator: (value) {
                          if (!Validate.phoneNumber(value ?? '')) {
                            return 'رقم الهاتف غير صالح'; // Invalid phone number
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                          height: 10), // between phone number and gender

                      // chose gender
                      DropdownButtonFormField<String>(
                        iconEnabledColor:
                            Theme.of(context).secondaryHeaderColor,
                        iconDisabledColor:
                            Theme.of(context).secondaryHeaderColor,
                        value: gender,
                        validator: (value) {
                          // validate the gender here
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الجنس';
                          } // if
                          return null;
                        },
                        dropdownColor: Theme.of(context).cardColor,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                          labelText: 'الجنس',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        items: g_gender.map((g) {
                          return DropdownMenuItem(
                            value: g,
                            child: Text(g,
                                style:
                                    Theme.of(context).textTheme.displaySmall),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => gender = value);
                        },
                      ),

                      const SizedBox(
                          height: 10), // between gender and department

                      // chose the department
                      DropdownButtonFormField<String>(
                        iconEnabledColor:
                            Theme.of(context).secondaryHeaderColor,
                        iconDisabledColor:
                            Theme.of(context).secondaryHeaderColor,
                        value: selectedDepartment,
                        dropdownColor: Theme.of(context).cardColor,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                          labelText: 'القسم',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        items: widget.registrar.departmentsNames.map((dept) {
                          return DropdownMenuItem(
                              value: dept,
                              child: Text(dept,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDepartment = value!;

                            try {
                              doctorsForDepartment =
                                  getDoctorsForDepartment(selectedDepartment);

                              selectedDoctor = doctorsForDepartment[0];
                            } catch (e) {
                              print('Error: {$e}');
                            }
                          });
                        },
                      ),

                      const SizedBox(
                          height: 10), // between department and doctor

                      // chose the doctor depending on the department
                      // make sure the doctor depending on the department
                      DropdownButtonFormField<String>(
                        iconEnabledColor:
                            Theme.of(context).secondaryHeaderColor,
                        iconDisabledColor:
                            Theme.of(context).secondaryHeaderColor,
                        value: selectedDoctor,
                        dropdownColor: Theme.of(context).cardColor,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                          labelText: 'الطبيب',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        items: doctorsForDepartment.map((doc) {
                          return DropdownMenuItem(
                              value: doc,
                              child: Text(doc,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall));
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => selectedDoctor = value ?? ''),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'الرجاء اختيار الطبيب'
                            : null,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              actions: [
                // chencle
                TextButton(
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                // added it to the appointments list
                // connect to the database here to add the new appointment
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text(
                      existingAppointment == null ? 'إضافة' : 'تحديث',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    // there is a problem here
                    // when adding the appointment to the same page it is not be shown directly
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // if (appointmentDate != null && appointmentTime != null) {
                        final fullDateTime = DateTime.utc(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          DateTime.now().hour,
                          DateTime.now().minute,
                        );
                        DateTime inSudanTime =
                            fullDateTime.add(const Duration(hours: 2));

                        if (existingAppointment == null) {
                          final newAppointment = Appointment(
                            name: name,
                            gender: gender!,
                            age: age,
                            address: address,
                            phoneNumber: phoneNumber,
                            state: widget.registrar.state,
                            locality: widget.registrar.locality,
                            hospital: widget.registrar.hospitalName,
                            department: selectedDepartment,
                            doctor: selectedDoctor!,
                            time: fullDateTime,
                            isLocal: true,
                          );
                          await _firestore.createAppointment(newAppointment);
                          newAppointment.time = inSudanTime;
                          _allAppointments.add(newAppointment);
                          setState(() {});
                        } else {
                          await _firestore
                              .deleteAppointment(existingAppointment);
                          existingAppointment.name = name;
                          existingAppointment.gender = gender!;
                          existingAppointment.age = age;
                          existingAppointment.address = address;
                          existingAppointment.phoneNumber = phoneNumber;
                          existingAppointment.department = selectedDepartment;
                          existingAppointment.doctor = selectedDoctor!;
                          existingAppointment.hospital =
                              widget.registrar.hospitalName;
                          existingAppointment.time = fullDateTime;
                          await _firestore
                              .createAppointment(existingAppointment);
                          setState(() {
                            existingAppointment.time = inSudanTime;
                            _allAppointments[_allAppointments.indexOf(
                                existingAppointment)] = existingAppointment;
                          });
                        }

                        Navigator.of(context).pop();
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('الرجاء التحقق من ادخال كل البيانات')),
                        );
                      }
                    }),
              ],
            ),
          );
        });
      },
    );
  }

  // the bar in the bottom of the booked appoinments page
  // it shown an icon for each department of this registrar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedDepartmentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: widget.registrar.departmentsNames
          .map((dept) => BottomNavigationBarItem(
              icon: const Icon(Icons.monitor_heart), label: dept))
          .toList(),
      onTap: (i) => setState(() => _selectedDepartmentIndex = i),
    );
  } // _buildBottomNavigationBar

  // build fun
  @override
  Widget build(BuildContext context) {
    final selectedDept = widget.registrar
        .departmentsNames[_selectedDepartmentIndex]; // for the button bar
    final doctors = _getDoctorsInSelectedDepartment(); // for the top taps
    // checking if the department has no doctors
    if (doctors.isEmpty) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text('المواعيد')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
                SizedBox(
                  height: 30,
                ),
                Text("كيف حالك"),
              ],
            ),
          ),
        ),
      );
    } // if

    // if there is atleast one doctor in the department
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: DefaultTabController(
        length: doctors.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('المواعيد ($selectedDept)'),
            // the bar in the bottom of the app bar (doctors bar)
            bottom: TabBar(
              isScrollable: true,
              tabs: doctors.map((d) => Tab(text: d)).toList(),
            ),
          ),
          body: TabBarView(
            children: doctors.map((doctor) {
              final appts = _sortAppointmentsByTime(_allAppointments
                  .where(
                      (a) => a.department == selectedDept && a.doctor == doctor)
                  .toList());

              // checking there is appointments in the department
              if (appts.isEmpty) {
                return const Center(
                    child: Text('لا توجد مواعيد حالياً.',
                        style: TextStyle(color: Colors.grey)));
              } // if

// is ListView.builder is the best choice for performance later?
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: appts.length,
// gitting the appointment from _allAppointments
                itemBuilder: (context, appointmentsCounter) {
                  final currentAppointment = appts[appointmentsCounter];

                  final String timeString = currentAppointment.time != null
                      ? '${currentAppointment.time.hour.toString().padLeft(2, '0')}:${currentAppointment.time.minute.toString().padLeft(2, '0')}:${currentAppointment.time.second.toString().padLeft(2, '0')}'
                      : 'غير محدد';

                  final String dateString = currentAppointment.time != null
                      ? '${currentAppointment.time.year.toString()}/${currentAppointment.time.month.toString().padLeft(2, '0')}/${currentAppointment.time.day.toString().padLeft(2, '0')}'
                      : 'غير محدد';

                  // how appointments are displayed
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      // numbering appointments
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).cardColor,
                        child: Text(
                          '${appointmentsCounter + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
// send the counter to the citizen how create the appointment
                      title: Text(currentAppointment
                          .name), // appointment name will be the title of the card
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // how the age and nbh are displayed: (العمر: 30  |  السكن: الواحة - 12)
                              Text(
                                  'العمر: ${currentAppointment.age}  \nالسكن: ${currentAppointment.address}'),
                              if (currentAppointment.phoneNumber != null &&
                                  currentAppointment.phoneNumber!.isNotEmpty)
                                Text(
                                    'هاتف: ${currentAppointment.phoneNumber}'), // phone number
                              if (dateString != 'غير محدد')
                                Text(
                                  'تاريخ الإنشاء: $dateString',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),

                              if (timeString != 'غير محدد')
                                Text(
                                  'وقت الإنشاء: $timeString',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                            ],
                          ),
                          Wrap(
                              spacing: 8,
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    iconColor:
                                        WidgetStatePropertyAll(Colors.green),
                                    side: WidgetStatePropertyAll(
                                        BorderSide(color: Colors.green)),
                                  ),
                                  onPressed: () =>
                                      _checkInAppointment(currentAppointment),
                                  child: const Icon(
                                      Icons.check), //const Text('دخول'),
// here we should send the appointment data to the doctor
// think if the doctor send the persont to the lap or x-ray, how he will be back to the queue
// sure he will not go to the end but where exactly to add him?
// and when exctly the appointment will be removed from this list
                                ),

//someone booked an appointment and doesn't come in his order did came,
// is hemust be removed dirctly from here?
                                OutlinedButton(
                                  style: ButtonStyle(
                                      iconColor:
                                          WidgetStatePropertyAll(Colors.red),
                                      side: WidgetStatePropertyAll(
                                          BorderSide(color: Colors.red))),
                                  onPressed: () async {
                                    await _firestore
                                        .deleteAppointment(currentAppointment);
                                    setState(() {
                                      _allAppointments
                                          .remove(currentAppointment);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '! تم إلغاء الموعد بنجاح')));
                                  },
                                  child: const Icon(Icons.close),
// here we should send the appointment data to the doctor
                                ),

                                // appointments which created by the registrar itself only can be edited
                                if (currentAppointment.isLocal)
                                  OutlinedButton(
                                    onPressed: () async {
                                      await _showAddEditAppointmentDialog(
                                          existingAppointment:
                                              currentAppointment);
                                      setState(() {});
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text('تعديل',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )),
                                      ],
                                    ),
                                  ),
                              ]),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          // the floating button (إضافة موعد جديد)
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await _showAddEditAppointmentDialog();
              setState(() {});
            },
            foregroundColor: Theme.of(context).primaryColorDark,
            backgroundColor: Theme.of(context).cardColor,
            icon: const Icon(Icons.add),
            label: const Text('إضافة موعد جديد'),
          ),
        ),
      ),
    );
  }
}
