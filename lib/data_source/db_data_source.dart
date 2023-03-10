
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/models/my_app_config.dart';

abstract class Boxes {
  static Box<Task> getTasksBox() => Hive.box<Task>('tasksBox');
  static Box<MyAppConfig> getMyAppConfigBox() => Hive.box<MyAppConfig>('myAppConfigBox');
}

////// IMPORTANT //////
/// the key for configuration json is: 'appConfig'
/// call it:
/// Box<MyAppConfig> userPrefs = Boxes.getMyAppConfigBox();
/// MyAppConfig config = userPrefs.get('appConfig')!;