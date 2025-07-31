import 'package:flutter/material.dart';
import 'package:pc_apps/Backend/hospital.dart';
import 'package:pc_apps/global_ui.dart';
/*
Issues:
  1- show doctors in each department
 */
class HospitalDataScreen extends StatelessWidget {
  Hospital hospital;
  HospitalDataScreen({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Transparent to blend with background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align title to the right
          children: [
            Text(
              'بيانات المستشفى', // Hospital Data
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo', // Example font, use a suitable Arabic font
              ),
              textDirection: TextDirection.rtl, // Right-to-left for Arabic
            ),
            SizedBox(width: 10), // Spacing between text and icon
            Icon(
              Icons
                  .local_hospital_outlined, // Placeholder for the custom icon (clipboard with hospital/person)
              color: Colors.deepPurple,
              size: 35,
            ),
          ],
        ),
        titleSpacing: 0, // Remove default title spacing
      ),
      body: Directionality(textDirection: TextDirection.rtl, child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
              height: 1,
              color: Colors.grey,
            ), // Thin horizontal line below app bar
            const SizedBox(height: 20),
            Row(children: [buildLabel("اسم المستشفى:"), SizedBox(width: 8), buildCard(text:  hospital.getHospitalName())],),
            const SizedBox(height: 8,),
            Row(children: [buildLabel("معلومات الموقع:"), SizedBox(width: 8), buildCard(text: hospital.getHospitalLocationDetails())],),
            const SizedBox(height: 8,),
            Row(children: [buildLabel("رقم الطوارئ:"), SizedBox(width: 8), buildCard(text: hospital.getHospitalEmergencyNumber())],),
            const SizedBox(height: 8,),
            Row(children: [buildLabel("الأقسام:"), SizedBox(width: 8), for(String department in hospital.getDepartmentsNames()) ... [if(department != "الكل") ... [buildCard(text: department, align: Alignment.center)]]],),
            const SizedBox(height: 8,),
          ],
        ),
      )),
    );
  }


  Widget buildCard({required String text, Alignment? align}){
    return Expanded(
      child: Container(
        height: 60,
        padding: EdgeInsetsGeometry.all(8),
        margin: EdgeInsetsGeometry.all(20),
        alignment: align == null ? Alignment.centerRight : align,

        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8)
        ),

        child: Text(text, style: TextStyle(
          fontSize: 18,

        ),),

      ),
    );
  }
}
