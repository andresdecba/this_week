import 'package:hive/hive.dart';
part 'task_model.g.dart';

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
  String description;
  @HiveField(2)
  bool isDone;
  @HiveField(3)
  int index;

  SubTask({
    required this.title,
    required this.description,
    required this.isDone,
    required this.index,
  });

  @override
  String toString() {
    return '{$title, $description}';
  }

  static SubTask copyWith(SubTask value) {
    return SubTask(title: value.title, description: value.description, isDone: value.isDone, index: value.index);
  }
}

/// VER !
enum Status { PENDING, IN_PROGRESS, DONE }

extension StatusString on Status {
  String get status {
    switch (this) {
      case Status.PENDING:
        return 'PENDING';
      case Status.IN_PROGRESS:
        return 'IN PROGRESS';
      case Status.DONE:
        return 'DONE';
    }
  }
}
