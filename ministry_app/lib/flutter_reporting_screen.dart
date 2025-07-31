import 'package:flutter/material.dart';
import 'global_ui.dart';
import 'package:ministry_app/Backend/ministry_employee.dart';
import 'package:ministry_app/Backend/report.dart';
import 'package:ministry_app/Backend/global_var.dart';

/*
Issues:
  1- link with database to obtain clinical reports and epidemic reports
  2- make sure fields in the table are displayed in the truth way
  3- calculate % in the epidemic report
  5- show dashboard feature is in progress and it will have a predictor AI in the next version
  6- try to make the row of any epidemic more that its threshold to be red
  7- after the doctor diagnose any citizen by any epidemic, the map of epidemic cases in ministry office
      will be incremented, and if the new count of cases >= threshold (in global var) , then send an important notification
      to the ministry that is there is an epidemic in that locality, and show option to send notification to hospitals and citizens
      in that locality,
      when pressing any of these options, it will take him to sending notificaion page with setting filters, and intial values:
        title : the (epidemic) is starting (ينتشر :')) in (locality) of state (state)
        massage: different initial massage depending on hospitals , or citizens?
        important notification
*/

class ReportingScreen extends StatefulWidget {
  final MinistryEmployee employee;
  String? initialReportType;
  String? initialState;
  String? initialLocality;
  String? initialHospital;
  DateTimeRange? initialDateTimeRange;

  ReportingScreen({
    super.key,
    required this.employee,
    this.initialReportType,
    this.initialState,
    this.initialLocality,
    this.initialHospital,
    this.initialDateTimeRange
  });

  @override
  State<ReportingScreen> createState() => _ReportingScreenState(
    employee: employee,
      reportType:  this.initialReportType,
      state:  this.initialState,
      locality:  this.initialLocality,
      hospital:  this.initialHospital,
      selectedDateRange:  this.initialDateTimeRange
  );
}

class _ReportingScreenState extends State<ReportingScreen> {

  late final MinistryEmployee employee;
  String? _selectedReportType;
  late String _selectedState;
  late String _selectedLocality;
  late String _selectedHospital;
  late DateTimeRange _dateTimeRange;

