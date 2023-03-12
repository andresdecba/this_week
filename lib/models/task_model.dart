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

  Task({required this.description, required this.taskDate, required this.notificationTime, required this.status, required this.subTasks, required this.notificationId});

  Task copyWith({
    required description,
    required taskDate,
    required notificationTime,
    required status,
    required subTasks,
    required notificationId,
  }) {
    return Task(
      description: description,
      taskDate: taskDate,
      notificationTime: notificationTime,
      status: status,
      subTasks: subTasks,
      notificationId: notificationId,
    );
  }

  @override
  String toString() {
    return '{ description: $description, task date: $taskDate, notification date: $notificationTime, status: $status, sub tasks: $subTasks, notification Id: $notificationId }';
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

  @override
  String toString() {
    return '{$title, $isDone}';
  }

  static SubTask copyWith(SubTask value) {
    return SubTask(title: value.title, isDone: value.isDone);
  }
}
