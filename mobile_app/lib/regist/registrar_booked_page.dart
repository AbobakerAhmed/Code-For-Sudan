import 'package:flutter/material.dart';
import 'package:mobile_app/backend/registrar/registrar.dart';
import 'package:mobile_app/backend/registrar/appoinment.dart'; // similate appointment class

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
  int _selectedDepartmentIndex =
      0; // to split taps of each departments with its doctors
  late List<Appointment> _allAppointments; // appointments registrar have
  late List<Appointment> _checkedInAppointments; // who goes to the doctor

  // this fun initalize the page when creating
  @override
  void initState() {
    super.initState();
// connect to database here to bring appointments of all of depratments of this registrar
    // testing data
    _allAppointments = [
      Appointment(
          name: ' أحمد علي خالد عمر',
          gender: 'ذكر',
          age: 30,
          neighborhood: 'الرياض',
          phoneNumber: '0912345678',
          hospital: 'مستشفى الأمل',
          department: 'العيون',
          doctor: 'د. سارة محمد',
          time: DateTime(2025, 6, 27, 10, 0, 15)),
      Appointment(
          name: 'فاطمة خالد',
          gender: 'أنثى',
          age: 25,
          neighborhood: 'الزهور',
          phoneNumber: '0918765432',
          hospital: 'مستشفى الأمل',
          department: 'الجلدية',
          doctor: 'د. نور حسين',
          time: DateTime(2025, 6, 27, 11, 0, 30)),
      Appointment(
          name: 'ليلى أحمد',
          gender: 'أنثى',
          age: 45,
          neighborhood: 'النخيل',
          phoneNumber: '0911223344',
          hospital: 'مستشفى الأمل',
          department: 'العيون',
          doctor: 'د. سارة محمد',
          time: DateTime(2025, 6, 27, 10, 30, 45)),
      Appointment(
          name: 'محمد سعيد',
          gender: 'ذكر',
          age: 50,
          neighborhood: 'الواحة',
          phoneNumber: '0919876543',
          hospital: 'مستشفى الأمل',
          department: 'الباطنية',
          doctor: 'د. علي حسن',
          time: DateTime(2025, 6, 27, 9, 0, 0)),
      Appointment(
          name: 'ريم منصور',
          gender: 'أنثى',
          age: 35,
          neighborhood: 'الصفا',
          hospital: 'مستشفى الأمل',
          department: 'الجلدية',
          doctor: 'د. نور حسين',
          time: DateTime(2025, 6, 27, 11, 30, 10)),
    ];
    _checkedInAppointments = []; // we have just start
  } // initState

  // in my registrar object, I have assumed that it has departments field only not doctors to
