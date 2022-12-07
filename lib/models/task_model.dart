import 'package:hive/hive.dart';
part 'task_model.g.dart';


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
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  DateTime dateTime;
  @HiveField(4)
  String status;
  @HiveField(5)
  List<SubTask> subTasks;

  Task({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.status,
    required this.subTasks,
  });

  @override
  String toString() {
    return '{ $title, $description, $dateTime, $status, $subTasks }';
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
