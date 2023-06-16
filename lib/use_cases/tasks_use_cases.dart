import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/data_source/hive_data_sorce/hive_data_source.dart';
import 'package:todoapp/models/app_config_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/data_source/local_notifications_data_source/local_notifications_data_source.dart';
import 'package:todoapp/ui/initial_page/build_week_controller.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/use_cases/local_notifications_use_cases.dart';
import 'package:uuid/uuid.dart';

abstract class TasksUseCases {
  Future<TaskModel> createTaskUseCase({
    required String description,
    required DateTime date,
    required bool isRoutine,
    DateTime? notificationDateTime,
  });
  void readTaskUseCase({
    required Rx<TaskModel> task,
  });
  void updateTaskState({
    required Rx<TaskModel> task,
    bool? isDateUpdated,
  });
  void deleteTaskUseCase({
    required Rx<TaskModel> task,
    required bool deleteRoutine,
  });
}

class TaskUseCasesImpl implements TasksUseCases {
  //
  final LocalNotificationsUseCases _localNotificationsUseCases = LocalNotificationsUseCases();
  final tasksBox = Boxes.getTasksBox();
  Box<AppConfigModel> userPrefs = Boxes.getMyAppConfigBox();

  @override
  Future<TaskModel> createTaskUseCase({
    required String description,
    required DateTime date,
    required bool isRoutine,
    DateTime? notificationDateTime,
  }) async {
    const uuid = Uuid();

    // definir
    TaskModel newTask = TaskModel(
      id: uuid.v4(), // random id
      description: description,
      date: date,
      repeatId: isRoutine ? uuid.v4() : null,
      status: TaskStatus.PENDING.toStringValue,
      subTasks: [],
    );

    // guardar
    tasksBox.add(newTask);
    Rx<TaskModel> newTaskObs = newTask.obs;
    createWeekObsGlobal.tasks.add(newTaskObs);
    Get.find<InitialPageController>().generateStatistics();

    // crear notificacion
    if (notificationDateTime != null) {
      newTask.notificationData = await LocalNotificationsDataSource.createNotification(
        datetime: notificationDateTime,
        title: description,
        payload: newTask.key.toString(),
      );
      newTask.save();
    }

    // is routine
    if (isRoutine) {
      for (var i = 1; i < 365; i++) {
        var nextDate = newTask.date.add(Duration(days: i));
        if (nextDate.weekday == newTask.date.weekday) {
          // crear tarea
          TaskModel repeatedTask = newTask.copyWith(
            id: uuid.v4(), // random id
            description: newTask.description,
            taskDate: nextDate,
            status: TaskStatus.PENDING.toStringValue,
            repeatId: newTask.repeatId,
            subTasks: [],
          );
          // guardar
          tasksBox.add(repeatedTask);
          // crear notificacion
          if (notificationDateTime != null) {
            var notifDateTime = DateTime(
              repeatedTask.date.year,
              repeatedTask.date.month,
              repeatedTask.date.day,
              notificationDateTime.hour,
              notificationDateTime.minute,
            );
            repeatedTask.notificationData = await LocalNotificationsDataSource.createNotification(
              datetime: notifDateTime,
              title: description,
              payload: repeatedTask.key,
            );
            repeatedTask.save();
          }
        }
      }
    }
    return newTask;
  }

  @override
  void readTaskUseCase({required Rx<TaskModel> task}) {
    // _task.value = tasksBox.get(value)!;
  }

  @override
  void updateTaskState({required Rx<TaskModel> task, bool? isDateUpdated}) {
    task.value.save();
    task.refresh();
  }

  @override
  void deleteTaskUseCase({required Rx<TaskModel> task, required bool deleteRoutine}) {
    // si es tarea repetida
    if (task.value.repeatId != null && deleteRoutine) {
      for (var e in tasksBox.values) {
        if (e.repeatId == task.value.repeatId) {
          //borrar notificacion si tiene y luego tarea
          _localNotificationsUseCases.deleteNotification(task: task);
          e.delete();
        }
      }
    }
    // si no es tarea repetida
    else {
      _localNotificationsUseCases.deleteNotification(task: task);
      // al borrar la tarea de muestra, marcar vista
      AppConfigModel config = userPrefs.get('appConfig')!;
      if (task.value.key == 0) {
        config.createSampleTask = false;
        config.save();
      }
      task.value.delete();
    }
    // quitar de la lista observable
    createWeekObsGlobal.tasks.remove(task);
    Get.find<InitialPageController>().generateStatistics();
  }
}
