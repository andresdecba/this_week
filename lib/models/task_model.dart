import 'package:hive/hive.dart';
part 'task_model.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// flutter packages pub run build_runner build

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
class Task extends HiveObject {
  @HiveField(1)
  String description;
  @HiveField(2)
  DateTime taskDate;
  @HiveField(3)
  String status;
  @HiveField(4)
  DateTime? notificationTime;
  @HiveField(5)
  List<SubTask> subTasks;
  @HiveField(6)
  int? notificationId;
  @HiveField(7)
  String? repeatId;

  Task({
    required this.description,
    required this.taskDate,
    required this.notificationTime,
    required this.status,
    required this.subTasks,
    required this.notificationId,
    required this.repeatId,
  });

  Task copyWith({
    required String description,
    required DateTime taskDate,
    required String status,
    required DateTime? notificationTime,
    required List<SubTask> subTasks,
    required int? notificationId,
    required String? repeatId,
  }) {
    return Task(
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
class SubTask {
  @HiveField(0)
  String title;
  @HiveField(1)
  bool isDone;

  SubTask({
    required this.title,
    required this.isDone,
  });

  SubTask copyWith({
    required String value,
    required bool isDone,
  }) {
    return SubTask(
      title: title,
      isDone: isDone,
    );
  }

  @override
  String toString() {
    return '{$title, $isDone}';
  }
}
