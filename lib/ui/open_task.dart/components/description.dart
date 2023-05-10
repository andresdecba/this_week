import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/custom_text_field.dart';

class Description extends GetView<InitialPageController> {
  const Description({required this.task, Key? key}) : super(key: key);
  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    controller.taskDescriptionCtrlr.text = task.value.description;

    return Obx(
      () => CustomTextField(
        myFunction: (value) {
          task.value.description = value;
          task.refresh();
        },
        textValue: task.value.description,
        textStyle: kTitleLarge.copyWith(fontSize: 22),
      ),
    );
  }
}
