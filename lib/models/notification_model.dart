import 'package:hive_flutter/hive_flutter.dart';
part 'notification_model.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// 1° este:            flutter packages pub run build_runner build
/// si sale mal, este:  flutter packages pub run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 2)
class NotificationModel {
  NotificationModel({
    this.id, // crear con helpers > createNotificationId()
    this.body, // generalmente es tipo subtitulo: "recordatorio de tarea"
    required this.title, // es la descripción de la tarea
    required this.time, // la hora de la notificacion
    required this.payload, // carga de datos, generalmente una ruta o el id de la tarea (task.value.key.toString())
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? body;
  @HiveField(2)
  String title;
  @HiveField(3)
  DateTime time;
  @HiveField(4)
  String payload;

  @override
  String toString() {
    return '{ id: $id, body: $body, title: $title, time: $time, payload: $payload }';
  }
}
