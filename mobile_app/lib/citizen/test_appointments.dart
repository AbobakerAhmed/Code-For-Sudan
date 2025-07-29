import 'package:flutter/material.dart';
import 'package:mobile_app/backend/registrar/appoinment.dart';
import 'package:mobile_app/firestore_services/firestore.dart';
import 'package:mobile_app/styles.dart';

class AppointmentTestScreen extends StatefulWidget {
  @override
  _AppointmentTestScreenState createState() => _AppointmentTestScreenState();
}

class _AppointmentTestScreenState extends State<AppointmentTestScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  Future<void> _fetchAppointments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _appointments = await _firestoreService.getAppointments(
        'الخرطوم', // Replace with a valid state
        'بحري', // Replace with a valid locality
        'مستشفى بحري', // Replace with a valid hospital name
        'الأسنان', // Replace with a valid department name
      );
    } catch (e) {
      print("Error fetching appointments: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAppointments(); // Fetch appointments when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: appBar(
          "المواعيد",
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _appointments.isEmpty
                ? Center(
                    child: Text("لا يوجد مواعيد بعد"),
                  )
                : ListView.builder(
                    itemCount: _appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = _appointments[index];
                      return ListTile(
                        title: Text(appointment.name ?? 'No Name'),
                        subtitle: Text('Age: ${appointment.age ?? 'N/A'}'),
                        trailing: Text(appointment.doctor ?? 'No Doctor'),
                      );
                    },
                  ),
      ),
    );
  }
}
