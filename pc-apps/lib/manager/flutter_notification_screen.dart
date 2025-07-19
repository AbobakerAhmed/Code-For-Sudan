import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String? _selectedIncomingFilter;
  String? _selectedIncomingSortOption;

  String? _selectedOutgoingFilter;
  String? _selectedOutgoingSortOption;

  final List<String> _incomingFilters = [
    'الواردة',
    'عاجلة',
    'إدارية',
    'تقنية',
    'شكر وتقدير',
  ]; // Incoming, Urgent, Administrative, Technical, Thanks & Appreciation
  final List<String> _outgoingFilters = [
    'الصادرة',
    'تحديثات',
    'تنبيهات',
    'إشعار',
    'شكر وتقدير',
  ]; // Outgoing, Updates, Alerts, Notification, Thanks & Appreciation
  final List<String> _sortOptions = ['التاريخ', 'الأهمية']; // Date, Importance

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              'الاشعارات', // Notifications
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
              Icons.notifications_active, // Placeholder for bell with plus
              color: Colors.deepPurple,
              size: 35,
            ),
          ],
        ),
        titleSpacing: 0, // Remove default title spacing
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0), // Height of the TabBar
          child: Column(
            children: [
              const Divider(
                height: 1,
                color: Colors.grey,
              ), // Thin horizontal line below app bar
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.deepPurple, // Indicator color
                labelColor: Colors.deepPurple, // Selected tab text color
                unselectedLabelColor: Colors.grey, // Unselected tab text color
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
                tabs: const [
                  Tab(
                    text: 'الواردة', // Incoming
                    //textDirection: TextDirection.rtl,
                  ),
                  Tab(
                    text: 'الصادرة', // Outgoing
                    //textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Incoming Notifications Tab Content
          _buildIncomingNotificationsTab(),
          // Outgoing Notifications Tab Content
          _buildOutgoingNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildIncomingNotificationsTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter and Sort Options for Incoming
          _buildFilterSortRow(
            filterOptions: _incomingFilters,
            sortOptions: _sortOptions,
            selectedFilter: _selectedIncomingFilter,
            onFilterChanged: (newValue) {
              setState(() {
                _selectedIncomingFilter = newValue;
              });
            },
            selectedSortOption: _selectedIncomingSortOption,
            onSortChanged: (newValue) {
              setState(() {
                _selectedIncomingSortOption = newValue;
              });
            },
            filterHint: 'الواردة', // Incoming
            sortHint: 'التاريخ', // Date
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Example count
              itemBuilder: (context, index) {
                final List<Map<String, String>> incomingNotifications = [
                  {
                    'date': '2025-6-10',
                    'time': '2:45 am',
                    'type': 'تنبيهات صحية عاجلة', // Urgent Health Alerts
                    'message':
                        'تقارير عن انتشار وباء و حالة طوارئ صحية', // Reports on epidemic spread and health emergency
                    'dotColor': 'blue',
                  },
                  {
                    'date': '2025-6-10',
                    'time': '2:45 am',
                    'type': 'توجيهات إدارية', // Administrative Directives
                    'message':
                        'تحديثات على النظام الإلكتروني أو طريقة رفع البيانات', // Updates on the electronic system or data submission method
                    'dotColor': 'blue',
                  },
                  {
                    'date': '2025-6-3',
                    'time': '2:45 am',
                    'type': 'تحديثات تقنية', // Technical Updates
                    'message':
                        'طلب مراجعة بيانات معينة بسبب خلل تقني', // Request to review specific data due to technical glitch
                    'dotColor': 'blue',
                  },
                  {
                    'date': '2025-6-10',
                    'time': '2:45 am',
                    'type': 'شكر وتقدير', // Thanks and Appreciation
                    'message':
                        'شكر على جهود الفريق بعد حالة طارئة', // Thanks for team efforts after an emergency
                    'dotColor': 'blue',
                  },
                ];
                final notification = incomingNotifications[index];
                return NotificationListItem(
                  date: notification['date']!,
                  time: notification['time']!,
                  type: notification['type']!,
                  message: notification['message']!,
                  dotColor: notification['dotColor'] == 'blue'
                      ? Colors.blue
                      : Colors.red, // Example color
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutgoingNotificationsTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter and Sort Options for Outgoing
          _buildFilterSortRow(
            filterOptions: _outgoingFilters,
            sortOptions: _sortOptions,
            selectedFilter: _selectedOutgoingFilter,
            onFilterChanged: (newValue) {
              setState(() {
                _selectedOutgoingFilter = newValue;
              });
            },
            selectedSortOption: _selectedOutgoingSortOption,
            onSortChanged: (newValue) {
              setState(() {
                _selectedOutgoingSortOption = newValue;
              });
            },
            filterHint: 'الصادرة', // Outgoing
            sortHint: 'التاريخ', // Date
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Example count
              itemBuilder: (context, index) {
                final List<Map<String, String>> outgoingNotifications = [
                  {
                    'date': '2025-6-10',
                    'time': '2:45 am',
                    'type':
                        'تحديثات في جداول المناوبة و ساعات العمل', // Updates in shift schedules and working hours
                    'recipient':
                        'الى:د.احمد علي احمد', // To: Dr. Ahmed Ali Ahmed
                  },
                  {
                    'date': '2025-6-10',
                    'time': '2:45 am',
                    'type':
                        'تنبيه بخصوص نقص أو خطأ في سجل الحجز', // Alert regarding deficiency or error in booking record
                    'recipient':
                        'الى:مسجل قسم الجراحة', // To: Surgery Department Registrar
                  },
                  {
                    'date': '2025-6-3',
                    'time': '2:45 am',
                    'type':
                        'إشعار بخصوص التنسيق مع الوزارة', // Notification regarding coordination with the Ministry
                    'recipient':
                        'الى:ضابط صحة قسم العظام', // To: Orthopedic Department Health Officer
                  },
                  {
                    'date': '2025-6-10',
                    'time': '2:45 am',
                    'type':
                        'شكر على جهود الفريق بعد حالة طارئة', // Thanks for team efforts after an emergency
                    'recipient':
                        'الى:الكل-قسم العظام', // To: All - Orthopedic Department
                  },
                ];
                final notification = outgoingNotifications[index];
                return OutgoingNotificationListItem(
                  date: notification['date']!,
                  time: notification['time']!,
                  type: notification['type']!,
                  recipient: notification['recipient']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Reusable widget for Filter and Sort dropdowns
  Widget _buildFilterSortRow({
    required List<String> filterOptions,
    required List<String> sortOptions,
    required String? selectedFilter,
    required ValueChanged<String?> onFilterChanged,
    required String? selectedSortOption,
    required ValueChanged<String?> onSortChanged,
    required String filterHint,
    required String sortHint,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
                      hint: Text(
                        sortHint,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      value: selectedSortOption,
                      onChanged: onSortChanged,
                      items: sortOptions.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              value,
                              style: const TextStyle(fontFamily: 'Cairo'),
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
        const SizedBox(width: 20), // Space between two dropdowns
        // Filter Option Dropdown
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                filterHint,
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
                      hint: Text(
                        filterHint,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      value: selectedFilter,
                      onChanged: onFilterChanged,
                      items: filterOptions.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              value,
                              style: const TextStyle(fontFamily: 'Cairo'),
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
    );
  }
}

// Reusable Widget for Incoming Notification List Items
class NotificationListItem extends StatelessWidget {
  final String date;
  final String time;
  final String type;
  final String message;
  final Color dotColor;

  const NotificationListItem({
    super.key,
    required this.date,
    required this.time,
    required this.type,
    required this.message,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  date,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // Type, Message, and Dot (Right Side)
            Flexible(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Align contents to the right
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Widget for Outgoing Notification List Items
class OutgoingNotificationListItem extends StatelessWidget {
  final String date;
  final String time;
  final String type;
  final String recipient;

  const OutgoingNotificationListItem({
    super.key,
    required this.date,
    required this.time,
    required this.type,
    required this.recipient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  date,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // Type and Recipient (Right Side)
            Flexible(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Align contents to the right
                children: [
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    recipient,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
