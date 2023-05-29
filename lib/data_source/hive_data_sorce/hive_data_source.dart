
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/models/app_config_model.dart';

abstract class Boxes {
  static Box<TaskModel> getTasksBox() => Hive.box<TaskModel>('tasksBox');
  static Box<AppConfigModel> getMyAppConfigBox() => Hive.box<AppConfigModel>('myAppConfigBox');
}

////// IMPORTANT //////
/// the key for configuration json is: 'appConfig'
/// call it:
/// Box<MyAppConfig> userPrefs = Boxes.getMyAppConfigBox();
/// MyAppConfig config = userPrefs.get('appConfig')!;