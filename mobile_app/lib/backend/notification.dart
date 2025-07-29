import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum to represent the different types of notifications in the app.
/// This provides better type safety than using plain strings.
enum NotificationType {
  /// For booking confirmations, cancellations, and updates.
  booking,

  /// For general announcements from the Ministry of Health.
  ministry,

  /// For other alerts, like a reminder that it's the patient's turn.
  alert,
}

/// A model class representing a single notification.
///
/// This class is designed to replace the hardcoded `Map<String, String>`
/// used in `citizen/notifications_page.dart` and `doctor/doctor_notifications_page.dart`.
/// It includes additional fields like `timestamp` and `isRead` for a more
/// complete notification system that can be stored and retrieved from Firestore.
class Notify {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String
      recipientId; // e.g., user's phone number or a topic name for broadcast
  final Map<String, dynamic>?
      relatedData; // e.g., {'appointmentId': '...'} for navigation

  Notify({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    required this.recipientId,
    this.relatedData,
  });

  /// Helper to convert enum to a string for Firestore storage.
  String get typeAsString => type.name;

  /// Factory constructor to create a `Notification` instance from a Firestore document.
  factory Notify.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Notify(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () =>
            NotificationType.alert, // Default value if type is unknown
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      recipientId: data['recipientId'] ?? '',
      relatedData: data['relatedData'] as Map<String, dynamic>?,
    );
  }

  /// Method to convert a `Notification` instance to a map for Firestore storage.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'type': typeAsString,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'recipientId': recipientId,
      if (relatedData != null) 'relatedData': relatedData,
    };
  }
}
