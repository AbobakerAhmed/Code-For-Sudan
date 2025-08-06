// import basic ui components
import 'package:flutter/material.dart';

// import backend files
import 'package:mobile_app/backend/registrar/registrar.dart';
import 'package:mobile_app/backend/notification.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

// base class
class RegistrarNotificationsPage extends StatefulWidget {
  final Registrar registrar;

  const RegistrarNotificationsPage({super.key, required this.registrar});

  @override
  State<RegistrarNotificationsPage> createState() =>
      _RegistrarNotificationsPageState();
}

// class
class _RegistrarNotificationsPageState
    extends State<RegistrarNotificationsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Notify> _notifications = [];
  bool _isLoading = true;

  // this fun initalize the page
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  /// fun: fetch notifications from database
  Future<void> _fetchNotifications() async {
    try {
      final notifications = await _firestoreService
          .getNotifications(widget.registrar.phoneNumber);
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء تحميل التنبيهات.')),
      );
    }
  }

  /// fun: get icon according to the notification type
  Icon _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const Icon(Icons.calendar_today, color: Colors.blue);
      case NotificationType.ministry:
        return const Icon(Icons.campaign, color: Colors.redAccent);
      case NotificationType.alert:
      default:
        return const Icon(Icons.notifications, color: Colors.orange);
    }
  }

  // build the app
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("التنبيهات")),
        body: _isLoading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("كيف حالك"),
                ],
              ))
            : _notifications.isEmpty // if no notifications
                ? Center(
                    child: Text(
                      'لا توجد تنبيهات جديدة.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: _getIcon(notification.type),
                          title: Text(notification.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(notification.body),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
