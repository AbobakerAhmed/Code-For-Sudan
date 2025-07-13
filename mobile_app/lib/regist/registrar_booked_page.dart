import 'package:flutter/material.dart';
import 'package:mobile_app/backend/citizen/hospital.dart';
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

  Future<void> _fetchAppointments() async {
    for (final dep in widget.registrar.departmentsNames) {
      _allAppointments.addAll(await _firestore.getAppointments(
          widget.registrar.state,
          widget.registrar.locality,
          widget.registrar.hospitalName,
          dep));
    }
  }

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
// connect to database here to bring appointments of all of depratments of this registrar
    // testing data
    // _allAppointments = [
    //   Appointment(
    //       name: ' أحمد علي خالد عمر',
    //       gender: 'ذكر',
    //       age: 30,
    //       neighborhood: 'الرياض',
    //       phoneNumber: '0912345678',
    //       hospital: 'مستشفى الأمل',
    //       department: 'العيون',
    //       doctor: 'د. سارة محمد',
    //       time: DateTime(2025, 6, 27, 10, 0, 15)),
    //   Appointment(
    //       name: 'فاطمة خالد',
    //       gender: 'أنثى',
    //       age: 25,
    //       neighborhood: 'الزهور',
    //       phoneNumber: '0918765432',
    //       hospital: 'مستشفى الأمل',
    //       department: 'الجلدية',
    //       doctor: 'د. نور حسين',
    //       time: DateTime(2025, 6, 27, 11, 0, 30)),
    //   Appointment(
    //       name: 'ليلى أحمد',
    //       gender: 'أنثى',
    //       age: 45,
    //       neighborhood: 'النخيل',
    //       phoneNumber: '0911223344',
    //       hospital: 'مستشفى الأمل',
    //       department: 'العيون',
    //       doctor: 'د. سارة محمد',
    //       time: DateTime(2025, 6, 27, 10, 30, 45)),
    //   Appointment(
    //       name: 'محمد سعيد',
    //       gender: 'ذكر',
    //       age: 50,
    //       neighborhood: 'الواحة',
    //       phoneNumber: '0919876543',
    //       hospital: 'مستشفى الأمل',
    //       department: 'الباطنية',
    //       doctor: 'د. علي حسن',
    //       time: DateTime(2025, 6, 27, 9, 0, 0)),
    //   Appointment(
    //       name: 'ريم منصور',
    //       gender: 'أنثى',
    //       age: 35,
    //       neighborhood: 'الصفا',
    //       hospital: 'مستشفى الأمل',
    //       department: 'الجلدية',
    //       doctor: 'د. نور حسين',
    //       time: DateTime(2025, 6, 27, 11, 30, 10)),
    // ];
    // _checkedInAppointments = []; // we have just start
  } // initState

