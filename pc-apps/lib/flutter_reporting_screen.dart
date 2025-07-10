import 'package:flutter/material.dart';

class ReportingScreen extends StatefulWidget {
  const ReportingScreen({super.key});

  @override
  State<ReportingScreen> createState() => _ReportingScreenState();
}

class _ReportingScreenState extends State<ReportingScreen> {
  String? _selectedReportType;
  String? _selectedState;
  String? _selectedLocality;
  String? _selectedHospital;
  String? _selectedDate;

  final List<String> _reportTypes = [
    'التقارير اليومية',
    'التقارير الاسبوعية',
    'تقارير الاوبئة',
  ]; // Daily, Weekly, Epidemic Reports
  final List<String> _states = [
    'الجزيرة',
    'الخرطوم',
    'البحر الأحمر',
  ]; // Example states
  final List<String> _localities = [
    'الكاملين',
    'ود مدني',
    'ام درمان',
  ]; // Example localities
  final List<String> _hospitals = [
    'مستشفى الاطباء',
    'مستشفى الخرطوم',
    'مستشفى ام درمان',
  ]; // Example hospitals
  final List<String> _dates = [
    '2025-6-10',
    '2025-6-03',
    '2025-5-27',
  ]; // Example dates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Directionality(
          textDirection: TextDirection.rtl, // Right-to-left for Arabic title
          child: Row(
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
              SizedBox(width: 8),
              Icon(
                Icons.assignment,
                color: Colors.blue,
                size: 28,
              ), // Reports icon
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Allow horizontal scrolling for filters
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterDropdown(
                    hint: 'النوع...', // Type...
                    value: _selectedReportType,
                    items: _reportTypes,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedReportType = newValue;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    hint: 'الولاية...', // State...
                    value: _selectedState,
                    items: _states,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    hint: 'المحلية...', // Locality...
                    value: _selectedLocality,
                    items: _localities,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLocality = newValue;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    hint: 'المستشفى...', // Hospital...
                    value: _selectedHospital,
                    items: _hospitals,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedHospital = newValue;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    hint: 'التاريخ...', // Date...
                    value: _selectedDate,
                    items: _dates,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDate = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildReportContent()),
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
    );
  }

  Widget _buildFilterDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text(
              hint,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: Colors.black54,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent() {
    // This widget will display different content based on _selectedReportType
    // For now, it will show a placeholder or a simple table.
    if (_selectedReportType == 'التقارير اليومية' ||
        _selectedReportType == 'التقارير الاسبوعية') {
      return _buildDailyWeeklyReportTable();
    } else if (_selectedReportType == 'تقارير الاوبئة') {
      return _buildEpidemicReportTable();
    } else {
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

  Widget _buildDailyWeeklyReportTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DataTable(
          columnSpacing: 12.0,
          dataRowHeight: 48.0,
          columns: const [
            DataColumn(
              label: Text(
                'القسم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ), // Department
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
                'حالات الشفاء',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ), // Recovery Cases
            DataColumn(
              label: Text(
                'العمليات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ), // Operations
            DataColumn(
              label: Text(
                'حالات الوفاه',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ), // Death Cases
            DataColumn(
              label: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
            ), // View Details
          ],
          rows: [
            _buildDailyWeeklyDataRow(
              'الباطنية',
              '25',
              '5',
              '20',
              '13',
              '0',
            ), // Internal Medicine
            _buildDailyWeeklyDataRow(
              'العظام',
              '30',
              '4',
              '26',
              '16',
              '0',
            ), // Orthopedics
            _buildDailyWeeklyDataRow(
              'الاسنان',
              '58',
              '6',
              '52',
              '15',
              '1',
            ), // Dentistry
            _buildDailyWeeklyDataRow(
              'العظام',
              '34',
              '15',
              '14',
              '45',
              '4',
            ), // Orthopedics
            _buildDailyWeeklyDataRow(
              'الباطنية',
              '15',
              '22',
              '25',
              '12',
              '0',
            ), // Internal Medicine
            _buildDailyWeeklyDataRow(
              'الاسنان',
              '58',
              '6',
              '52',
              '15',
              '1',
            ), // Dentistry
          ],
        ),
      ),
    );
  }

  DataRow _buildDailyWeeklyDataRow(
    String department,
    String newCases,
    String hospitalized,
    String recovery,
    String operations,
    String deaths,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(department, textDirection: TextDirection.rtl)),
        DataCell(Text(newCases)),
        DataCell(Text(hospitalized)),
        DataCell(Text(recovery)),
        DataCell(Text(operations)),
        DataCell(Text(deaths)),
        DataCell(
          TextButton(
            onPressed: () {
              print('View Details tapped for $department');
            },
            child: const Text(
              'عرض التفاصيل',
              style: TextStyle(color: Colors.blue),
            ), // View Details
          ),
        ),
      ],
    );
  }

  Widget _buildEpidemicReportTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DataTable(
          columnSpacing: 8.0,
          dataRowHeight: 48.0,
          columns: const [
            DataColumn(
              label: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
            ), // Empty for numbering
            DataColumn(
              label: Text(
                'الاصابات',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Infections
            DataColumn(
              label: Text(
                'الكل',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Total
            DataColumn(
              label: Text(
                'أكثر من 5',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // More than 5
            DataColumn(
              label: Text(
                'أقل من 5',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Less than 5
            DataColumn(
              label: Text(
                'التردد الكلي',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Total Frequency
            DataColumn(
              label: Text(
                'دخولات كلية',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Total Admissions
            DataColumn(
              label: Text(
                'وفيات كلية',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Total Deaths
            DataColumn(
              label: Text(
                'شرائح كلية',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Total Slides
            DataColumn(
              label: Text(
                'شرائح موجبة',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Positive Slides
            DataColumn(
              label: Text(
                'النسبة',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Percentage
            DataColumn(
              label: Text(
                'عفويات',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ), // Spontaneous
          ],
          rows: [
            _buildEpidemicDataRow(
              '1-',
              'الاسهال المائي الحاد',
            ), // Acute Watery Diarrhea
            _buildEpidemicDataRow(
              '2-',
              'الشلل الرخو الحاد',
            ), // Acute Flaccid Paralysis
            _buildEpidemicDataRow(
              '3-',
              'الاسهال الدموي الحاد',
            ), // Acute Bloody Diarrhea
            _buildEpidemicDataRow(
              '4-',
              'الطاعون البشري الوبائي',
            ), // Epidemic Human Plague
            _buildEpidemicDataRow('5-', 'السرس'), // SERS
            _buildEpidemicDataRow('6-', 'الانفلونزا الحادة'), // Acute Influenza
            _buildEpidemicDataRow('7-', 'تسمم الطعام'), // Food Poisoning
            _buildEpidemicDataRow('8-', 'الملاريا'), // Malaria
            _buildEpidemicDataRow(
              '9-',
              'الجمرة الخبيثة (الانتراكس)',
            ), // Anthrax
            _buildEpidemicDataRow('10-', 'السرع'), // Rabies
            _buildEpidemicDataRow('11-', 'السعال الديكي'), // Whooping Cough
            _buildEpidemicDataRow('12-', 'الحصبة الالمانية'), // German Measles
            _buildEpidemicDataRow(
              '13-',
              'الانفلونزا الحادة',
            ), // Acute Influenza
            _buildEpidemicDataRow('14-', ''), // Empty
            _buildEpidemicDataRow('15-', 'المجموع'), // Total
          ],
        ),
      ),
    );
  }

  DataRow _buildEpidemicDataRow(String number, String disease) {
    return DataRow(
      cells: [
        DataCell(Text(number)),
        DataCell(Text(disease, textDirection: TextDirection.rtl)),
        const DataCell(Text('')), // Placeholder for 'الكل'
        const DataCell(Text('')), // Placeholder for 'أكثر من 5'
        const DataCell(Text('')), // Placeholder for 'أقل من 5'
        const DataCell(Text('')), // Placeholder for 'التردد الكلي'
        const DataCell(Text('')), // Placeholder for 'دخولات كلية'
        const DataCell(Text('')), // Placeholder for 'وفيات كلية'
        const DataCell(Text('')), // Placeholder for 'شرائح كلية'
        const DataCell(Text('')), // Placeholder for 'شرائح موجبة'
        const DataCell(Text('')), // Placeholder for 'النسبة'
        const DataCell(Text('')), // Placeholder for 'عفويات'
      ],
    );
  }
}
