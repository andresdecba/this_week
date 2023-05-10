import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/components/todo_list.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/components/description.dart';
import 'package:todoapp/ui/open_task.dart/components/info.dart';
import 'package:todoapp/ui/open_task.dart/components/subtasks.dart';
import 'package:todoapp/ui/open_task.dart/components/task_options.dart';

class OpenTask extends GetView<InitialPageController> {
  const OpenTask({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;
  

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // desxription
                      const Text('Descripción'),
                      const SizedBox(height: 8),
                      Description(task: task),
                      const SizedBox(height: 24),

                      // subtasks
                      const Text('Subtareas'),
                      const SizedBox(height: 8),
                      Subtasks(task: task),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // info de la task

        const Divider(color: blackBg, height: 0),
        Info(task: task),

        // opciones del widget
        const Divider(color: disabledGrey, height: 0),
        TaskOptions(task: task),
      ],
    );
  }
}
