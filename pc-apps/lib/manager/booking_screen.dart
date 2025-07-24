import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String? _selectedFilter;
  String? _selectedSortOption;

  final List<String> _filters = [
    'الحجوزات الجديدة',
    'الحجوزات المؤكدة',
    'الحجوزات الملغاة',
  ]; // New, Confirmed, Cancelled Bookings
  final List<String> _sortOptions = [
    'التاريخ',
    'اسم المريض',
  ]; // Date, Patient Name

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
              height: 1,
              color: Colors.grey,
            ), // Thin horizontal line below app bar
            const SizedBox(height: 20),

            // Filter and Sort Options
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align contents to the right
              children: [
                // Sort Option Dropdown
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'ترتيب', // Sort
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontFamily: 'Cairo',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text(
                                'التاريخ', // Date
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Cairo',
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              value: _selectedSortOption,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedSortOption = newValue;
                                });
                              },
                              items: _sortOptions.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20), // Space between two dropdowns
                // Filter Option Dropdown
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'الحجوزات الجديدة', // New Bookings
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontFamily: 'Cairo',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text(
                                'الحجوزات الجديدة', // New Bookings
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Cairo',
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              value: _selectedFilter,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFilter = newValue;
                                });
                              },
                              items: _filters.map<DropdownMenuItem<String>>((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                );
                              }).toList(),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List of Bookings
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Example count from the image
                itemBuilder: (context, index) {
                  final List<Map<String, String>> bookings = [
                    {
                      'date': '2025-6-10',
                      'time': '2:45 am',
                      'patient': 'المريض: حماد عبدالله حماد الدندر',
                    },
                    {
                      'date': '2025-6-10',
                      'time': '2:45 am',
                      'patient': 'المريض: خديجة ابراهيم عمر',
                    },
                    {
                      'date': '2025-6-10',
                      'time': '2:45 am',
                      'patient': 'المريض: محمد عثمان علي',
                    },
                    {
                      'date': '2025-6-10',
                      'time': '2:45 am',
                      'patient': 'المريض: فاطمة حماد عبدالله',
                    },
                  ];
                  final booking = bookings[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 1, // Slight shadow for cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time and Date (Left Side)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking['date']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                booking['time']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          // Patient Name (Right Side)
                          Flexible(
                            child: Text(
                              booking['patient']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: 'Cairo', // Example font
                              ),
                              textAlign: TextAlign
                                  .right, // Align patient name to the right
                              textDirection:
                                  TextDirection.rtl, // Right-to-left for Arabic
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
