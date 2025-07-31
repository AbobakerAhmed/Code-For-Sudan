/**
    Issues:
    1- state and locality field of notification object are used only to be sended to hospital manager. if find anther way chencle them
    2- link with database to upload notifications
    3- test how the ministry employee will be displayed as a sender (commented setState in onPressed fun)
    4- after sending notification successfully, show that and clear all fields
 */

import 'package:flutter/material.dart' hide Notification;
import 'package:ministry_app/Backend/ministry_employee.dart';
import 'package:ministry_app/Backend/notification.dart';
import 'package:ministry_app/Backend/global_var.dart';
import 'global_ui.dart';

class NotificationSendingScreen extends StatefulWidget {
  late final MinistryEmployee employee;
  NotificationSendingScreen({super.key, required this.employee});
  @override
  State<NotificationSendingScreen> createState() =>
      _NotificationSendingScreenState(employee: employee);
}

class _NotificationSendingScreenState extends State<NotificationSendingScreen> {

  late final MinistryEmployee employee;
  String? _selectedRecipient;
  late String _selectedState = this.employee.getState();
  late String _selectedLocality = this.employee.getLocality();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isUrgent = false;
  bool _isPeriodic = false;

  _NotificationSendingScreenState({required this.employee});

  @override
  void dispose() {
    _hospitalNameController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 16),
              Icon(
                Icons.send,
                color: Colors.blue,
                size: 28,
              ), // Send icon (or similar)
              SizedBox(width: 12),
              Text(
                'ارسال الاشعارات', // Send Notifications (Arabic)
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Divider(thickness: 1),
              const SizedBox(height: 16),

              // Send this notification to who?
              buildLabel('الى'),
              _buildDropdownField(
                hint: 'إرسال إشعار إلى ..',
                value: _selectedRecipient,
                items: ['المواطنين', 'المستشفيات', 'مدير مستشفى'],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRecipient = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: Column(
                    children: [
                      // State dropdown for Citizens
                      buildLabel('الولاية'), // State... (Arabic)
                      _buildDropdownField(
                        hint: 'اختر الولاية', // State...
                        value: _selectedState,
                        items: this.employee.getState() == "الكل" ? g_states : [this.employee.getState()],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedState = newValue!;
                          });
                        },
                      ),
                      const SizedBox(width: 16),

                      buildLabel('المحلية'), // Locality... (Arabic)
                      _buildDropdownField(
                        hint: 'اختار المحلية', // Locality...
                        value: _selectedLocality,
                        items: this.employee.getLocality() == "الكل" ?
                                  g_localities[_selectedState]! :
                                              [this.employee.getLocality()],

                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLocality = newValue!;
                          });
                        },
                      ),
                    ],
                  )),

                ]),

              const SizedBox(height: 16),


              // Conditional fields based on recipient type
              if (_selectedRecipient == 'مدير مستشفى') ...[
                // Hospital Name input for Hospitals (or initially when no recipient selected)
                buildLabel('المستشفى'), // Hospital (Arabic)
                _buildTextField(
                  controller: _hospitalNameController,
                  hintText: 'اكتب اسم المستشفى...', // Type hospital name...
                ),

                const SizedBox(height: 16),

              ],

              // Subject
              buildLabel('موضوع الرسالة'), // Subject (Arabic)
              _buildTextField(
                controller: _subjectController,
                hintText: 'موضوع الرسالة...', // Message subject...
              ),
              const SizedBox(height: 16),

              // Message Body
              buildLabel('نص الرسالة'), // Text (Arabic)
              _buildTextField(
                controller: _messageController,
                hintText: 'نص الرسالة...', // Message text...
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Message Type (Urgent/Periodic)
              buildLabel('نوع الرسالة'), // Message Type (Arabic)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'اشعار',
                    style: TextStyle(color: Colors.black87),
                  ), // Periodic Notification
                  Checkbox(
                    value: _isPeriodic,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isPeriodic = newValue ?? false;
                        if (_isPeriodic)
                          _isUrgent = false; // Only one can be selected
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  Text(
                    'محتوى طارئ',
                    style: TextStyle(color: Colors.red),
                  ), // Urgent Content
                  Checkbox(
                    value: _isUrgent,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isUrgent = newValue ?? false;
                        if (_isUrgent)
                          _isPeriodic = false; // Only one can be selected
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Send Message Button
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  onPressed: () {
                    if ((!_isUrgent&&!_isPeriodic) || _selectedState == null || _selectedLocality == null || _subjectController.text.isEmpty || _messageController.text.isEmpty ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("يرجى تعبئة جميع الحقول المطلوبة")),
                      );
                      return;
                    }

                    Notification newNotification = Notification(
                       receiverState:  _selectedState,
                       receiverLocality:  _selectedLocality,
                        sender:  employee.asSender(),
                        title: _subjectController.text,
                        massage: _messageController.text,
                        isImportant:  _isUrgent,
                        creationTime:  DateTime.now()
                    );
                    setState(() {

                    });
// TODO: Send newNotification to database (depending on: _selectedRecipient, _selectedState!, _selectedLocality!,)

                    print('Send Message Tapped!');
                    print('Recipient: $_selectedRecipient');
                    print('State: $_selectedState');
                    print('Locality: $_selectedLocality');
                    print('Hospital Name: ${_hospitalNameController.text}');
                    print('Subject: ${_subjectController.text}');
                    print('Message: ${_messageController.text}');
                    print('Is Urgent: $_isUrgent');
                    print('Is Periodic: $_isPeriodic');
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blueAccent.shade400, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'ارسال الرسالة', // Send Message (Arabic)
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool? isExpanded
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: isExpanded == false ? false : true,
            hint: Text(hint, style: const TextStyle(color: Colors.grey)),
            value: value,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: TextAlign.right, // Align text to the right
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
      ),
    );
  }
}
