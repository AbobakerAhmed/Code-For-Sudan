import 'package:flutter/material.dart';
import 'package:mobile_app/backend/doctor/doctor.dart';
import 'package:mobile_app/backend/registrar/appoinment.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

class BookedAppointmentsPage extends StatefulWidget {
  final Doctor doctor; // which docotr (look doctor.dart in the backend folder)
  const BookedAppointmentsPage(
      {super.key, required this.doctor}); // constructor

  @override
  State<BookedAppointmentsPage> createState() => _BookedAppointmentsPageState();
}

class _BookedAppointmentsPageState extends State<BookedAppointmentsPage>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestore = FirestoreService();

  /// this method load the checked in appointments from the database
  /// and put all checked in and checked out appointments in inAppointments/outAppointments
  Future<void> _fetchAppointments() async {
    inAppointments.addAll(await _firestore.getCheckedInAppointments(
        widget.doctor.state,
        widget.doctor.locality,
        widget.doctor.hospitalName,
        widget.doctor.department.name));
    outAppointments.addAll(await _firestore.getCheckedOutAppointments(
        widget.doctor.state,
        widget.doctor.locality,
        widget.doctor.hospitalName,
        widget.doctor.department.name));
  }

  ///this method load the checked in appointments for the doctor
  Future<void> _loadInitialAppointments() async {
    await _fetchAppointments(); // this sets inAppointments internally
    setState(() {}); // make sure UI updates after loading
  }

  List<Appointment> _sortAppointmentsByTime(List<Appointment> appointments) {
    appointments.sort((a, b) => a.time.compareTo(b.time));
    return appointments;
  } // _sortAppointmentsByTime

  List<String> appoi = ["الجديدة", "الجارية"];

  List<Appointment> inAppointments = [];
  List<Appointment> outAppointments = [];

  // List<Appointment> inAppointments = [
  //   Appointment(
  //     name: 'علي أحمد',
  //     gender: 'ذكر',
  //     age: '30',
  //     address: '123 شارع الرئيسي، مركز المدينة',
  //     phoneNumber: '555-1234',
  //     state: 'ولاية أ',
  //     locality: 'محلية أ',
  //     hospital: 'مستشفى المدينة',
  //     department: 'أمراض القلب',
  //     doctor: 'الدكتور سارة خان',
  //     time: DateTime(2023, 10, 15, 10, 30),
  //     isLocal: true,
  //   ),
  //   Appointment(
  //     name: 'فاطمة السيد',
  //     gender: 'أنثى',
  //     age: '28',
  //     address: '456 شارع البلوط، وسط المدينة',
  //     phoneNumber: '555-5678',
  //     state: 'ولاية ب',
  //     locality: 'محلية ب',
  //     hospital: 'عيادة وسط المدينة',
  //     department: 'طب الأطفال',
  //     doctor: 'الدكتور أحمد زكي',
  //     time: DateTime(2023, 10, 16, 14, 00),
  //     isLocal: false,
  //   ),
  //   Appointment(
  //     name: 'محمد صالح',
  //     gender: 'ذكر',
  //     age: '45',
  //     address: '789 شارع البلوط، منطقة العليا',
  //     phoneNumber: '555-8765',
  //     state: 'ولاية ج',
  //     locality: 'محلية ج',
  //     hospital: 'مركز الطب العليا',
  //     department: 'طب العظام',
  //     doctor: 'الدكتورة ليلى نور',
  //     time: DateTime(2023, 10, 17, 09, 15),
  //     isLocal: true,
  //   ),
  //   Appointment(
  //     name: 'عائشة حسن',
  //     gender: 'أنثى',
  //     age: '35',
  //     address: '321 شارع الصنوبر، الطرف الغربي',
  //     phoneNumber: '555-4321',
  //     state: 'ولاية د',
  //     locality: 'محلية د',
  //     hospital: 'مستشفى الطرف الغربي',
  //     department: 'أمراض النساء',
  //     doctor: 'الدكتور عمر فاروق',
  //     time: DateTime(2023, 10, 18, 11, 45),
  //     isLocal: false,
  //   ),
  //   Appointment(
  //     name: 'خالد إبراهيم',
  //     gender: 'ذكر',
  //     age: '50',
  //     address: '654 شارع القيقب، الجانب الشرقي',
  //     phoneNumber: '555-6789',
  //     state: 'ولاية هـ',
  //     locality: 'محلية هـ',
  //     hospital: 'مركز الصحة الجانب الشرقي',
  //     department: 'الأعصاب',
  //     doctor: 'الدكتورة نورة علي',
  //     time: DateTime(2023, 10, 19, 13, 00),
  //     isLocal: true,
  //   ),
  // ];

  // List<Appointment> outAppointments = [
  //   Appointment(
  //     name: 'سلمان العتيبي',
  //     gender: 'ذكر',
  //     age: '40',
  //     address: '987 شارع الورد، حي النخيل',
  //     phoneNumber: '555-1111',
  //     state: 'ولاية أ',
  //     locality: 'محلية أ',
  //     hospital: 'مستشفى النخيل',
  //     department: 'الطب الباطني',
  //     doctor: 'الدكتور فهد السعيد',
  //     time: DateTime(2023, 10, 20, 08, 30),
  //     isLocal: true,
  //   ),
  //   Appointment(
  //     name: 'نور الهدى',
  //     gender: 'أنثى',
  //     age: '26',
  //     address: '654 شارع الزهور، حي السلام',
  //     phoneNumber: '555-2222',
  //     state: 'ولاية ب',
  //     locality: 'محلية ب',
  //     hospital: 'مستشفى السلام',
  //     department: 'طب العيون',
  //     doctor: 'الدكتور عادل جابر',
  //     time: DateTime(2023, 10, 21, 15, 00),
  //     isLocal: false,
  //   ),
  //   Appointment(
  //     name: 'يوسف القحطاني',
  //     gender: 'ذكر',
  //     age: '32',
  //     address: '321 شارع النخيل، حي الهدى',
  //     phoneNumber: '555-3333',
  //     state: 'ولاية ج',
  //     locality: 'محلية ج',
  //     hospital: 'مستشفى الهدى',
  //     department: 'أمراض الجهاز التنفسي',
  //     doctor: 'الدكتورة مريم علي',
  //     time: DateTime(2023, 10, 22, 11, 15),
  //     isLocal: true,
  //   ),
  //   Appointment(
  //     name: 'ليلى الشمري',
  //     gender: 'أنثى',
  //     age: '29',
  //     address: '456 شارع السعادة، حي الأمل',
  //     phoneNumber: '555-4444',
  //     state: 'ولاية د',
  //     locality: 'محلية د',
  //     hospital: 'مستشفى الأمل',
  //     department: 'طب النساء والتوليد',
  //     doctor: 'الدكتور سامي العلي',
  //     time: DateTime(2023, 10, 23, 09, 45),
  //     isLocal: false,
  //   ),
  //   Appointment(
  //     name: 'عبدالله الزهراني',
  //     gender: 'ذكر',
  //     age: '38',
  //     address: '789 شارع الفرح، حي الزهور',
  //     phoneNumber: '555-5555',
  //     state: 'ولاية هـ',
  //     locality: 'محلية هـ',
  //     hospital: 'مستشفى الزهور',
  //     department: 'طب القلب',
  //     doctor: 'الدكتور سعيد القحطاني',
  //     time: DateTime(2023, 10, 24, 14, 30),
  //     isLocal: true,
  //   ),
  // ];

  List<Appointment> deletedAppointments =
      []; // New list for deleted appointments

  List<String> epidemics = [
    "الطاعون",
    "الكوليرا",
    "الإنفلونزا الإسبانية",
    "فيروس نقص المناعة البشرية/الإيدز",
    "فيروس كورونا",
    "ليس تشخيص لحالة وباء"
  ];

  int currentIndex =
      0; // To track the currently expanded appointment in "الجديدة"

  late TabController _tabController; // To controll over the tabs actions

  bool _addToMedicalHistory = false; // To give permission for adding or not

  void _onTabTapped(int index) {
    // Change the tab index
    _tabController.index = index;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadInitialAppointments();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _sortAppointmentsByTime(inAppointments);
    _sortAppointmentsByTime(outAppointments);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: appoi.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("المواعيد"),
            bottom: TabBar(
              controller: _tabController,
              onTap: _onTabTapped, // Handle tab taps directly
              tabs: appoi.map((d) => Tab(text: d)).toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildNewAppointmentsTab(),
              _buildOngoingAppointmentsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewAppointmentsTab() {
    return currentIndex < inAppointments.length
        ? Column(
            children: [
              _buildAppointmentDetails(inAppointments[currentIndex]),
              OverflowBar(
                alignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.lightBlue),
                    onPressed: () async {
                      await _firestore
                          .checkOutAppointment(inAppointments[currentIndex]);
                      setState(() {
                        // Remove the current appointment from the screen and show the next one
                        outAppointments.add(inAppointments[currentIndex]);
                        currentIndex++;
                      });
                    },
                    child: Text(
                      "التالي",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: Text("لا توجد مواعيد جديدة"),
          );
  }

  Widget _buildAppointmentDetails(Appointment appointment) {
    return ExpansionTile(
      collapsedBackgroundColor: Theme.of(context).cardColor,
      title: Text(
        appointment.name,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      children: [
        ListTile(
          title: Column(
            children: [
              Text(
                "(التفاصيل)",
                textAlign: TextAlign.center,
              ),
              Divider(),
            ],
          ),
          subtitle: Text(
            "• العمر: ${appointment.age}\n\n"
            "• العنوان: ${appointment.address}\n\n"
            "• رقم الهاتف: ${appointment.phoneNumber}\n\n"
            //"• المستشفى: ${appointment.hospital}\n\n"
            //"• القسم: ${appointment.department}\n\n"
            //"• الطبيب: ${appointment.doctor}\n\n"
            "• السجل الطبي: ${appointment.medicalHistory != null && appointment.medicalHistory!.isNotEmpty && appointment.medicalHistory![0] != 'None' ? appointment.medicalHistory!.map((e) => "- $e").join("\n") : "لا يوجد سجل"}\n\n"
            "• الوقت: ${appointment.time}\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildOngoingAppointmentsTab() {
    return Column(
      children: [
        Expanded(
          child: outAppointments.isEmpty
              ? Center(child: Text("لم يتم مقابلة مريض بعد"))
              : ListView.builder(
                  itemCount: outAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = outAppointments[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(appointment.name),
                        subtitle: Text("الوقت: ${appointment.time}"),
                        trailing: OutlinedButton(
                          child: Text(
                            "تشخيص",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _showEditDialog(context, appointment);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        Divider(
            color: Colors
                .lightBlue), // Divider to separate ongoing and deleted appointments
        Text("المواعيد التي تم تشخيصها:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Divider(color: Colors.lightBlue),
        Expanded(
          child: deletedAppointments.isEmpty
              ? Center(child: Text("لم يتم تشخيص مريض بعد"))
              : ListView.builder(
                  itemCount: deletedAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = deletedAppointments[index];
                    return Card(
                      color: Colors.green[700],
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        textColor: Colors.white,
                        title: Text(appointment.name),
                        subtitle: Text("التشخيص: ${appointment.isLocal}"),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.orange),
                          icon: Icon(Icons.edit),
                          label: Text(
                            'تعديل',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _showEditDialog(context, appointment);
                            // edit the doctor data (only name, phone number, password)
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // this is the dialog for editing the doctor data
  void _showEditDialog(BuildContext context, Appointment appointment) {
    final _formKey = GlobalKey<FormState>(); // global key
    String? epidemic;
    String? diagnosis;

    // that will be pobed up only when pressing the button
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Theme.of(context).primaryColorLight,
              title: Text(
                "المريض: ${appointment.name}",
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
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                          labelText: 'التشخيص',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onChanged: (value) => diagnosis = value,
                        validator: (value) {
                          // validate the name here
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال التشخيص';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10), // between name and epidemic

                      // chose epidemics
                      DropdownButtonFormField<String>(
                        iconEnabledColor:
                            Theme.of(context).secondaryHeaderColor,
                        iconDisabledColor:
                            Theme.of(context).secondaryHeaderColor,
                        value: epidemic,
                        validator: (value) {
                          // validate the epidemic here
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الوباء';
                          } // if
                          return null;
                        },
                        dropdownColor: Theme.of(context).cardColor,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        decoration: InputDecoration(
                          labelText: 'الوباء',
                          labelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )),
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        items: epidemics.map((g) {
                          return DropdownMenuItem(
                            value: g,
                            child: Text(g,
                                style:
                                    Theme.of(context).textTheme.displaySmall),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => epidemic = value);
                        },
                      ),

                      const SizedBox(
                          height:
                              10), // between epidemics and check box for adding to midical history or not

                      // show my medical history if the appointment is forMe appointment
                      if (appointment.forMe == true)
                        CheckboxListTile(
                            value: _addToMedicalHistory,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                EdgeInsetsGeometry.directional(end: 50),
                            title: Text(
                              "إضافة إلى سجل المريض",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            checkColor: Colors.white,
                            side: BorderSide(color: Colors.black),
                            activeColor: Theme.of(context).primaryColorDark,
                            onChanged: (value) {
                              setState(() {
                                _addToMedicalHistory = value!;
                                if (_addToMedicalHistory == true) {
                                  print(appointment.medicalHistory);
                                  if (appointment.medicalHistory![0] ==
                                      "None") {
                                    print('it works');
                                    appointment.medicalHistory = [];
                                  }
                                  appointment.medicalHistory!.add(diagnosis!);
                                }
                              });
                            }),

                      // free space
                      const SizedBox(height: 10),
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
                    'تأكيد التشخيص',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // there is a problem here
                  // when adding the new info to the same page it is not be shown directly
                  onPressed: () async {
                    // check the info
                    // also here you can add the functionality on the databse, DONT FORGET TO USE (await) KEYWORD TOO!

                    if (_formKey.currentState!.validate()) {
                      if (_addToMedicalHistory == true &&
                          appointment.forMe == true) {
                        await _firestore.updateCitizen(appointment.phoneNumber,
                            {"medicalHistory": appointment.medicalHistory!});
                      }
                      deletedAppointments.add(appointment);
                      outAppointments.remove(appointment);
                      Navigator.pop(context);
                      _onTabTapped(1);
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
}
