import 'package:hive/hive.dart';
import 'package:todoapp/models/notification_model.dart';
import 'package:todoapp/models/subtask_model.dart';
part 'task_model.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// 1° este:            flutter packages pub run build_runner build
/// si sale mal, este:  flutter packages pub run build_runner build --delete-conflicting-outputs

enum TaskStatus { PENDING, IN_PROGRESS, DONE }

const String pendingConst = 'Pending';
const String inProgressConst = 'In progress';
const String doneConst = 'Done';

extension TaskStatusExtension on TaskStatus {
  String get toStringValue {
    switch (this) {
      case TaskStatus.PENDING:
        return pendingConst;
      case TaskStatus.IN_PROGRESS:
        return inProgressConst;
      case TaskStatus.DONE:
        return doneConst;
    }
  }
}

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(1)
  String description;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  String status;
  @HiveField(4)
  List<SubTaskModel> subTasks;
  @HiveField(5)
  String? repeatId; // si esta tarea se repite todos los dias o no (rutina)
  @HiveField(6)
  NotificationModel? notificationData;
  @HiveField(7)
  String id;

  TaskModel({
    required this.id,
    required this.description,
    required this.date,
    required this.status,
    required this.subTasks,
    this.repeatId,
    this.notificationData,
  });

  TaskModel copyWith({
    required String id,
    required String description,
    required DateTime taskDate,
    required String status,
    required List<SubTaskModel> subTasks,
    String? repeatId,
    NotificationModel? notificationData,
  }) {
    return TaskModel(
      id: id,
      description: description,
      date: taskDate,
      status: status,
      subTasks: subTasks,
      repeatId: repeatId,
      notificationData: notificationData,
    );
  }

  @override
  String toString() {
    return '{ id: $id, description: $description, task date: $date, status: $status, sub tasks: $subTasks, repeat Id: $repeatId, notification data: $notificationData }';
  }
}
