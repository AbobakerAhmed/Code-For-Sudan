import 'package:flutter/material.dart';
import 'package:mobile_app/backend/citizen/citizen.dart';
import 'package:mobile_app/theme_provider.dart';

class MedicalHistoryPage extends StatelessWidget {
  final Citizen citizen;

  const MedicalHistoryPage({super.key, required this.citizen});

  @override
  Widget build(BuildContext context) {
    final List<String> history = citizen.medicalHistory ?? ["None"];
    final bool noHistory = history.length == 1 && history.first == "None";
    final themeColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('السجل المرضي'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: noHistory
              ? const Center(
                  child: Text(
                    'لا يوجد سجل مرضي حتى الآن',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      shadowColor: Theme.of(context).primaryColor,
                      child: ListTile(
                        leading: const Icon(
                          Icons.medical_services_outlined,
                          color: Colors.lightBlue,
                        ),
                        title: Text(
                          history[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
