import 'package:hive/hive.dart';
part 'task_model.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// 1° este:            flutter packages pub run build_runner build
/// si sale mal, este:  flutter packages pub run build_runner build --delete-conflicting-outputs

enum TaskStatus { PENDING, IN_PROGRESS, DONE }

extension TaskStatusExtension on TaskStatus {
  String get toValue {
    switch (this) {
      case TaskStatus.PENDING:
        return 'Pending';
      case TaskStatus.IN_PROGRESS:
        return 'In progress';
      case TaskStatus.DONE:
        return 'Done';
    }
  }
}

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(1)
  String description;
  @HiveField(2)
  DateTime taskDate;
  @HiveField(3)
  String status;
  @HiveField(4)
  DateTime? notificationTime;
  @HiveField(5)
  List<SubTaskModel> subTasks;
  @HiveField(6)
  int? notificationId;
  @HiveField(7)
  String? repeatId; // si esta tarea se repite todos los dias o no (rutina)

  TaskModel({
    required this.description,
    required this.taskDate,
    required this.notificationTime,
    required this.status,
    required this.subTasks,
    required this.notificationId,
    required this.repeatId,
  });

  TaskModel copyWith({
    required String description,
    required DateTime taskDate,
    required String status,
    required DateTime? notificationTime,
    required List<SubTaskModel> subTasks,
    required int? notificationId,
    required String? repeatId,
  }) {
    return TaskModel(
      description: description,
      taskDate: taskDate,
      notificationTime: notificationTime,
      status: status,
      subTasks: subTasks,
      notificationId: notificationId,
      repeatId: repeatId,
    );
  }

  @override
  String toString() {
    return '{ description: $description, task date: $taskDate, notification date: $notificationTime, status: $status, sub tasks: $subTasks, notification Id: $notificationId, repeat Id: $repeatId }';
  }
}

@HiveType(typeId: 1)
class SubTaskModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  bool isDone;

  SubTaskModel({
    required this.title,
    required this.isDone,
  });

  SubTaskModel copyWith({
    required String value,
    required bool isDone,
  }) {
    return SubTaskModel(
      title: title,
      isDone: isDone,
    );
  }

  @override
  String toString() {
    return '{$title, $isDone}';
  }
}