// so, edit this fun and connect with the database here to bring doctros of each department
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
    String selectedDepartment = existingAppointment?.department ??
        (widget.registrar.departmentsNames.isNotEmpty
            ? widget.registrar.departmentsNames[0]
            : '');
    List<String> doctorsForDepartment = _allAppointments
        .where((a) => a.department == selectedDepartment)
        .map((a) => a.doctor)
        .toSet()
        .toList();
    String selectedDoctor = existingAppointment?.doctor ??
        (doctorsForDepartment.isNotEmpty ? doctorsForDepartment[0] : '');

    String name = existingAppointment?.name ?? ''; // name
    String gender =
        existingAppointment?.gender ?? 'ذكر'; // gender (defualt ذكر)
    int age = existingAppointment?.age ?? 0; // العمر
    String neighborhood = existingAppointment?.neighborhood ?? ''; // السكن
    String? phoneNumber = existingAppointment
        ?.phoneNumber; // رقم الهاتف (اختياري لان المريض قاعد في المستشفى)
    final _formKey = GlobalKey<FormState>(); // global key

    // that will be pobed up only when pressing the button
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                    // enter name
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(labelText: 'الاسم'),
                      validator: (value) {
// validate the name here
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                      onChanged: (value) => name = value,
                    ),

                    const SizedBox(height: 10), // between name and age

                    // enter age
                    TextFormField(
                      initialValue: age > 0 ? age.toString() : '',
                      decoration: const InputDecoration(labelText: 'العمر'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال العمر';
                        }
                        final n = int.tryParse(value);
// validate the age
                        if (n == null || n <= 0 || n > 150) {
                          return 'الرجاء إدخال عمر صحيح';
                        } // if
                        return null;
                      }, // validator
                      onChanged: (value) => age = int.tryParse(value) ?? 0,
                    ),

                    const SizedBox(height: 10), // between age and neighborhood

                    // enter neighborhood
                    TextFormField(
                      initialValue: neighborhood,
                      decoration: const InputDecoration(labelText: 'السكن'),
                      validator: (value) {
// validate the neighborhood here
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال السكن';
                        } // if
                        return null;
                      }, // validator
                      onChanged: (value) => neighborhood = value,
                    ),

                    const SizedBox(
                        height: 10), // between niebourhod and phone number

                    // enter phone number
                    TextFormField(
                      initialValue: phoneNumber ?? '',
                      decoration: const InputDecoration(
                          labelText: 'رقم الهاتف (اختياري)'),
                      keyboardType: TextInputType.phone,
// validate the phone number here
                      onChanged: (value) => phoneNumber = value,
                    ),

                    const SizedBox(
                        height: 10), // between phone number and gender

                    // chose gender
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: const InputDecoration(labelText: 'الجنس'),
                      items: ['ذكر', 'أنثى'].map((g) {
                        return DropdownMenuItem(value: g, child: Text(g));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            gender = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10), // between gender and department

                    // chose the department
                    DropdownButtonFormField<String>(
                      value: selectedDepartment,
                      decoration: const InputDecoration(labelText: 'القسم'),
                      items: widget.registrar.departmentsNames.map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null && value != selectedDepartment) {
                          setState(() {
                            selectedDepartment = value;
                            doctorsForDepartment = _allAppointments
                                .where(
                                    (a) => a.department == selectedDepartment)
                                .map((a) => a.doctor)
                                .toSet()
                                .toList();

                            selectedDoctor = doctorsForDepartment.isNotEmpty
                                ? doctorsForDepartment[0]
                                : '';
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10), // between department and doctor

                    // chose the doctor depending on the department
// make sure the doctor depending on the department
                    DropdownButtonFormField<String>(
                      value: selectedDoctor.isNotEmpty ? selectedDoctor : null,
                      decoration: const InputDecoration(labelText: 'الطبيب'),
                      items: doctorsForDepartment.map((doc) {
                        return DropdownMenuItem(value: doc, child: Text(doc));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedDoctor = value;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء اختيار الطبيب';
                        }
                        return null;
                      },
                    ),
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
                child: Text(existingAppointment == null ? 'إضافة' : 'تحديث'),
// there is a problem here
// when adding the appointment to the same page it is not be shown directly
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (existingAppointment == null) {
                      final newAppointment = Appointment(
                        name: name,
                        gender: gender,
                        age: age,
                        neighborhood: neighborhood,
                        phoneNumber: phoneNumber,
                        hospital: widget.registrar.hospitalName,
                        department: selectedDepartment,
                        doctor: selectedDoctor,
                        time: DateTime.now(),
                        isLocal: true,
                      );
                      setState(() {
                        _allAppointments.add(newAppointment);
                      });
                    } // in if
                    else {
                      setState(() {
                        existingAppointment.name = name;
                        existingAppointment.gender = gender;
                        existingAppointment.age = age;
                        existingAppointment.neighborhood = neighborhood;
                        existingAppointment.phoneNumber = phoneNumber;
                        existingAppointment.department = selectedDepartment;
                        existingAppointment.doctor = selectedDoctor;
                        existingAppointment.hospital =
                            widget.registrar.hospitalName;
                        existingAppointment.time = DateTime.now();
                      });
                    } // in else
                    Navigator.of(context)
                        .pop(); // أغلق نافذة الإضافة أو التعديل
                    setState(() {}); // 👈 أعد بناء الصفحة بعد الإغلاق
                  } // out if
                }, // onPress
              ),
            ],
          );
        });
      },
    );
  } // _showAddEditAppointmentDialog

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
                      ? '${currentAppointment.time!.hour.toString().padLeft(2, '0')}:${currentAppointment.time!.minute.toString().padLeft(2, '0')}:${currentAppointment.time!.second.toString().padLeft(2, '0')}'
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
                                  'العمر: ${currentAppointment.age}  \nالسكن: ${currentAppointment.neighborhood}'),
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
                                  onPressed: () =>
                                      _checkInAppointment(currentAppointment),
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
