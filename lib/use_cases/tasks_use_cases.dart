import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';

abstract class TasksUseCases {
  TaskModel createTaskUseCase({required String description, required DateTime date, required bool isRoutine});
  void deleteTaskUseCase({required Rx<TaskModel> task, required bool deleteRoutine});
  void updateTaskUseCase({required Rx<TaskModel> task, bool? isDateUpdated});
  void readTaskUseCase({required Rx<TaskModel> task});
}

class TaskUseCasesImpl implements TasksUseCases {
  //
  NotificationsUseCases notificationsUseCases = NotificationsUseCasesImpl();
  final tasksBox = Boxes.getTasksBox();
  //AppConfigModel config = userPrefs.get('appConfig')!;

  @override
  TaskModel createTaskUseCase({required String description, required DateTime date, required bool isRoutine}) {
    // definir
    TaskModel newTask = TaskModel(
      description: description,
      taskDate: date,
      repeatId: isRoutine ? UniqueKey().toString() : null,
      status: TaskStatus.PENDING.toString(),
      subTasks: [],
    );

    // task
    late int taskKey;

    // guardar
    tasksBox.add(newTask).then((value) => taskKey = value);
    Get.find<InitialPageController>().tasksMap.refresh();
    Get.find<InitialPageController>().buildInfo();

    return tasksBox.get(taskKey)!;
  }

  @override
  void updateTaskUseCase({required Rx<TaskModel> task, bool? isDateUpdated}) {
    task.value.save();
    task.refresh();
    Get.find<InitialPageController>().tasksMap.refresh();
    if (isDateUpdated != null && isDateUpdated == true) {
      Get.find<InitialPageController>().buildInfo();
    }
  }

  @override
  void deleteTaskUseCase({required Rx<TaskModel> task, required bool deleteRoutine}) {
    // si es tarea repetida
    if (task.value.repeatId != null && deleteRoutine) {
      for (var e in tasksBox.values) {
        if (e.repeatId == task.value.repeatId) {
          //borrar notificacion si tiene y luego tarea
          if (e.notificationData != null && e.notificationData!.time.isAfter(DateTime.now())) {
            notificationsUseCases.deleteNotificationWithTaskUseCase(task: e);
          }
          e.delete();
        }
      }
      Get.find<InitialPageController>().buildInfo();
      return;
    } else {
      // si no es tarea repetida
      if (task.value.notificationData != null) {
        notificationsUseCases.deleteNotificationUseCase(task: task);
      }
      // borrar tarea de muestra
      // if (task.value.key == 0) {
      //   config.createSampleTask = false;
      //   config.save();
      // }
      task.value.delete();
      Get.find<InitialPageController>().buildInfo();
    }
  }

  @override
  void readTaskUseCase({required Rx<TaskModel> task}) {
    // _task.value = tasksBox.get(value)!;
  }
}
