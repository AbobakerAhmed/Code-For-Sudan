import 'package:flutter/material.dart';

// NotificationsScreen is a StatelessWidget that displays a list of notifications.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
          textDirection:
              TextDirection.rtl, // Right-to-left direction for Arabic title
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align content to the end (right)
            children: [
              Text(
                'الاشعارات', // Notifications (Arabic)
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 8), // Space between text and icon
              Icon(
                Icons.notifications_active,
                color: Colors.blue,
                size: 28,
              ), // Notification icon
            ],
          ),
        ),
        titleSpacing: 0, // Remove default title spacing for custom title layout
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Distribute filter buttons evenly
              children: [
                _buildFilterButton(
                  context,
                  'ترتيب',
                  Icons.arrow_drop_down,
                ), // Sort
                _buildFilterButton(context, 'التاريخ', null), // Date
                _buildFilterButton(
                  context,
                  'عرض اشعارات الاوبئة فقط',
                  null,
                ), // Show epidemic notifications only
                _buildFilterButton(
                  context,
                  'مستشفى',
                  Icons.arrow_drop_down,
                ), // Hospital
              ],
            ),
          ),
          Expanded(
            // Allows the ListView to take up the remaining vertical space
            child: ListView(
              children: const [
                // Example Notification Items
                NotificationItem(
                  date: '2025-6-10',
                  time: '2:45 am',
                  title: 'تم ارسال التقرير اليومي', // Daily report sent
                  source:
                      'اشعار من مستشفى الاطباء', // Notification from Doctors Hospital
                  isRead: false, // Unread notification
                ),
                NotificationItem(
                  date: '2025-6-10',
                  time: '2:45 am',
                  title: 'تم ارسال التقرير الاسبوعي', // Weekly report sent
                  source:
                      'اشعار من مستشفى الاطباء', // Notification from Doctors Hospital
                  isRead: true, // Read notification
                ),
                NotificationItem(
                  date: '2025-6-3',
                  time: '2:45 am',
                  title: 'تم ارسال التقرير الاسبوعي', // Weekly report sent
                  source:
                      'اشعار من مستشفى الاطباء', // Notification from Doctors Hospital
                  isRead: true, // Read notification
                ),
                NotificationItem(
                  date: '2025-6-01',
                  time: '2:45 am',
                  title:
                      'رصد وباء في الخرطوم بحري', // Epidemic detected in Khartoum Bahri
                  source:
                      'تنبيه من مستشفى الاطباء!!!', // Alert from Doctors Hospital!!!
                  isRead: false, // Unread notification
                  isUrgent: true, // Urgent notification (red background)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a filter button.
  Widget _buildFilterButton(
    BuildContext context,
    String text,
    IconData? suffixIcon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), // Light grey border
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Directionality(
        textDirection:
            TextDirection.rtl, // Right-to-left direction for button content
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            if (suffixIcon != null) ...[
              // Add suffix icon if provided
              const SizedBox(width: 4), // Space between text and icon
              Icon(suffixIcon, size: 16, color: Colors.black54),
            ],
          ],
        ),
      ),
    );
  }
}

// NotificationItem widget to display individual notification details.
class NotificationItem extends StatelessWidget {
  final String date;
  final String time;
  final String title;
  final String source;
  final bool isRead;
  final bool isUrgent;

  const NotificationItem({
    super.key,
    required this.date,
    required this.time,
    required this.title,
    required this.source,
    this.isRead = false,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isUrgent
          ? Colors.red
          : Colors.white, // Background color based on urgency
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.only(
        bottom: 1.0,
      ), // Small margin for visual separation between items
      child: Directionality(
        textDirection: TextDirection
            .rtl, // Right-to-left direction for notification content
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start (right)
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Distribute date and source
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUrgent
                        ? Colors.white
                        : Colors.grey[600], // Text color based on urgency
                  ),
                ),
                Text(
                  source,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isUrgent
                        ? Colors.white
                        : Colors.black87, // Text color based on urgency
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4), // Vertical space
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Distribute time and title/unread dot
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUrgent
                        ? Colors.white
                        : Colors.grey[600], // Text color based on urgency
                  ),
                ),
                Expanded(
                  // Allows title to take available space and push dot to the left
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: isUrgent
                          ? Colors.white
                          : Colors.black, // Text color based on urgency
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign:
                        TextAlign.end, // Align title to the end (right for RTL)
                  ),
                ),
                if (!isRead) // Show blue dot if notification is unread
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ), // Padding for the dot
                    child: Icon(Icons.circle, size: 8, color: Colors.blue),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
