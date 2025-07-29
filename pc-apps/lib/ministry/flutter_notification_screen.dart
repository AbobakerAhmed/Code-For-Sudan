import 'package:flutter/material.dart' hide Notification;
import 'package:pc_apps/ministry/Backend/global_var.dart';
import 'package:pc_apps/ministry/Backend/ministry_employee.dart';
import 'package:pc_apps/ministry/Backend/notification.dart';
import 'global_ui.dart';
import 'Backend/testing_data.dart';


class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key, required this.employee});
  late final MinistryEmployee employee;

  @override
  State<StatefulWidget> createState() => _NotificationsScreenState(employee: employee);
}

// NotificationsScreen is a StatelessWidget that displays a list of notifications.
class _NotificationsScreenState extends State<NotificationsScreen> {

  _NotificationsScreenState({required this.employee});

  late final MinistryEmployee employee;
  String? _sorting;
  late String _selectedState = this.employee.getState();
  late String _selectedLocality= this.employee.getLocality();
  String _selectedHospital = 'الكل';

  DateTimeRange? _selectedDate;

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
        title: Row(
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
            SizedBox(width: 8), // Space between text and icon

          ],
        ),
        titleSpacing: 0, // Remove default title spacing for custom title layout
      ),
      body: Column(

        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // Distribute filter buttons evenly
              children: [
                buildFilterDropdown( // in global_ui.dart
                  hint: 'ترتيب',
                  value: _sorting,
                  items: ['الغير مقروءة', 'الأحدث', 'الأهم', ],
                  onChanged: (selectedValue){
                    _sorting = selectedValue;
                  }
                ), // Sort

        buildDateRangeSelector( // in global_ui.dart
          context: context,
          selectedRange: _selectedDate,
          onRangeSelected: (_selectedDate) {
            print("");
          },),


                // Hospital
                buildFilterDropdown(
                  hint: 'المستشفى...', // Hospital...
                  value: _selectedHospital,
                  items: ["الكل", "مستشفى 1", "مستشفى 2", "وما تنسو تجيبو باقي المستشفيات من الDatabase :)"],
                  onChanged: (newValue) {
                    setState(() {
                      _selectedHospital = newValue!;
                    });
                  },
                ),
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
              ],
            ),
          ),
          Expanded(
            // Allows the ListView to take up the remaining vertical space
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                children: _testingNotifications() // should be removed after link with database
// obtain notifications from database here
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationContainer(Notification notification) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          notification.isRed = true;
        });
        // should take the user to the reporting page with the specific state, locality, and hospital
      },
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
                    if(!notification.isRed)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.circle, size: 8, color: Colors.blue),
                    ),
                    SizedBox(width: 10),
                    Text(
                      notification.getSender(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
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
                    color: notification.isImportant ? Colors.white : Colors
                        .grey[600],
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),


            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(""),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      notification.getTitle(),
                      style: TextStyle(
                        fontSize: 16,
                        color: notification.isImportant ? Colors.white : Colors
                            .black,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),

                Text(
                  notification.timeFormatAMPM(),
                  style: TextStyle(
                    fontSize: 12,
                    color: notification.isImportant ? Colors.white : Colors
                        .grey[600],
                  ),
                  textAlign: TextAlign.right,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _testingNotifications(){
    List<Widget> result = [];
    for(int i =0; i<testingNotifications.length ; i++)
       result.add(_buildNotificationContainer(testingNotifications[i]));
    return result;
  }
}