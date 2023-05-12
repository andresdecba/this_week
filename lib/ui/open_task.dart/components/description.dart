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

    return Obx(
      () => CustomTextField(
        key: UniqueKey(),
        focusNode: controller.focusNode,
        getValue: (value) {
          task.value.description = value;
          task.refresh();
        },
        initialValue: task.value.description,
        enableReadMode: true,
        textStyle: kTitleLarge.copyWith(fontSize: 22),
      ),
    );
  }
}
