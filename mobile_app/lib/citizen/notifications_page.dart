import 'package:flutter/material.dart';
import 'package:mobile_app/styles.dart';
// import 'classes.dart'; // editing the notifiation there

void main(List<String> args) {
  runApp(const NotificationsPageTest());
}

class NotificationsPageTest extends StatelessWidget {
  const NotificationsPageTest({super.key});

  @override
  Widget build(BuildContext) {
    return const Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(home: NotificationsPage()));
  }
} // NotificationsPageTest

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'type': 'booking',
      'title': 'تأكيد الحجز',
      'body': 'تم تأكيد حجزك مع د. سامية عوض في مستشفى بحري يوم الأحد.'
    },
    {
      'type': 'booking',
      'title': 'إلغاء الحجز',
      'body': 'تم إلغاء الحجز الخاص بك في مستشفى أم درمان لظرف طارئ.'
    },
    {
      'type': 'ministry',
      'title': 'تنبيه من وزارة الصحة',
      'body': 'يرجى التوجه إلى أقرب مركز صحي للحصول على تطعيم الإنفلونزا.'
    },
    {
      'type': 'ministry',
      'title': 'إعلان مهم',
      'body':
          'وزارة الصحة تنوه بانقطاع الخدمة في مستشفى مدني يوم الجمعة للصيانة.'
    },
  ];

  Icon _getIcon(String type) {
    if (type == 'booking') {
      return const Icon(Icons.calendar_today, color: Colors.blue);
    } else if (type == 'ministry') {
      return const Icon(Icons.campaign, color: Colors.redAccent);
    } else {
      return const Icon(Icons.notifications);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: appBar('التنبيهات'),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: _getIcon(notification['type']!),
                  title: Text(notification['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notification['body'] ?? ''),
                ),
              );
            },
          )),
    );
  }
}


/**


 */