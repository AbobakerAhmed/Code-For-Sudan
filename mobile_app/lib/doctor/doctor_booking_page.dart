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
  bool _isLoading = true;
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

    diagnosedAppointments.addAll(await _firestore.getTodayDiagnosedAppointments(
        widget.doctor.state,
        widget.doctor.locality,
        widget.doctor.hospitalName,
        widget.doctor.department.name));
  }

  ///this method load the checked in appointments for the doctor
  Future<void> _loadInitialAppointments() async {
    await widget.doctor.fetchDepartment(); // Ensure department is loaded first
    await _fetchAppointments(); // this sets inAppointments internally
    setState(() {
      _isLoading = false;
    }); // make sure UI updates after loading
  }

  List<Appointment> _sortAppointmentsByTime(List<Appointment> appointments) {
    appointments.sort((a, b) => a.time.compareTo(b.time));
    return appointments;
  } // _sortAppointmentsByTime

  List<String> appoi = ["الجديدة", "الجارية"];

  List<Appointment> inAppointments = [];
  List<Appointment> outAppointments = [];

  List<Appointment> diagnosedAppointments =
      []; // New list for diagnosed appointments

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

    //display a loading screen until inAppointments or outAppointments get thier appointments
    if (_isLoading) {
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
                  ])),
            )),
      );
    }

    //if there is at least one appointment
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

                      await _firestore
                          .checkOutAppointment(inAppointments[currentIndex]);
                      await _firestore.deleteCheckedInAppointment(
                          inAppointments[currentIndex]);
                      setState(() {
                        // Remove the current appointment from the screen and show the next one
                        outAppointments.add(inAppointments[currentIndex]);
                        currentIndex++;
                      });
                      Navigator.pop(context);
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
    final timeInSudan = appointment.time.add(const Duration(hours: 2));

    final hourIn12HourFormat =
        (timeInSudan.hour % 12 != 0) ? timeInSudan.hour % 12 : 12;

    //we added 2 hours to convert time from utc into utc+2
    final String timeString =
        '${hourIn12HourFormat.toString().padLeft(2, '0')}:${timeInSudan.minute.toString().padLeft(2, '0')}:${timeInSudan.second.toString().padLeft(2, '0')} ${timeInSudan.hour >= 12 ? 'PM' : 'AM'}';

    final String dateString =
        '${timeInSudan.year.toString()}/${timeInSudan.month.toString().padLeft(2, '0')}/${timeInSudan.day.toString().padLeft(2, '0')}';

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
            "• السجل الطبي: \n${appointment.medicalHistory != null && appointment.medicalHistory!.isNotEmpty && appointment.medicalHistory![0] != 'None' ? appointment.medicalHistory!.map((e) => "- $e").join("\n") : "لا يوجد سجل"}\n\n"
            "• اليوم: $dateString\n\n"
            "• الوقت: $timeString\n\n",
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

                    final timeInSudan =
                        appointment.time.add(const Duration(hours: 2));

                    final hourIn12HourFormat = (timeInSudan.hour % 12 != 0)
                        ? timeInSudan.hour % 12
                        : 12;

                    final String timeString =
                        '${hourIn12HourFormat.toString().padLeft(2, '0')}:${timeInSudan.minute.toString().padLeft(2, '0')}:${timeInSudan.second.toString().padLeft(2, '0')} ${timeInSudan.hour >= 12 ? 'PM' : 'AM'}';

                    final String dateString =
                        '${timeInSudan.year.toString()}/${timeInSudan.month.toString().padLeft(2, '0')}/${timeInSudan.day.toString().padLeft(2, '0')}';

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(appointment.name),
                        subtitle:
                            Text("اليوم: $dateString\nالوقت: $timeString"),
                        trailing: OutlinedButton(
                          child: Text(
                            "تشخيص",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            await _showEditDialog(context, appointment);
                            setState(() {});
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
        Text("المواعيد التي تم تشخيصها اليوم:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Divider(color: Colors.lightBlue),
        Expanded(
          child: diagnosedAppointments.isEmpty
              ? Center(child: Text("لم يتم تشخيص مريض بعد"))
              : ListView.builder(
                  itemCount: diagnosedAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = diagnosedAppointments[index];
                    return Card(
                      color: Colors.green[700],
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        textColor: Colors.white,
                        title: Text(appointment.name),
                        subtitle: Text(
                            "التشخيص: ${appointment.medicalHistory!.last}"),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.orange),
                          icon: Icon(Icons.edit),
                          label: Text(
                            'تعديل',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            await _showEditDialog(context, appointment);
                            setState(() {});
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

  // this is the dialog for editing the appointment medical history
  Future<void> _showEditDialog(
      BuildContext context, Appointment appointment) async {
    final _formKey = GlobalKey<FormState>();
    bool _addToMedicalHistory = false;
    String? newDiagnosis;
    List<String> deletedDiagnosis = [];
    String? epidemic;

    // Copy existing diagnoses for safe editing
    List<String> diagnoses = (appointment.medicalHistory != null &&
            !(appointment.medicalHistory!.length == 1 &&
                appointment.medicalHistory!.first == "None"))
        ? List.from(appointment.medicalHistory!)
        : [];

    void _editDiagnosis(BuildContext context, int index,
        void Function(void Function()) setParent) {
      String edited = diagnoses[index];
      TextEditingController controller = TextEditingController(text: edited);

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("تعديل التشخيص"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "التشخيص الجديد"),
            ),
            actions: [
              TextButton(
                child: Text("إلغاء", style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.pop(ctx),
              ),
              ElevatedButton(
                child: Text("حفظ"),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    setParent(() {
                      diagnoses[index] = controller.text.trim();
                    });
                    Navigator.pop(ctx);
                  }
                },
              )
            ],
          );
        },
      );
    }

    void _removeDiagnosis(BuildContext context, int index,
        void Function(void Function()) setParent) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("تأكيد الحذف"),
          content: Text("هل أنت متأكد أنك تريد حذف هذا التشخيص؟"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("إلغاء", style: TextStyle(color: Colors.grey))),
            TextButton(
                onPressed: () {
                  setParent(() {
                    deletedDiagnosis.add(diagnoses[index]);
                    diagnoses.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text("حذف", style: TextStyle(color: Colors.red)))
          ],
        ),
      );
    }

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
                    children: [
                      if (diagnoses.isNotEmpty) ...[
                        Text("السجل الطبي",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ...diagnoses.asMap().entries.map((entry) {
                          int index = entry.key;
                          String diagnosis = entry.value;
                          return ListTile(
                            title: Text(diagnosis),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _editDiagnosis(context, index, setState);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _removeDiagnosis(context, index, setState);
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: "تشخيص جديد"),
                        onChanged: (val) => newDiagnosis = val,
                        validator: (val) {
                          if ((val == null || val.trim().isEmpty) &&
                              diagnoses.isEmpty) {
                            return "الرجاء إدخال تشخيص واحد على الأقل";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: epidemic,
                        items: epidemics
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => epidemic = val),
                        decoration: InputDecoration(labelText: "الوباء"),
                        validator: (val) => val == null || val.isEmpty
                            ? "الرجاء اختيار الوباء"
                            : null,
                      ),
                      const SizedBox(height: 10),
                      if (appointment.forMe == true)
                        CheckboxListTile(
                          value: _addToMedicalHistory,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text("إضافة إلى سجل المريض"),
                          activeColor: Theme.of(context).primaryColorDark,
                          checkColor: Colors.white,
                          onChanged: (val) =>
                              setState(() => _addToMedicalHistory = val!),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("إلغاء", style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text("تأكيد التشخيص",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (newDiagnosis != null &&
                          newDiagnosis!.trim().isNotEmpty) {
                        diagnoses.add(newDiagnosis!.trim());
                      }

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

                      bool didChange = false;
                      Appointment? oldDiagnosedAppointment;

                      final diagnosedExists = await _firestore
                          .checkDiagnosedAppointmentExist(appointment);

                      if (diagnosedExists) {
                        await _firestore
                            .deleteDiagnosedAppointment(appointment);

                        oldDiagnosedAppointment = (diagnosedAppointments
                                    .where((appo) =>
                                        appo.phoneNumber ==
                                            appointment.phoneNumber &&
                                        appo.name == appointment.name)
                                    .isNotEmpty ==
                                true)
                            ? diagnosedAppointments
                                .where((appo) =>
                                    appo.phoneNumber ==
                                        appointment.phoneNumber &&
                                    appo.name == appointment.name)
                                .first
                            : null;

                        if (oldDiagnosedAppointment != null &&
                            !outAppointments
                                .contains(oldDiagnosedAppointment)) {
                          diagnosedAppointments.remove(oldDiagnosedAppointment);
                          didChange = true;
                        }

                        if (outAppointments.contains(appointment)) {
                          await _firestore
                              .deleteCheckedOutAppointment(appointment);
                          outAppointments.remove(appointment);
                          didChange = true;
                        }
                      } else {
                        await _firestore
                            .deleteCheckedOutAppointment(appointment);
                        outAppointments.remove(appointment);
                        didChange = true;
                      }

                      appointment.medicalHistory = diagnoses;

                      //refreash the time of the appointment so it can be added to the today diagnosed appointment
                      appointment.time = DateTime.now().toUtc();

                      if (_addToMedicalHistory && appointment.forMe == true) {
                        await _firestore.updateCitizenMedicalHistory(
                            appointment.phoneNumber,
                            appointment.medicalHistory!,
                            deletedDiagnosis);
                      }

                      await _firestore.diagnoseAppointment(appointment);
                      diagnosedAppointments.add(appointment);

                      if (didChange) {
                        setState(() {});
                      }

                      Navigator.pop(context); // close loading
                      Navigator.pop(context); // close dialog
                      _onTabTapped(1);
                    }
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
