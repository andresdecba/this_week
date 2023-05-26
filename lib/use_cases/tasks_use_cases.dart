import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/use_cases/notifications_crud.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';

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
  void updateTaskUseCase({
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
  NotificationsUseCases notificationsUseCases = NotificationsUseCasesImpl();
  final tasksBox = Boxes.getTasksBox();
  //AppConfigModel config = userPrefs.get('appConfig')!;

  @override
  Future<TaskModel> createTaskUseCase({
    required String description,
    required DateTime date,
    required bool isRoutine,
    DateTime? notificationDateTime,
  }) async {
    // definir
    TaskModel newTask = TaskModel(
      description: description,
      taskDate: date,
      repeatId: isRoutine ? UniqueKey().toString() : null,
      status: TaskStatus.PENDING.toValue,
      subTasks: [],
    );

    // guardar
    tasksBox.add(newTask); //.then((value) => task = tasksBox.get(value)!);

    // crear notificacion
    if (notificationDateTime != null) {
      newTask.notificationData = await NotificationsCrud.createNotification(
        datetime: notificationDateTime,
        title: description,
        payload: newTask.key.toString(),
      );
      newTask.save();
    }

    // is routine
    if (isRoutine) {
      for (var i = 1; i < 365; i++) {
        var nextDate = newTask.taskDate.add(Duration(days: i));
        if (nextDate.weekday == newTask.taskDate.weekday) {
          // crear tarea
          TaskModel repeatedTask = newTask.copyWith(
            description: newTask.description,
            taskDate: nextDate,
            status: TaskStatus.PENDING.toValue,
            repeatId: newTask.repeatId,
            subTasks: [],
          );
          // guardar
          tasksBox.add(repeatedTask);
          // crear notificacion
          if (notificationDateTime != null) {
            var notifDateTime = DateTime(
              repeatedTask.taskDate.year,
              repeatedTask.taskDate.month,
              repeatedTask.taskDate.day,
              notificationDateTime.hour,
              notificationDateTime.minute,
            );
            repeatedTask.notificationData = await NotificationsCrud.createNotification(
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
}
