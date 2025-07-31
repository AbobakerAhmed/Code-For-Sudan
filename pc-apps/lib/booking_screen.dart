import 'package:flutter/material.dart';
import 'package:pc_apps/Backend/appointment.dart';
import 'package:pc_apps/Backend/hospital.dart';
import 'package:pc_apps/global_ui.dart';
import 'package:pc_apps/Backend/diagnosed_appointment.dart';
import 'Backend/testing_data.dart';
/*
Issues
  1- Showing List of appointments
  2- let hospital management together (staff, hospital details)
  3- let appointments alone
  3- let reporting alone
  4- make send/receive notification alone
 */



class BookingsScreen extends StatefulWidget {
  BookingsScreen({super.key, required this.hospital});
  Hospital hospital;

  @override
  State<BookingsScreen> createState() => _BookingsScreenState(hospital: hospital);
}

class _BookingsScreenState extends State<BookingsScreen> {
  _BookingsScreenState({required this.hospital});
  Hospital hospital;
  String? _selectedAppointmentsType;
  String? _selectedDepartment = "الكل" ;
  DateTimeRange? _selectedDateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now()); // default today only


  final List<String> _appointmentsTypes = [
    'الحجوزات الجديدة',
    'الحجوزات المشخصة',
    'الحجوزات المشخصة بالأوبئة',
    'الحجوزات الملغية',
  ]; // New, Confirmed, Cancelled Bookings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
         backgroundColor:
            Colors.transparent, // Transparent to blend with background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align title to the right
          children: [
            Text(
              'الحجوزات', // Bookings
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo', // Example font
              ),
              textDirection: TextDirection.rtl, // Right-to-left for Arabic
            ),
            SizedBox(width: 10), // Spacing between text and icon
            Icon(
              Icons.calendar_month, // Placeholder for calendar with check/cross
              color: Colors.deepPurple,
              size: 35,
            ),
          ],
        ),
        titleSpacing: 0, // Remove default title spacing
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const Divider(thickness: 1), // the line under appbar

            // Filters
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection:
                Axis.horizontal, // Allow horizontal scrolling for filters
                child:Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Align contents to the right
                  children: [
                    buildLabel("القسم"),
                    const SizedBox(width: 8),
                    buildFilterDropdown(
                        hint: "القسم",
                        value: _selectedDepartment,
                        items: hospital.getDepartmentsNames(),
                        onChanged: (selectedDepartment){
                          setState(() {
                            _selectedDepartment = selectedDepartment;
                          });
                        }
                    ),

                    const SizedBox(width: 20),
                    buildLabel("نوع الحجوزات"),
                    const SizedBox(width: 8),
                    buildFilterDropdown(
                        hint: "نوع الحجوزات",
                        value: _selectedAppointmentsType,
                        items: _appointmentsTypes,
                        onChanged: (selectedDepartment){
                          setState(() {
                            _selectedAppointmentsType = selectedDepartment;
                          });
                        }
                    ),

                    const SizedBox(width: 20),
                    buildLabel("الفترة الزمنية"),
                    const SizedBox(width: 8),
                    buildDateRangeSelector(
                        context: context,
                        selectedRange: _selectedDateRange,
                        onRangeSelected: (newRange){
                          setState(() {
                            _selectedDateRange = newRange;
                          });
                        }
                    )
                  ],


                ),
              ),
            ),

            // Report Data
            Expanded(child: _body()),

          ],
        ),
      ),
      );
  }
  Widget _body(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // if he dosen't chose type yet
            if( _selectedAppointmentsType == null) ... [
                Center(
                    child: Icon(Icons.assignment, color: Colors.blueGrey, size: 100,),
                ),
            ]
            // new appointments
            else if(_selectedAppointmentsType == _appointmentsTypes[0]) ... [
              _buildAppointmentsTable()
            ]
            // diagnosed appointments
            else if(_selectedAppointmentsType == _appointmentsTypes[1]) ... [
              _buildDiagnosedAppointmentsTable()
              ]
              // diagnosed appointments with epidemics
              else if(_selectedAppointmentsType == _appointmentsTypes[2]) ... [
                  _buildEpidemicAppointmentsTable() // same as diagnosedAppointmentTable with a different query
                ]
                // canceled appointments
                else if(_selectedAppointmentsType == _appointmentsTypes[3]) ... [
                    _buildcanseldAppointmentsTable() // same as new appointment with a different query
                  ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTable(){
    // fetch appointments form database here
    List<Appointment> appointments = testingNewAppointments;

      if(appointments.isEmpty)
          return Center(
            child: Text("لا يوجد حجوزات جديدة", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 28),),
          );


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 50,
        dataRowHeight: 48.0,
        border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey), // Add borders for clarity
            outside: BorderSide(color: Colors.blue, width: 2) // Outside Border
        ),
        columns: const [
          DataColumn(
            label: Text(
              'القسم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // Department
          DataColumn(
            label: Text(
              'الطبيب',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(
              'الاسم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // Outpatients
          DataColumn(
            label: Text(
              'النوع',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // New Cases
          DataColumn(
            label: Text(
              'العمر',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // Hospitalized Cases
          DataColumn(
            label: Text(
              'العنوان',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // Recovery Cases
          DataColumn(
            label: Text(
              'رقم الهاتف',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'حجز لنفسه؟',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: _buildDataRows(appointments),
      ),
    );

  }

  List<DataRow> _buildDataRows(List<Appointment> appointments){
    List<DataRow>? dataInDataRowForm = [];
    for(int i =0; i<appointments.length; i++) {
      dataInDataRowForm.add(_buildAppointmentRow(appointments[i]));
    }
    return dataInDataRowForm;
  } //_buildDataRows
  DataRow _buildAppointmentRow(Appointment appointment) {
    return DataRow(

      cells: [
        DataCell(Center(child: Text(appointment.getPatientDepartment()))),
        DataCell(Center(child: Text(appointment.getPatientDoctor()))),
        DataCell(Center(child: Text(appointment.getPatientName()))),
        DataCell(Center(child: Text(appointment.getPatientGender()))),
        DataCell(Center(child: Text(appointment.getPatientAge().toString()))),
        DataCell(Center(child: Text(appointment.getPatientAddress()))),
        DataCell(Center(child: Text(appointment.getPatientPhone()))),
        DataCell(Center(child: appointment.isSelfAppointment() ? Icon(Icons.check_circle , color: Colors.green,) : Icon(Icons.cancel , color: Colors.red))),
      ],

    );
  } // _buildClinicalRow


  Widget _buildDiagnosedAppointmentsTable(){

    // fetch appointments form database here
    List<DiagnosedAppointment> diagnosedAppointment = testingDiagnosedAppointment;

    if(diagnosedAppointment.isEmpty)
      return Expanded(
        child: Container(
          alignment : Alignment.center,
          child: Text("لا يوجد حجوزات مشخصة", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 28),),
        ),
      );


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 50,
        dataRowHeight: 48.0,
        border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey), // Add borders for clarity
            outside: BorderSide(color: Colors.blue, width: 2) // Outside Border
        ),
        columns: const [
          DataColumn(
            label: Text(
              'القسم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'الطبيب',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(
              'الاسم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'النوع',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'العمر',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'العنوان',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'رقم الهاتف',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'حجز لنفسه؟',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'الأمراض',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'الأوبئة إن وجدت',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: _buildDiagnosedDataRows(diagnosedAppointment),
      ),
    );

  }
  List<DataRow> _buildDiagnosedDataRows(List<DiagnosedAppointment> appointments){
    List<DataRow>? dataInDataRowForm = [];
    for(int i =0; i<appointments.length; i++) {
      dataInDataRowForm.add(_buildDiagnosedDataRow(appointments[i]));
    }
    return dataInDataRowForm;
  } //_buildDataRows
  DataRow _buildDiagnosedDataRow(DiagnosedAppointment appointment) {
    return DataRow(
      cells: [
        DataCell(Center(child: Text(appointment.getPatientDepartment()))),
        DataCell(Center(child: Text(appointment.getPatientDoctor()))),
        DataCell(Center(child: Text(appointment.getPatientName()))),
        DataCell(Center(child: Text(appointment.getPatientGender()))),
        DataCell(Center(child: Text(appointment.getPatientAge().toString()))),
        DataCell(Center(child: Text(appointment.getPatientAddress()))),
        DataCell(Center(child: Text(appointment.getPatientPhone()))),
        DataCell(Center(child: appointment.isSelfAppointment()
            ? Icon(Icons.check_circle , color: Colors.green,)
            : Icon(Icons.cancel , color: Colors.red))),
        DataCell(Center(child: Text(appointment.getDiseases() == null ? "لا يوجد":
          appointment.getDiseases().toString().trim().substring(
              1,
              appointment.getDiseases().toString().trim().length-1)
        ))),
        DataCell(Center(child: Text(appointment.getEpidemic() ?? "لا يوجد"))),
      ],

    );
  } // _buildClinicalRow


  Widget _buildEpidemicAppointmentsTable(){

    // fetch appointments form database here
    List<DiagnosedAppointment> diagnosedAppointmentWithEpidemincs = diagnosedAppointmentWithEpidemics;

    if(diagnosedAppointmentWithEpidemincs.isEmpty)
      return Container(
        alignment : Alignment.center,
        child: Text("لا يوجد حجوزات مشخصة بأوبئة", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 28),),
      );


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 50,
        dataRowHeight: 48.0,
        border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey), // Add borders for clarity
            outside: BorderSide(color: Colors.blue, width: 2) // Outside Border
        ),
        columns: const [
          DataColumn(
            label: Text(
              'القسم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'الطبيب',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(
              'الاسم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'النوع',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'العمر',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'العنوان',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'رقم الهاتف',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'حجز لنفسه؟',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'الأمراض',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'الأوبئة إن وجدت',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: _buildDiagnosedDataRows(diagnosedAppointmentWithEpidemincs),
      ),
    );

  }
  Widget _buildcanseldAppointmentsTable(){
    // fetch appointments form database here
    List<Appointment> appointments = testingCanseldAppointments;

    if(appointments.isEmpty)
      return Center(
        child: Text("لا يوجد حجوزات جديدة", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 28),),
      );


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 50,
        dataRowHeight: 48.0,
        border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey), // Add borders for clarity
            outside: BorderSide(color: Colors.blue, width: 2) // Outside Border
        ),
        columns: const [
          DataColumn(
            label: Text(
              'القسم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // Department
          DataColumn(
            label: Text(
              'الطبيب',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: Text(
              'الاسم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // Outpatients
          DataColumn(
            label: Text(
              'النوع',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // New Cases
          DataColumn(
            label: Text(
              'العمر',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // Hospitalized Cases
          DataColumn(
            label: Text(
              'العنوان',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ), // Recovery Cases
          DataColumn(
            label: Text(
              'رقم الهاتف',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'حجز لنفسه؟',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: _buildDataRows(appointments),
      ),
    );

  }

}
