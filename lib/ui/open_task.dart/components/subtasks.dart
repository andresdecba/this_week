import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/components/subtask_tile.dart';

class Subtasks extends GetView<InitialPageController> {
  const Subtasks({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...task.value.subTasks.map((e) {
          return SubtaskTile(
            title: e.title,
            icon: e.isDone ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
            onTap: () {},
          );
        }),
      ],
    );
  }
}
