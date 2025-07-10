import 'package:flutter/material.dart';

class NotificationSendingScreen extends StatefulWidget {
  const NotificationSendingScreen({super.key});

  @override
  State<NotificationSendingScreen> createState() =>
      _NotificationSendingScreenState();
}

class _NotificationSendingScreenState extends State<NotificationSendingScreen> {
  String? _selectedRecipient;
  String? _selectedState;
  String? _selectedLocality;
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isUrgent = false;
  bool _isPeriodic = false;

  final List<String> _recipients = [
    'المستشفيات',
    'المواطنين',
  ]; // Hospitals, Citizens
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'ارسال الاشعارات', // Send Notifications (Arabic)
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.send,
                color: Colors.blue,
                size: 28,
              ), // Send icon (or similar)
            ],
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align labels to the right
          children: [
            const Divider(thickness: 1),
            const SizedBox(height: 16),

            // To (Recipient) dropdown
            _buildLabel('الى'), // To (Arabic)
            _buildDropdownField(
              hint: 'المستشفيات', // Hospitals (default hint)
              value: _selectedRecipient,
              items: _recipients,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRecipient = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Conditional fields based on recipient type
            if (_selectedRecipient == 'المواطنين') ...[
              // State dropdown for Citizens
              _buildLabel('الولاية...'), // State... (Arabic)
              _buildDropdownField(
                hint: 'الولاية...', // State...
                value: _selectedState,
                items: _states,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Locality dropdown for Citizens
              _buildLabel('المحلية...'), // Locality... (Arabic)
              _buildDropdownField(
                hint: 'المحلية...', // Locality...
                value: _selectedLocality,
                items: _localities,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocality = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
            ] else if (_selectedRecipient == 'المستشفيات' ||
                _selectedRecipient == null) ...[
              // Hospital Name input for Hospitals (or initially when no recipient selected)
              _buildLabel('المستشفى'), // Hospital (Arabic)
              _buildTextField(
                controller: _hospitalNameController,
                hintText: 'اكتب اسم المستشفى...', // Type hospital name...
              ),
              const SizedBox(height: 16),
            ],

            // Subject
            _buildLabel('الموضوع'), // Subject (Arabic)
            _buildTextField(
              controller: _subjectController,
              hintText: 'موضوع الرسالة...', // Message subject...
            ),
            const SizedBox(height: 16),

            // Message Body
            _buildLabel('النص'), // Text (Arabic)
            _buildTextField(
              controller: _messageController,
              hintText: 'نص الرسالة...', // Message text...
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // Message Type (Urgent/Periodic)
            _buildLabel('نوع الرسالة'), // Message Type (Arabic)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'اشعار دوري',
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
            ),
            const SizedBox(height: 32),

            // Send Message Button
            SizedBox(
              width: double.infinity, // Full width button
              child: ElevatedButton(
                onPressed: () {
                  // Handle sending message
                  print('Send Message Tapped!');
                  print('Recipient: $_selectedRecipient');
                  print('State: $_selectedState');
                  print('Locality: $_selectedLocality');
                  print('Hospital Name: ${_hospitalNameController.text}');
                  print('Subject: ${_subjectController.text}');
                  print('Message: ${_messageController.text}');
                  print('Is Urgent: $_isUrgent');
                  print('Is Periodic: $_isPeriodic');
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
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
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
            isExpanded: true,
            hint: Text(hint, style: const TextStyle(color: Colors.grey)),
            value: value,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, textDirection: TextDirection.rtl),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
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
      ),
    );
  }
}
