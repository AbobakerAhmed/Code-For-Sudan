/* Date: 21st of Jun 2025 */

// import basic ui components
import 'package:flutter/material.dart';

// import backend file
import 'package:url_launcher/url_launcher.dart'; // call api
import 'package:mobile_app/firestore_services/firestore.dart';
import 'package:mobile_app/backend/hospital.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// test emegencyPage alone
void main(List<String> args) {
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

// base class
class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
} // EmergencyPage

// class
class _EmergencyPageState extends State<EmergencyPage> {
  final FirestoreService _firestoreService =
      FirestoreService(); // define the database objcet

  // define variables
  List<String> _dbStates = [];
  List<String> _dbLocalities = [];
  Map<String, Map<String, List<HospitalEmergency>>> _dbEmergencyData = {};
  String? selectedState;
  String? selectedLocality;

  /// fun: get states from database
  Future<void> _getStates() async {
    try {
      final statesAndLocalities =
          await _firestoreService.getStatesAndLocalities();
      final states = statesAndLocalities.keys.toList();
      setState(() {
        _dbStates = states;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  /// fun: get localities from database
  Future<void> _getLocalities(String state) async {
    try {
      final statesAndLocalities =
          await _firestoreService.getStatesAndLocalities();
      final localities = statesAndLocalities[state];
      setState(() {
        _dbLocalities = localities!;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  /// fun: get emergency numbers from database
  Future<void> _getHospitalsEmergencyData() async {
    try {
      final data = await _firestoreService.getHospitalsEmergencyData();
      setState(() {
        _dbEmergencyData = data;
      });
    } catch (e) {
      print("Error fetching emergency data: $e");
    }
  }

  //displayed hospitals:
  List<HospitalEmergency> get emergencyNumbers {
    if (selectedState != null && selectedLocality != null) {
      return _dbEmergencyData[selectedState!]![selectedLocality!] ?? [];
    } // if
    else if (selectedState != null) {
      // إذا لم يحدد المحلية، نرجع جميع المستشفيات في الولاية
      return _dbEmergencyData[selectedState!]!
          .values
          .expand((list) => list)
          .toList();
    } // else if
    else {
      // إذا لم يحدد الولاية، نرجع كل المستشفيات
      return _dbEmergencyData.values
          .expand((map) => map.values)
          .expand((list) => list)
          .toList();
    } // else
  } // hospitals

  /// fun: connecting with the caller app in the phone and copy the hospital number on it
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

  // fun: check internet connectivity
  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.mobile ||
        connectivityResult[0] == ConnectivityResult.wifi) {
      return true; // Connected to either mobile data or WiFi
    }
    return false; // Not connected
  }

  // initialize the widget state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHospitalsEmergencyData();
    _getStates();
  }

  // build the app
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // arabic lang
      child: Scaffold(
        appBar: AppBar(title: Text("الطوارئ - الخطوط الساخنة")),
        body: emergencyNumbers.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                    SizedBox(
                      height: 30,
                    ),
                    Text("كيف حالك")
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // state filters
                    DropdownButtonFormField<String>(
                      dropdownColor: Theme.of(context).cardColor,
                      decoration: InputDecoration(
                        labelText: 'الولاية',
                        labelStyle: TextStyle(color: Colors.grey),
                        floatingLabelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                      ),
                      value: selectedState,
                      items: _dbStates
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: Theme.of(context).textTheme.labelMedium,
                              )))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedState = val;
                          selectedLocality = null;
                          _dbLocalities = [];
                          _getLocalities(selectedState!);
                        });
                      },
                    ),

                    // dividing between state fillter and locality fillter
                    const SizedBox(height: 12),

                    // locality fillter
                    DropdownButtonFormField<String>(
                      dropdownColor: Theme.of(context).cardColor,
                      decoration: InputDecoration(
                        labelText: 'المحلية',
                        labelStyle: TextStyle(color: Colors.grey),
                        floatingLabelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                      ),
                      value: selectedLocality,
                      items: _dbLocalities
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: Theme.of(context).textTheme.labelMedium,
                              )))
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
                          ? const Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.lightBlue,
                                )
                              ],
                            ))
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
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16)),
                                    subtitle: Text(hospital.phone,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.call,
                                          color: Colors.green),
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

  /// fun: showing call dialog that
  void _showCallDialog(String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          ': اتصال بالرقم',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              phone,
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.call),
              label: Text('اتصال', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.green,
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
