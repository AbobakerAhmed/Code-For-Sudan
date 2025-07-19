import 'package:flutter/material.dart';

class DiagnosisScreen extends StatefulWidget {
  final String patientName;

  const DiagnosisScreen({super.key, required this.patientName});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String? _selectedEpidemic;
  bool _addToMedicalHistory = false;

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
            Text(
              'الحجز', // Booking
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align contents to the right
          children: [
            Text(
              'المريض: ${widget.patientName}', // Patient: [Patient Name]
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'التشخيص', // Diagnosis
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              textAlign: TextAlign.right,
              maxLines: 4, // Allow multiple lines for diagnosis
              decoration: InputDecoration(
                hintText: 'التشخيص...', // Diagnosis...
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'حالة وبائية', // Epidemic Status
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedEpidemic,
                  hint: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اسم الوباء...', // Epidemic Name...
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEpidemic = newValue;
                    });
                  },
                  items:
                      <String>[
                            'لا يوجد',
                            'كوفيد-19',
                            'الجدري',
                            'الحصبة',
                          ] // Example epidemic names
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(value, textAlign: TextAlign.right),
                              ),
                            );
                          })
                          .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Checkbox for "Add to medical history"
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _addToMedicalHistory = !_addToMedicalHistory;
                    });
                  },
                  child: Text(
                    'اضافة الى التاريخ المرضي', // Add to medical history
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 16),
                  ),
                ),
                Transform.scale(
                  scale: 1.2, // Adjust the size of the switch
                  child: Switch(
                    value: _addToMedicalHistory,
                    onChanged: (bool value) {
                      setState(() {
                        _addToMedicalHistory = value;
                      });
                    },
                    activeColor: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Send Diagnosis Button
            SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton(
                onPressed: () {
                  // Handle sending diagnosis
                  print('Sending diagnosis for ${widget.patientName}');
                  print('Diagnosis: [text from TextField]');
                  print('Epidemic Status: $_selectedEpidemic');
                  print('Add to Medical History: $_addToMedicalHistory');
                  // Typically, you'd send this data to a backend or process it
                  Navigator.pop(context); // Go back after sending
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue.shade700, // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'ارسال التشخيص', // Send Diagnosis
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
