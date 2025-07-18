import 'package:flutter/material.dart';
import 'package:mobile_app/backend/doctor/doctor.dart';

class BookedAppointmentsPage extends StatefulWidget {
  final Doctor doctor; // which docotr (look doctor.dart in the backend folder)
  const BookedAppointmentsPage(
      {super.key, required this.doctor}); // constructor

  @override
  State<BookedAppointmentsPage> createState() => _BookedAppointmentsPageState();
}

class _BookedAppointmentsPageState extends State<BookedAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
