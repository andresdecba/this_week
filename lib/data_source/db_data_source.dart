
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/models/my_app_config.dart';

abstract class Boxes {
  static Box<Task> getTasksBox() => Hive.box<Task>('tasksBox');
  static Box<MyAppConfig> getAppConfig() => Hive.box<MyAppConfig>('myAppConfig');
}

