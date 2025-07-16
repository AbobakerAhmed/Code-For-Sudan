import 'package:flutter/material.dart';

class MedicalHistoryPage extends StatelessWidget {
  // Sample medical history data
  final List<String> medicalHistory = [
    "فحص دوري - طبيعي",
    "لقاح الإنفلونزا",
    "فحص الدم - ارتفاع الكوليسترول",
    "عملية جراحية بسيطة - إزالة الزائدة الدودية",
    "اختبار الحساسية - حساسية من حبوب اللقاح",
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('السجل المرضي'),
        ),
        body: ListView.builder(
          itemCount: medicalHistory.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                title: Text(medicalHistory[index]),
                leading: Icon(Icons.healing),
              ),
            );
          },
        ),
      ),
    );
  }
}
