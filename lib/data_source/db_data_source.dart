
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/models/task_model.dart';


abstract class Boxes {
  static Box<Task> getTasksBox() => Hive.box<Task>('tasksBox');
  static Box<List> getDataListBox() => Hive.box<List>('dataListBox');
}

