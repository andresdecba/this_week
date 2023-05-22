import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/open_task.dart/view_task_controller.dart';

class SaveChanges extends GetView<ViewTaskController> {
  const SaveChanges({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              //task.value.save();
              //controller.tasksMap.refresh();
              //controller.buildInfo();
              //Get.back();
              controller.saveTaskandNavigate();
            },
            child: Text('Guargar'),
          ),
        ],
      ),
    );
  }
}