  _ReportingScreenState({
    required this.employee,
    String? reportType,
    String? state,
    String? locality,
    String? hospital,
    DateTimeRange? selectedDateRange
  }){
    _selectedReportType = reportType;
    _selectedHospital  = hospital ?? 'الكل';
    _selectedState = state ?? this.employee.getState();
    _selectedLocality = locality ?? this.employee.getLocality();
    _dateTimeRange = selectedDateRange ?? DateTimeRange(start: DateTime(DateTime.now().year), end: DateTime.now());
    initState();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(
              context,
            ); // Go back to the previous screen (Dashboard)
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'التقارير', // Reports (Arabic)
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 16),
            Icon(
              Icons.assignment,
              color: Colors.blue,
              size: 28,
            ), // Reports icon
            SizedBox(width: 8),

          ],

        ),
        titleSpacing: 0, // Remove default title spacing for custom title layout
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Type
                    buildFilterDropdown(
                      hint: 'نوع التقرير', // Type...
                      value: _selectedReportType,
                      items: _reportTypes,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedReportType = newValue;
                        });
                      },
                    ),

                    const SizedBox(width: 8), // Between Type & State

                    // State
                    buildFilterDropdown(
                      hint: 'الولاية...', // State...
                      value: _selectedState,
                      items: this.employee.getState() == "الكل" ? g_states : [this.employee.getState()],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedState = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),

                    // Locality
                    buildFilterDropdown(
                      hint: 'المحلية...', // Locality...
                      value: _selectedLocality,
                      items: this.employee.getLocality() == "الكل"
                          ? (g_localities[_selectedState] ?? [])
                          : [this.employee.getLocality()],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLocality = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),

                    // Hospital
                    buildFilterDropdown(
                      hint: 'المستشفى...', // Hospital...
                      value: _selectedHospital,
                      items: _hospitals,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedHospital = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),

                    buildDateRangeSelector(
                      context: context,
                      selectedRange: _dateTimeRange,
                      onRangeSelected: (_dateTimeRange) {
                        print("");
                      },)
                  ],
                ),
              ),
            ),

            // Report Data
            Expanded(child: _buildReportContent()),

            // Dashboard Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print('عرض ال DashBard tapped'); // Show Dashboard (Arabic)
                    // Navigate back to Dashboard or show relevant data
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'عرض ال DashBard', // Show Dashboard (Arabic)
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }






  Widget _buildReportContent() {
    // This widget will display different content based on _selectedReportType
    // For now, it will show a placeholder or a simple table.

    // Medical Report Selected
    if (_selectedReportType == 'التقارير الدورية') {
      ClinicalReport fetchedClinicalReport = this.employee.fetchClinicalReport(_selectedState, _selectedLocality, _selectedHospital, _dateTimeRange);
      return SingleChildScrollView(child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
      child: _clinicalReportAsTable(fetchedClinicalReport),));
    }

    // Epidemics Selected
    else if (_selectedReportType == 'تقارير الأوبئة') {
      return SingleChildScrollView(child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildEpidemicReportTable()));
    }
    // Epidemics Selected
    else if (_selectedReportType == 'تقارير الكادر الطبي') {
      return SingleChildScrollView(child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: _buildStaffReportTable()));
    }
    // Not selected
    else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'التقارير', // Reports (Arabic)
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      );
    }
  }

  // Clinical Reports
  DataTable _clinicalReportAsTable(ClinicalReport mergedClinicalReport){
    return DataTable(
      columnSpacing: 50,
      dataRowHeight: 48.0,
      border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.grey), // Add borders for clarity
          outside: BorderSide(color: Colors.blue, width: 2) // Outside Border
      ),
      columns: _clinicalReportHeader(),
      rows: _buildDataRows(mergedClinicalReport),
    );
  } // ReportAsTable
  List<DataColumn> _clinicalReportHeader(){
    return const [
      // ["القسم", "المقابلات", "حالات جديدة", "الحالات المنومة", "حالات الخروج","العمليات الناجحة", "العمليات الفاشلة" ,"العمليات الكلية", "الوفيات
      DataColumn(
        label: Text(
          'القسم',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // Department
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Text(
          'المقابلات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // Outpatients
      DataColumn(
        label: Text(
          'حالات جديدة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // New Cases
      DataColumn(
        label: Text(
          'الحالات المنومة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // Hospitalized Cases
      DataColumn(
        label: Text(
          'حالات الخروج',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // Recovery Cases
      DataColumn(
        label: Text(
          'العمليات الناجحة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // Successful Operations
      DataColumn(
        label: Text(
          'العمليات الفاشلة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // UnSuccessful Operations
      DataColumn(
        label: Text(
          'العمليات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // Total Operations
      DataColumn(
        label: Text(
          'حالات الوفاه',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // Death Cases
      DataColumn(
        label: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
      ), // View Details
    ];
  } // _clinicalReportHeader
  List<DataRow> _buildDataRows(ClinicalReport report){
    List<DataRow>? dataInDataRowForm = [];
    for(int i =0; i<report.getData().length; i++) {
      dataInDataRowForm.add(_buildClinicalRow(report.getData()[i]));
    }
    return dataInDataRowForm;
  } //_buildDataRows
  DataRow _buildClinicalRow(ClinicalRecord record) {
    return DataRow(

      cells: [
        DataCell(Center(child: Text(record.getDepartment()))),
        DataCell(Center(child: Text(record.getOutPatients().toString()))),
        DataCell(Center(child: Text(record.getAdmissions().toString()))),
        DataCell(Center(child: Text(record.getInpatientCount().toString()))),
        DataCell(Center(child: Text(record.getDischarges().toString()))),
        DataCell(Center(child: Text(record.getSuccessfulSurgeries().toString()))),
        DataCell(Center(child: Text(record.getFailedSurgeries().toString()))),
        DataCell(Center(child: Text(record.getTotalSurgeries().toString()))),
        DataCell(Center(child: Text(record.getDeaths().toString()))),
        DataCell(
          TextButton(
            onPressed: () {
              // go to the hospital DB and fetch appointments data with that condition
              print('View Details tapped for ${record.getDepartment()}');
            },
            child: const Text(
              'عرض التفاصيل',
              style: TextStyle(color: Colors.blue),
            ), // View Details
          ),
        ),
      ],

    );
  } // _buildClinicalRow

// Epidemic Reports:
// Edit them with the new data structure
  static const double _indexColumnWidth = 40;
  static const double _diseaseColumnWidth = 180.0;
  static const double _defaultColumnWidth = 40;
  Widget _buildEpidemicReportTable() {
// link with the database here to bring clinical reports depending on filters

    EpidemicReport mergedEpidemicReport = this.employee.fetchEpidemicReport(_selectedState, _selectedLocality, _selectedHospital, _dateTimeRange); // simulate data coming form database
    return Column(
      children: [
        // Row for the absolute top-level headers: الاصابات, الدخولات, الوفيات
        // First row: الاصابات, الدخولات, الوفيات
        Row(
          children: [
            // Empty space for numbering and disease column, with right border
            _buildHeaderCell(
                _indexColumnWidth + _diseaseColumnWidth,
                "",
                border: Border(), // No borders
                color: Colors.white
            ),
            // الاصابات (Current Patients)
            _buildHeaderCell(
                _defaultColumnWidth * 8, // 8 sub-columns below it
                "الاصابات",
                border: Border(
                    right: BorderSide(color: Colors.blue, width: 2),
                    top: BorderSide(color: Colors.blue,width: 2),
                    bottom: BorderSide(color: Colors.blue)
                )

            ),
            // الدخولات (New Cases / Admissions)
            _buildHeaderCell(
                _defaultColumnWidth * 8, // 8 sub-columns below it
                "الدخولات",
                border: Border(
                    right: BorderSide(color: Colors.blue, width: 2),
                    top: BorderSide(color: Colors.blue,width: 2),
                    bottom: BorderSide(color: Colors.blue)
                )
            ),
            // الوفيات (Deaths) - No right border, but has bottom border
            _buildHeaderCell(
                _defaultColumnWidth * 8, // 8 sub-columns below it
                "الوفيات",
                border: Border(
                    left: BorderSide(color: Colors.blue, width: 2),
                    right: BorderSide(color: Colors.blue, width: 2),
                    top: BorderSide(color: Colors.blue,width: 2),
                    bottom: BorderSide(color: Colors.blue)
                )
            ),

          ],
        ),
        // Second row: أقل من 5, أكبر من 5, المجموع, الكلي, % (repeated)
        Row(
          children: [
            // Empty space for numbering and disease column, with right border
            _buildHeaderCell(
                _indexColumnWidth + _diseaseColumnWidth,
                "",
                border: Border(),
                color: Colors.white
            ),

            // Sub-headers for Current Patients
            _buildHeaderCell(
              _defaultColumnWidth * 2, // 2 sub-columns below it
              "أقل من 5",
              border: Border(
                right: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            _buildHeaderCell(
                _defaultColumnWidth * 2, // 2 sub-columns below it
                "أكثر من 5"
            ),
            _buildHeaderCell(
                _defaultColumnWidth * 4, // 4 sub-columns below it
                "المجموع"
            ),


            // Sub-headers for New Cases
            _buildHeaderCell(
              _defaultColumnWidth * 2, // 2 sub-columns below it
              "أقل من 5",
              border: Border(
                right: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            _buildHeaderCell(
                _defaultColumnWidth * 2, // 2 sub-columns below it
                "أكثر من 5"
            ),
            _buildHeaderCell(
                _defaultColumnWidth * 4, // 4 sub-columns below it
                "المجموع"
            ),


            // Sub-headers for Deaths
            _buildHeaderCell(
              _defaultColumnWidth * 2, // 2 sub-columns below it
              "أقل من 5",
              border: Border(
                right: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            _buildHeaderCell(
                _defaultColumnWidth * 2, // 2 sub-columns below it
                "أكثر من 5"
            ),
            _buildHeaderCell(
              _defaultColumnWidth * 4, // 4 sub-columns below it
              "المجموع",
              border: Border(
                right: BorderSide(color: Colors.blue),
                left: BorderSide(color: Colors.blue, width: 2),
              ),
            ),


          ],
        ),
        DataTable(
          showBottomBorder: true,
          columnSpacing: 0, // Set to 0 because we're handling spacing with FixedColumnWidths
          dataRowHeight: 40.0,
          headingRowHeight: 60.0, // s height is for the simplified headers (ذ, ث, الكلي, %)
          border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey), // Add borders for clarity
              outside: BorderSide(color: Colors.blue, width: 2) // Outside Border
          ),
          columns: _buildEpidemicHeader(),
          rows: _buildEpidemicRows(mergedEpidemicReport),
        ),
      ],
        );
  }
  Container _buildHeaderCell(double width,String text, {BoxBorder? border, Color? color}){
    if(border == null)
      border = const Border(
        right: BorderSide(color: Colors.blue),
        );
    if(color == null) color = Color.fromARGB(255, 225, 225, 225);
    return Container(
        width: width,
        height: 40.0,
        decoration: BoxDecoration(
            border: border,
            color: color
        ),
        child: Center(
            child: Text( "$text",
                style: const TextStyle(
                    fontWeight: FontWeight.bold
                )
            )
        )
    );
  }
  List<DataColumn> _buildEpidemicHeader(){
    return const [
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_indexColumnWidth),
        label: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
      ), // Empty for numbering
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_diseaseColumnWidth),
        label: Text(
          'المرض',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Epidemic

// current patients
      // < 5
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // males < 5 current patients
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // females < 5 current patients
      // 5 >
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // males > 5 current patients
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // females > 5 current patients
      // totals
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total males current patients
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total females current patients
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'الكلي',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total current patients
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          '%',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // % of current patients


// new cases
      // < 5
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // males < 5 new cases
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // females < 5 new cases
      // 5 >
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // males > 5 new cases
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // females > 5 new cases
      // totals
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total males new cases
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total females new cases
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'الكلي',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total new cases
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          '%',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // % of new cases


// Deaths
      // < 5
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // males < 5 deaths
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // females < 5 deaths
      // 5 >
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // males > 5 deaths
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // females > 5 deaths
      // totals
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ذ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total males deaths
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'ث',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total females deaths
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          'الكلي',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // Total deaths
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        columnWidth: FixedColumnWidth(_defaultColumnWidth),
        label: Text(
          '',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ), // % of deaths
    ];
  }
  List<DataRow> _buildEpidemicRows(EpidemicReport report){
    List<DataRow>? dataInDataRowForm = [];
    for(int i =0; i<report.getData().length; i++) {
      dataInDataRowForm.add(_buildEpidemicDataRow(report.getData()[i]));
    }
    return dataInDataRowForm;
  }
  DataRow _buildEpidemicDataRow(EpidemicRecord record) {

    // Sums of current patients
    int currentPatientsSum = record.getCurrentPatientsMaleUnder5() + record.getCurrentPatientsMaleAbove5() + record.getCurrentPatientsFemaleUnder5() + record.getCurrentPatientsFemaleAbove5();
    int maleCurrentPatientsSum = record.getCurrentPatientsMaleUnder5() + record.getCurrentPatientsMaleAbove5();
    int femaleCurrentPatientsSum = record.getCurrentPatientsFemaleUnder5() + record.getCurrentPatientsFemaleAbove5();

    // Sums of new cases
    int newCasesSum = record.getNewCasesMalesUnder5() + record.getNewCasesMalesAbove5() + record.getNewCasesFemalesUnder5() + record.getNewCasesFemalesAbove5();
    int maleNewCasesSum = record.getNewCasesMalesUnder5() + record.getNewCasesMalesAbove5();
    int femaleNewCasesSum = record.getNewCasesFemalesUnder5() + record.getNewCasesFemalesAbove5();

    // Sums of Deaths
    int deathsTotal = record.getDeathCasesMalesUnder5() + record.getDeathCasesMalesAbove5() + record.getDeathCasesFemalesUnder5() + record.getDeathCasesFemalesAbove5();
    int maleDeathSum = record.getDeathCasesMalesUnder5() + record.getDeathCasesMalesAbove5();
    int femaleDeathSum = record.getDeathCasesFemalesUnder5() + record.getDeathCasesFemalesAbove5();

//    if(deathsTotal != 0 || newCasesSum > 2 || currentPatientsSum > 1 )
//      WidgetStateProperty<Color> color = WidgetStateProperty<Colors.red>;
    return DataRow(
// set the row color here
//      color: ,

      cells: [
        DataCell(Center(child: Text("1"))), // number
        DataCell(Center(child: Text(record.getEpidemic()))), // epidemic name
        // currnt patients
        DataCell(Center(child: Text(record.getCurrentPatientsMaleUnder5().toString()))), // current male < 5
        DataCell(Center(child: Text(record.getCurrentPatientsFemaleUnder5().toString()))), // current female < 5
        DataCell(Center(child: Text(record.getCurrentPatientsMaleAbove5().toString()))), // current male > 5
        DataCell(Center(child: Text(record.getCurrentPatientsFemaleAbove5().toString()))), // current female > 5
        // current patients totals
        DataCell(Center(child: Text(maleCurrentPatientsSum.toString()))), // Total males current patients
        DataCell(Center(child: Text(femaleCurrentPatientsSum.toString()))), // Total females current patients
        DataCell(Center(child: Text(currentPatientsSum.toString()))), // Total current patients
        DataCell(Center(child: Text(''))), // Total current patients

        // new cases
        DataCell(Center(child: Text(record.getNewCasesMalesUnder5().toString()))), // current male < 5
        DataCell(Center(child: Text(record.getNewCasesFemalesUnder5().toString()))), // current female < 5
        DataCell(Center(child: Text(record.getNewCasesMalesAbove5().toString()))), // current male > 5
        DataCell(Center(child: Text(record.getNewCasesFemalesAbove5().toString()))), // current female > 5

        // new cases totals
        DataCell(Center(child: Text(maleNewCasesSum.toString()))), // Total males current patients
        DataCell(Center(child: Text(femaleNewCasesSum.toString()))), // Total females current patients
        DataCell(Center(child: Text(newCasesSum.toString()))), // Total current patients
        DataCell(Center(child: Text(""))), // Total current patients

        // Deaths
        DataCell(Center(child: Text(record.getDeathCasesMalesUnder5().toString()))), // current male < 5
        DataCell(Center(child: Text(record.getDeathCasesFemalesUnder5().toString()))), // current female < 5
        DataCell(Center(child: Text(record.getDeathCasesMalesAbove5().toString()))), // current male > 5
        DataCell(Center(child: Text(record.getDeathCasesFemalesAbove5().toString()))), // current female > 5

        // Death totals
        DataCell(Center(child: Text(maleDeathSum.toString()))), // Total males current patients
        DataCell(Center(child: Text(femaleDeathSum.toString()))), // Total females current patients
        DataCell(Center(child: Text(deathsTotal.toString()))), // Total current patients
        DataCell(Center(child: Text(""))), // Total current patients
      ],

    );
  }

  Widget _buildStaffReportTable(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'هذه الميزة لا تعمل حاليا', // Reports (Arabic)
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

} // class

final List<String> _reportTypes = [
  'تقارير الأوبئة',
  'التقارير الدورية',
  'تقارير الكادر الطبي',
]; // Daily, Weekly, Epidemic Reports
final List<String> _hospitals = [
  'الكل',
  'مستشفى الاطباء',
  'مستشفى الخرطوم',
  'مستشفى أمدرمان',
  'مستشفى النو التعليمي',
  'مستشفى السلاح الطبي',
]; // Example hospitals
