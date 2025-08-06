import 'package:flutter/material.dart' hide Notification;
import 'package:pc_apps/Backend/notification.dart';
import 'Backend/testing_data.dart';
import 'package:pc_apps/send_notifications_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  //
  String? _selectedDepartment;
  String? _selectedEmployee;
  final TextEditingController _messageController = TextEditingController();

  final List<String> _departments = [
    'الباطنية',
    'العظام',
    'القلب',
    'الاطفال',
  ]; // Internal Medicine, Orthopedics, Cardiology, Pediatrics
  final List<String> _employees = [
    'دكتور',
    'ممرض',
    'فني',
    'الكل',
  ]; // Doctor, Nurse, Technician, All

  ///


  String? _selectedIncomingFilter;
  String? _selectedIncomingSortOption;

  String? _selectedOutgoingFilter;
  String? _selectedOutgoingSortOption;

  final List<String> _sortOptions = ['التاريخ', 'الأهمية']; // Date, Importance

  @override
  void initState() {
    super.initState();
    // The length is correctly set to 3 for your three tabs.
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose(); // Dispose the message controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100], // Light grey background
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // Transparent to blend with background
          elevation: 0,
          // No shadow
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
            mainAxisAlignment: MainAxisAlignment.end,
            // Align title to the right
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
              SizedBox(width: 10), // Spacing between text and icon
            ],
          ),
          titleSpacing: 0,
          // Remove default title spacing
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
                  indicatorColor: Colors.deepPurple,
                  // Indicator color
                  labelColor: Colors.deepPurple,
                  // Selected tab text color
                  unselectedLabelColor: Colors.grey,
                  // Unselected tab text color
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
        body: Directionality(textDirection: TextDirection.rtl,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Incoming Notifications Tab Content
              _buildIncomingNotificationsTab(),
              // Outgoing Notifications Tab Content
              _buildOutgoingNotificationsTab(),
            ],
          ),)
    );
  }

  Widget _buildIncomingNotificationsTab() {
    // Replace the List<Map<String, String>> with List<Notification>
    // go to database here to obtain notifications from the ministry
    List<Notification> _receivedNotifications = incomingNotifications;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter and Sort Options for Incoming
          _buildFilterSortRow(
            filterOptions: [
              'الكل',
              'الإشعارات المهمة فقط',
              'الواردة للمدير فقط',
              'الواردة لكامل موظفي المستشفى',
            ],
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
            filterHint: 'الواردة',
            // Incoming
            sortHint: 'التاريخ', // Date
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount:
              _receivedNotifications.length,
              // Use the length of the Notification list
              itemBuilder: (context, index) {
                final notification = _receivedNotifications[index];
                // Replace NotificationListItem with _buildNotificationContainer
                return _buildNotificationContainer(notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutgoingNotificationsTab() {
    // go to database here to obtain sent notifications to staff
    List<Notification> _sentNotifications = outcomingNotifications;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter and Sort Options for Outgoing
          _buildFilterSortRow(
            filterOptions: [
              'الكل',
              'الإشعارات المهمة فقط',
              'للأطباء فقط',
              'للمسجلين فقط',
            ],
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
            filterHint: 'الصادرة',
            // Outgoing
            sortHint: 'التاريخ', // Date
          ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount:
            _sentNotifications.length,
            // Use the length of the Notification list
            itemBuilder: (context, index) {
              final notification = _sentNotifications[index];
              // Replace NotificationListItem with _buildNotificationContainer
              return _buildSentNotificationContainer(notification);
            },
          ),
        ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SendNotificationsScreen()));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 40,),
                  SizedBox(width: 10,),
                  Text("إرسال إشعار جديد", style: TextStyle(fontSize: 25),)
                ],
              )),
          SizedBox(height: 10,),
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
                          String value,) {
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
                          String value,) {
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

// Widget to build a notification container as per your request
  Widget _buildNotificationContainer(Notification notification) {
    return ElevatedButton(
      onPressed: () {
        // The onPressed function is intentionally left empty as per the request.
        // In a real application, you would implement navigation or other logic here.
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        // Remove default padding from ElevatedButton
        elevation: 0,
        // Remove default elevation
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(0)),
        // Remove default rounded corners
        backgroundColor:
        Colors.transparent,
        // Make background transparent to show Container's color
        foregroundColor: Colors.transparent, // Make foreground transparent
      ),
      child: Container(
        color: notification.isImportant ? Colors.red : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        margin: const EdgeInsets.only(bottom: 1.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (!notification.isRed)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.circle, size: 8, color: Colors.blue),
                      ),
                    const SizedBox(width: 10),
                    Text(
                      "${notification.getSender()} - ${notification
                          .getTitle()}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Cairo', // Added for consistency
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl, // Added for Arabic text
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Text(
                  "${notification
                      .getCreationTime()
                      .year} / ${notification
                      .getCreationTime()
                      .month} / ${notification
                      .getCreationTime()
                      .day}",
                  style: TextStyle(
                    fontSize: 12,
                    color: notification.isImportant
                        ? Colors.white
                        : Colors.grey[600],
                    fontFamily: 'Cairo', // Added for consistency
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl, // Added for Arabic text
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(""),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      notification.getMassage(),
                      style: TextStyle(
                        fontSize: 16,
                        color: notification.isImportant
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo', // Added for consistency
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl, // Added for Arabic text
                    ),
                  ),
                ),
                Text(
                  notification.timeFormatAMPM(),
                  style: TextStyle(
                    fontSize: 12,
                    color: notification.isImportant
                        ? Colors.white
                        : Colors.grey[600],
                    fontFamily: 'Cairo', // Added for consistency
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl, // Added for Arabic text
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentNotificationContainer(Notification notification) {
    return Container(
      color: notification.isImportant ? Colors.red : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 1.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (!notification.isRed)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.circle, size: 8, color: Colors.blue),
                    ),
                  const SizedBox(width: 10),
                  Text(
                    "${notification.getTitle()} -> ${notification
                        .getReseveirLocality()}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Cairo', // Added for consistency
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl, // Added for Arabic text
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Text(
                "${notification
                    .getCreationTime()
                    .year} / ${notification
                    .getCreationTime()
                    .month} / ${notification
                    .getCreationTime()
                    .day}",
                style: TextStyle(
                  fontSize: 12,
                  color: notification.isImportant
                      ? Colors.white
                      : Colors.grey[600],
                  fontFamily: 'Cairo', // Added for consistency
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl, // Added for Arabic text
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(""),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    notification.getMassage(),
                    style: TextStyle(
                      fontSize: 16,
                      color: notification.isImportant
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo', // Added for consistency
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl, // Added for Arabic text
                  ),
                ),
              ),
              Text(
                notification.timeFormatAMPM(),
                style: TextStyle(
                  fontSize: 12,
                  color: notification.isImportant
                      ? Colors.white
                      : Colors.grey[600],
                  fontFamily: 'Cairo', // Added for consistency
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl, // Added for Arabic text
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

// Helper method to build styled dropdowns
  Widget buildStyledDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
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
            hintText,
            style: const TextStyle(color: Colors.black87, fontFamily: 'Cairo'),
            textDirection: TextDirection.rtl,
          ),
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String itemValue) {
            return DropdownMenuItem<String>(
              value: itemValue,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  itemValue,
                  style: const TextStyle(fontFamily: 'Cairo'),
                  textDirection: TextDirection.rtl,
                ),
              ),
            );
          }).toList(),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ), // Dropdown arrow
        ),
      ),
    );
  }
}