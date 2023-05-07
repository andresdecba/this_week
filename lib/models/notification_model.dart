import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.body,
    required this.title,
    required this.time,
    required this.payload,
  });

  final int id;
  final String body;
  final String title;
  final DateTime time;
  final String payload;
}