// so, edit this fun bring doctros of each department
  List<String> _getDoctorsInSelectedDepartment() {
    final selectedDept =
        widget.registrar.departmentsNames[_selectedDepartmentIndex];
    return _allAppointments
        .where((a) => a.department == selectedDept)
        .map((a) => a.doctor)
        .toSet()
        .toList();
  } // _getDoctorsInSelectedDepartment

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

  // this is the dialog that poped up when pressing "إضافة حجز جديد" button
  Future<void> _showAddEditAppointmentDialog(
      {Appointment? existingAppointment}) async {
    // String selectedDepartment = existingAppointment?.department ??
    //     (widget.registrar.departmentsNames.isNotEmpty
    //         ? widget.registrar.departmentsNames[0]
    //         : '');

    String selectedDepartment = (existingAppointment?.department != null)
        ? existingAppointment!.department
        : widget.registrar.departmentsNames[0];

    List<String> getDoctorsForDepartment(String dep) =>
        widget.registrar.departments.where((a) => a.name == dep).first.doctors;

    List<String> doctorsForDepartment =
        getDoctorsForDepartment(selectedDepartment);

    // String selectedDoctor = existingAppointment?.doctor ??
    //     (doctorsForDepartment.isNotEmpty ? doctorsForDepartment[0] : '');
    String? selectedDoctor =
        (existingAppointment?.doctor) ?? (doctorsForDepartment[0]);

    String name = existingAppointment?.name ?? '';
    String? gender = existingAppointment?.gender;
    String age = existingAppointment?.age ?? '';
    String address = existingAppointment?.address ?? '';
    String phoneNumber = existingAppointment?.phoneNumber ?? '';
    DateTime? appointmentDate = existingAppointment?.time;
    TimeOfDay? appointmentTime = existingAppointment != null
        ? TimeOfDay.fromDateTime(existingAppointment.time)
        : null;

    final _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget _buildDatePickerField() {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: appointmentDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selected != null) {
                      setState(() {
                        appointmentDate = selected;
                        print(appointmentDate.toString());
                      });
                    } else {
                      print('Date not selected');
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'موعد الحجز',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    child: Text(
                      appointmentDate != null
                          ? '${appointmentDate!.year}/${appointmentDate!.month.toString().padLeft(2, '0')}/${appointmentDate!.day.toString().padLeft(2, '0')}'
                          : 'اختر موعد الحجز',
                      style: TextStyle(
                        color: appointmentDate != null
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              );
            }

            Widget _buildTimePickerField() {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: appointmentTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        appointmentTime = pickedTime;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'وقت الحجز',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    child: Text(
                      appointmentTime != null
                          ? '${appointmentTime!.hour.toString().padLeft(2, '0')}:${appointmentTime!.minute.toString().padLeft(2, '0')}'
                          : 'اختر وقت الحجز',
                      style: TextStyle(
                        color: appointmentTime != null
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              );
            }

            return AlertDialog(
              title: Text(existingAppointment == null
                  ? 'إضافة موعد جديد'
                  : 'تعديل الموعد'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: name,
                        decoration: const InputDecoration(labelText: 'الاسم'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء إدخال الاسم'
                            : null,
                        onChanged: (value) => name = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: age,
                        decoration: const InputDecoration(labelText: 'العمر'),
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
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: address,
                        decoration: const InputDecoration(labelText: 'السكن'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء إدخال السكن'
                            : null,
                        onChanged: (value) => address = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: phoneNumber,
                        decoration:
                            const InputDecoration(labelText: 'رقم الهاتف '),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => phoneNumber = value,
                        validator: (value) {
                          if (!Validate.phoneNumber(value ?? '')) {
                            return 'رقم الهاتف غير صالح'; // Invalid phone number
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: gender,
                        decoration: const InputDecoration(labelText: 'الجنس'),
                        items: g_gender
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (value) {
                          //if (value != null)
                          setState(() => gender = value);
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedDepartment,
                        decoration: const InputDecoration(labelText: 'القسم'),
                        items: widget.registrar.departmentsNames
                            .map((dept) => DropdownMenuItem(
                                value: dept, child: Text(dept)))
                            .toList(),
                        onChanged: (value) {
                          //&& value != selectedDepartment
                          //if (value != null) {
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
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value:
                            //selectedDoctor.isNotEmpty ? selectedDoctor : null,
                            selectedDoctor,
                        decoration: const InputDecoration(labelText: 'الطبيب'),
                        items: doctorsForDepartment
                            .map((doc) =>
                                DropdownMenuItem(value: doc, child: Text(doc)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedDoctor = value ?? ''),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'الرجاء اختيار الطبيب'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _buildDatePickerField(),
                      _buildTimePickerField(),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('إلغاء'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text(existingAppointment == null ? 'إضافة' : 'تحديث'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (appointmentDate != null && appointmentTime != null) {
                        final fullDateTime = DateTime(
                          appointmentDate!.year,
                          appointmentDate!.month,
                          appointmentDate!.day,
                          appointmentTime!.hour,
                          appointmentTime!.minute,
                        );

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
                          setState(() {
                            _firestore.createAppointment(newAppointment);
                            _allAppointments.add(newAppointment);
                          });
                        } else {
                          setState(() {
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

                            _firestore.updateAppointment(existingAppointment);
                            _allAppointments[_allAppointments.indexOf(
                                existingAppointment)] = existingAppointment;
                            //_fetchAppointments();
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
                    }
                  },
                ),
              ],
            );
          },
        );
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
      return Scaffold(
        appBar: AppBar(title: Text('لا يوجد أطباء في قسم $selectedDept')),
        body: const Center(child: Text('لا توجد مواعيد لهذا القسم')),
        bottomNavigationBar: _buildBottomNavigationBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEditAppointmentDialog(),
          icon: const Icon(Icons.add),
          label: const Text('إضافة موعد جديد'),
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
            title: Text('المواعيد - $selectedDept'),
            // the bar in the bottom of the sceen (departments bar)
            bottom: TabBar(
                isScrollable: true,
                tabs: doctors.map((d) => Tab(text: d)).toList()),
          ),
          // the bar in the top of the screen (doctors bar)
          body: TabBarView(
            children: doctors.map((doctor) {
              final appts = _allAppointments
                  .where(
                      (a) => a.department == selectedDept && a.doctor == doctor)
                  .toList();
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

                  // how appointments are displayed
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      // numbering appointments
                      leading: CircleAvatar(
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
                                  onPressed: () =>
                                      _checkInAppointment(currentAppointment),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
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
                                    onPressed: () =>
                                        _showAddEditAppointmentDialog(
                                            existingAppointment:
                                                currentAppointment),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.edit),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text('تعديل'),
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

          // the floating button (إضافة موعد جديد)
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _showAddEditAppointmentDialog();
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة موعد جديد'),
          ),
        ),
      ),
    );
  }
}
