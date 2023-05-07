
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
