import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class Save extends GetView<InitialPageController> {
  const Save({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.save),
          // ),

          TextButton(
            onPressed: () {
              task.value.save();
              controller.tasksMap.refresh();
              controller.buildInfo();
              Get.back();
            },
            child: Text('Guargar'),
          ),
        ],
      ),
    );
  }
}
