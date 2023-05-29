import 'package:todoapp/data_source/local_notifications_data_source/local_notifications_data_source.dart';

abstract class LocalNotificationRepository {
  Future<void> createNotification({required DateTime datetime, required String title, required String payload, String? body});
  Future<void> deleteNotification({required int notificationId});
  Future<void> deleteAllNotification();
}

class LocalNotificationRepositoryImpl implements LocalNotificationRepository {
  @override
  Future<void> createNotification({
    required DateTime datetime,
    required String title,
    required String payload,
    String? body,
  }) async {
    await LocalNotificationsDataSource.createNotification(
      datetime: datetime,
      title: title,
      payload: payload,
    );
  }

  @override
  Future<void> deleteNotification({required int notificationId}) async {
    LocalNotificationsDataSource.deleteNotification(notificationId: notificationId);
  }

  @override
  Future<void> deleteAllNotification() async {
    await LocalNotificationsDataSource.deleteAllNotifications();
  }
}
