import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';

class NuevaController extends GetxController {
  ///
  ///
  ///
  @override
  void onInit() {
    super.onInit();
  }

  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey();
  final Duration listDuration = const Duration(milliseconds: 500);
  final GlobalKey<FormState> newFormKey = GlobalKey<FormState>();

  void removeSubtask({required int index, required Widget child, required Rx<TaskModel> task}) {
    animatedListKey.currentState!.removeItem(
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
    task.value.save();
    task.refresh();
  }

  void createSubtask({required Rx<TaskModel> task, required String value}) {
    animatedListKey.currentState!.insertItem(
      0,
      duration: listDuration,
    );
    task.value.subTasks.insert(0, SubTaskModel(title: value, isDone: false));
    task.value.subTasks.add(SubTaskModel(title: value, isDone: false));
    task.value.save();
    task.refresh();
  }

  void selector({
    required String value, //The value represented by this radio button.
    required String groupValue, //The currently selected value for this group of radio buttons.
    required Function onChange, //Called when the user selects this radio button.
  }) {}
}
