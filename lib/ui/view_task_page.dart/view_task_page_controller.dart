import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';

import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';
import 'package:todoapp/use_cases/tasks_use_cases.dart';

class ViewTaskController extends GetxController {
  final NotificationsUseCases notificationsUseCases;
  final TasksUseCases tasksUseCases;

  ViewTaskController({
    required this.notificationsUseCases,
    required this.tasksUseCases,
  });

  @override
  void onInit() {
    super.onInit();
    focusNode = FocusNode();
    textController = TextEditingController();
    textController.addListener(() {
      counter.value = textController.text.length;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  // LLENAR //
  late Rx<TaskModel> task;

  ////// DATE PICKER //////
  Future<void> updateTaskDate(BuildContext context, Rx<TaskModel> task) async {
    late DateTime initialDate;
    late DateTime firstDate;

    if (task.value.taskDate.isBefore(DateTime.now())) {
      initialDate = DateTime.now();
      firstDate = DateTime.now();
    }

    if (task.value.taskDate.isAfter(DateTime.now())) {
      initialDate = task.value.taskDate;
      firstDate = DateTime.now();
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate, //task.value.taskDate, // dia seleccionado del calendario (no puede ser anterior al fisrtDate)
      firstDate: firstDate, // DateTime.now(), // primer dia habilitado del calendario (igual o anterior al initialDate)
      lastDate: DateTime(2050),
    );
    if (pickedDate == null) {
      return;
    } else {
      task.value.taskDate = pickedDate;
      tasksUseCases.updateTaskUseCase(task: task, isDateUpdated: true);
    }
  }

  //// TASK DESCRIPTION ////
  void saveDescriptionUpdate(String value) {
    task.value.description = value;
    tasksUseCases.updateTaskUseCase(task: task);
  }

  //// DELETE TASK ////
  RxBool isChecked = false.obs;
  void deleteTask() {
    tasksUseCases.deleteTaskUseCase(task: task, deleteRoutine: isChecked.value);
  }

  ////// SUBTASKS //////
  
  final Duration listDuration = const Duration(milliseconds: 500);

  // subtask form //
  late FocusNode focusNode;
  late TextEditingController textController;
  RxInt counter = 0.obs;

  void createSubtask() {
    if (Globals.formStateKey.currentState!.validate()) {
      Globals.animatedListStateKey.currentState!.insertItem(
        0,
        duration: listDuration,
      );
      task.value.subTasks.insert(0, SubTaskModel(title: textController.text, isDone: false));
      tasksUseCases.updateTaskUseCase(task: task);
      textController.clear();
    }
  }

  void updateTitleSubtask(SubTaskModel subTask, String? title) {
    subTask.title = title ?? subTask.title;
    tasksUseCases.updateTaskUseCase(task: task);
  }

  void updateStatusSubtask(SubTaskModel subTask) {
    subTask.isDone = !subTask.isDone;
    tasksUseCases.updateTaskUseCase(task: task);
  }

  void removeSubtask({required int index, required Widget child, required Rx<TaskModel> task}) {
    Globals.animatedListStateKey.currentState!.removeItem(
      index,
      duration: listDuration,
      (context, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        ); //;
      },
    );
    task.value.subTasks.remove(task.value.subTasks[index]);
    tasksUseCases.updateTaskUseCase(task: task);
  }
}

typedef SelectedValueTypedef<T> = void Function(T value);
