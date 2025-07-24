import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock data for demonstration, including a 'type' for filtering
  final List<Map<String, String>> _allNotifications = [
    {
      'date': '2025-6-10',
      'time': '2:45 am',
      'message':
          'تم اعتماد بروتوكول علاجي جديد لحالات التسمم الدوائي', // New treatment protocol approved for drug poisoning cases
      'type': 'وزارة', // Ministry
    },
    {
      'date': '2025-6-10',
      'time': '2:45 am',
      'message':
          'دعوة للمشاركة في مؤتمر الطب الوقائي الوطني', // Invitation to participate in the National Preventive Medicine Conference
      'type': 'وزارة',
    },
    {
      'date': '2025-6-3',
      'time': '2:45 am',
      'message':
          'توجيهات للتعامل مع الحالات القادمة من منطقة [الدندر]', // Directives for dealing with cases coming from [Al Dandar] area
      'type': 'وزارة',
    },
    {
      'date': '2025-6-10',
      'time': '2:45 am',
      'message':
          'بروتوكول تحديث بيانات المرضى الجدد في النظام الإلكتروني', // Protocol for updating new patient data in the electronic system
      'type': 'وزارة',
    },
    {
      'date': '2025-6-10',
      'time': '2:45 am',
      'message':
          'تحديثات في جداول المناوبة و ساعات العمل', // Updates in shift schedules and working hours
      'type': 'مدير', // Manager
    },
    {
      'date': '2025-6-10',
      'time': '2:45 am',
      'message':
          'اشعار بقدوم وفد من الوزارة', // Notification of a delegation from the Ministry
      'type': 'مدير',
    },
    {
      'date': '2025-6-3',
      'time': '2:45 am',
      'message': 'قرارات سياسات السلامة الجديدة', // New safety policy decisions
      'type': 'مدير',
    },
    {
      'date': '2025-6-10',
      'time': '2:45 am',
      'message':
          'شكر وتقدير على جهود الفريق بعد حالة طارئة', // Thanks and appreciation for the team's efforts after an emergency
      'type': 'مدير',
    },
  ];

  String _currentFilter = 'وزارة'; // Default filter: 'وزارة' (Ministry)
  String _currentSort = 'التاريخ'; // Default sort: 'التاريخ' (Date)

  List<Map<String, String>> get _filteredNotifications {
    if (_currentFilter == 'الكل') {
      // 'الكل' means 'All'
      return _allNotifications;
    }
    return _allNotifications
        .where((notification) => notification['type'] == _currentFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'الاشعارات', // Notifications
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.notifications_active,
              color: Colors.blue.shade700,
              size: 30,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align dropdowns to the right
              children: [
                // Filter by type (Ministry/Manager)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentFilter,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentFilter = newValue!;
                        });
                      },
                      items:
                          <String>[
                                'وزارة',
                                'مدير',
                                'الكل',
                              ] // Ministry, Manager, All
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: value == _currentFilter
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: value == _currentFilter
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Spacer
                // Sort by Date (التاريخ)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentSort,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentSort = newValue!;
                          // Implement sorting logic here if needed
                        });
                      },
                      items:
                          <String>[
                                'التاريخ',
                                'الأهمية',
                              ] // Date, Importance (example)
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: value == _currentSort
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: value == _currentSort
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                    ),
                  ),
                ),
                /*const SizedBox(width: 10), // Spacer
                // Sort type (ترتيب)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value:
                          'ترتيب', // Hardcoded as per image, or use a state variable
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      onChanged: (String? newValue) {
                        // Handle sort type change if necessary
                      },
                      items:
                          <String>[
                                'ترتيب',
                              ] // You might add 'تصاعدي', 'تنازلي' (Ascending, Descending)
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(value),
                                  ),
                                );
                              })
                              .toList(),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              itemCount: _filteredNotifications.length, // Use filtered list
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Colors.grey),
              itemBuilder: (context, index) {
                final notification = _filteredNotifications[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .end, // Align content to the right for RTL
                    children: [
                      // Blue dot (indicator)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              notification['message']!,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              notification['time']!,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            notification['date']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
