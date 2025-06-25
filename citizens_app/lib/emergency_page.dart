// Date: 21st of Jun 2025
import 'package:flutter/material.dart';
import 'styles.dart'; // appBar style
import 'package:url_launcher/url_launcher.dart'; // call api
import 'backend/hospital.dart';
import 'backend/globalVar.dart';
import 'backend/hospitalsdata.dart';

/*
  Emergency Page
    - This page displays the hot line of each hospital
    - You can fillter the displayed hospitals by the state and locality
    - When pressing a phone number of any hospital, its hot line number
      will be copied to the call app in your phone and you have just to press (call)

dependencies used in pubspec.yaml:
dependencies:
  url_launcher: ^6.1.10

*/

// test emegencyPage alone
void main() {
  runApp(const EmergencyPageTest());
} // main

class EmergencyPageTest extends StatelessWidget {
  const EmergencyPageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(home: EmergencyPage()));
  }
} //EmergencyPageTest

// EmergencyPage builder
class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
} // EmergencyPage

// EmergencyPage conent
class _EmergencyPageState extends State<EmergencyPage> {
  //getting the data from data.dart in the correct mentioned formation
  // Map<String, Map<String, List<HospitalEmergency>>>? data =
  //     HospitalsData.emergencyData();

  // fileters
  String? selectedState;
  String? selectedLocality;

  //displayed hospitals:
  List<HospitalEmergency> get emergencyNumbers {
    if (selectedState != null && selectedLocality != null) {
      return HospitalsData
              .hospitalsEmergencyData[selectedState!]![selectedLocality!] ??
          [];
    } // if
    else if (selectedState != null) {
      // إذا لم يحدد المحلية، نرجع جميع المستشفيات في الولاية
      return HospitalsData.hospitalsEmergencyData[selectedState!]!.values
          .expand((list) => list)
          .toList();
    } // else if
    else {
      // إذا لم يحدد الولاية، نرجع كل المستشفيات
      return HospitalsData.hospitalsEmergencyData.values
          .expand((map) => map.values)
          .expand((list) => list)
          .toList();
    } // else
  } // hospitals

  // connecting with the caller app in the phone and copy the hospital number on it
  void _makePhoneCall(String phone) async {
    final Uri telUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } // if
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر الاتصال بالرقم')),
      );
    } // else
  } //_makePhoneCall

  // build fun
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: Scaffold(
        appBar: appBar('الطوارئ - الخطوط الساخنة'), // styles.dart
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // state filters
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'الولاية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                value: selectedState,
                items: g_states
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedState = val;
                    selectedLocality = null;
                  });
                },
              ),

              // dividing between state fillter and locality fillter
              const SizedBox(height: 12),

              // locality fillter
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'المحلية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                value: selectedLocality,
                items: (g_localities[selectedState] ?? [])
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedLocality = val;
                  });
                },
              ),

              // dividing between locality fillter and displayied hospitlas
              const SizedBox(height: 20),

              // displaying hospitals and thier hot lines
              Expanded(
                child: emergencyNumbers.isEmpty
                    ? const Center(child: Text('لا توجد مستشفيات لعرضها'))
                    : ListView.builder(
                        itemCount: emergencyNumbers.length,
                        itemBuilder: (context, index) {
                          final hospital = emergencyNumbers[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(hospital.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              subtitle: Text(hospital.phone,
                                  style: const TextStyle(
                                      color: Colors.blueAccent)),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.call, color: Colors.green),
                                onPressed: () =>
                                    _showCallDialog(hospital.phone),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  } // build fun

  // showing call dialog that
  void _showCallDialog(String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال بالرقم', textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الرقم: $phone'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.call),
              label: const Text('اتصال'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.red,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _makePhoneCall(phone); // go to the call app in the phone
              },
            ),
          ],
        ),
      ),
    );
  }
}

// hospital object here must be edited after creating our class
// HospitalEmergency

/*

// maybe added in the beginning of the page later: First Aids
 Card(
                color: Colors.red[50],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.monitor_heart_outlined,
                      color: Colors.red, size: 32),
                  title: Text(
                    'الإسعافات الأولية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                  onTap: () {
                    // يمكنك توصيله لاحقًا بصفحة الإسعافات الأولية
                  },
                ),
              ),
              SizedBox(height: 30),
 */
