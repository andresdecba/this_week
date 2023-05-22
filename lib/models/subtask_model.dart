import 'package:hive_flutter/hive_flutter.dart';
part 'subtask_model.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// 1° este:            flutter packages pub run build_runner build
/// si sale mal, este:  flutter packages pub run build_runner build --delete-conflicting-outputs

/// si o si hay que pasar este modelo por hive, no borrar por que si no da error

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
    return '{title: $title, is done: $isDone}';
  }
}
