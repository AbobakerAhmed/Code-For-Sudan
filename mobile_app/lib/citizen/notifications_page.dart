import 'package:flutter/material.dart';
import 'package:mobile_app/backend/citizen/citizen.dart';
import 'package:mobile_app/backend/notification.dart';
import 'package:mobile_app/firestore_services/firestore.dart';

class NotificationsPage extends StatefulWidget {
  final Citizen? citizen;
  const NotificationsPage({super.key, this.citizen});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Notify> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      // Check if citizen is null before proceeding
      if (widget.citizen == null || widget.citizen!.phoneNumber.isEmpty) {
        // Handle the case where citizen or phone number is null
        return;
      }
      if (mounted) {
        _notifications = await _firestoreService
            .getNotifications(widget.citizen!.phoneNumber);
        setState(() {
          // Fetch notifications
          _isLoading = false;
        });
      }
    } catch (e) {
      // It's good practice to handle potential errors
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
            : _notifications.isEmpty
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
