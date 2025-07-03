// Date: 21st of Jun 2025
import 'package:flutter/material.dart';
import 'package:registrar_app/styles.dart'; // appBar style
import 'package:url_launcher/url_launcher.dart'; // call api
import 'package:registrar_app/firestore_services/firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//import 'backend/hospital.dart';
//import 'backend/globalVar.dart';
//import 'backend/hospitalsdata.dart';

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

// EmergencyPage builder
class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
} // EmergencyPage

// EmergencyPage conent
class _EmergencyPageState extends State<EmergencyPage> {
  FirestoreService _firestoreService = FirestoreService();
  List<String> _dbStates = [];
  List<String> _dbLocalities = [];
  //List<String> _dbHospitals = [];

  Map<String, Map<String, List<HospitalEmergency>>> _dbEmergencyData = {};
  bool _isConnected = false;
  //getting the data from data.dart in the correct mentioned formation
  // Map<String, Map<String, List<HospitalEmergency>>>? data =
  //     HospitalsData.emergencyData();

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

  //
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

  //   Future<void> _getHospitals(String state, String locality) async {
  //   try {
  //     final hospitals = await _firestoreService
  //         .getHospitalsWithDepartmentsAndDoctors(state, locality);
  //     final names = hospitals.map((hospital) => hospital.name).toList();
  //     setState(() {
  //       _dbHospitals = names;
  //     });
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  // fileters
  String? selectedState;
  String? selectedLocality;

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

  //   List<HospitalEmergency> get emergencyNumbers {
  //   if (selectedState != null && selectedLocality != null) {
  //     return HospitalsData
  //             .hospitalsEmergencyData[selectedState!]![selectedLocality!] ??
  //         [];
  //   } // if
  //   else if (selectedState != null) {
  //     // إذا لم يحدد المحلية، نرجع جميع المستشفيات في الولاية
  //     return HospitalsData.hospitalsEmergencyData[selectedState!]!.values
  //         .expand((list) => list)
  //         .toList();
  //   } // else if
  //   else {
  //     // إذا لم يحدد الولاية، نرجع كل المستشفيات
  //     return HospitalsData.hospitalsEmergencyData.values
  //         .expand((map) => map.values)
  //         .expand((list) => list)
  //         .toList();
  //   } // else
  // } // hospitals

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

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.mobile ||
        connectivityResult[0] == ConnectivityResult.wifi) {
      return true; // Connected to either mobile data or WiFi
    }
    return false; // Not connected
  }

  Future<void> _checkConnectivity() async {
    _isConnected = await isConnectedToInternet();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_checkConnectivity();
    _getHospitalsEmergencyData();
    _getStates();
  }

  // build fun
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
                    CircularProgressIndicator(),
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
                      dropdownColor: Theme.of(context).primaryColorLight,
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
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      dropdownColor: Theme.of(context).primaryColorLight,
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
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.bold),
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
                              children: [CircularProgressIndicator()],
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
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16)),
                                    subtitle: Text(hospital.phone,
                                        style: const TextStyle(
                                            color: Colors.redAccent)),
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

  // showing call dialog that
  void _showCallDialog(String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(': اتصال بالرقم', textAlign: TextAlign.right),
        backgroundColor: Theme.of(context).primaryColorLight,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              phone,
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
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
