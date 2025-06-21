import 'package:flutter/material.dart';
import 'styles.dart';
// import 'classes.dart'; // editing the notifiation there

void main(List<String> args) {
  runApp(NotificationsPageTest());
}

class NotificationsPageTest extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(home: NotificationsPage()));
  }
} // NotificationsPageTest

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
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
      return Icon(Icons.calendar_today, color: Colors.blue);
    } else if (type == 'ministry') {
      return Icon(Icons.campaign, color: Colors.redAccent);
    } else {
      return Icon(Icons.notifications);
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
                      style: TextStyle(fontWeight: FontWeight.bold)),
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