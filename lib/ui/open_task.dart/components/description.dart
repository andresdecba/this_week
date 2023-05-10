import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class Description extends GetView<InitialPageController> {
  const Description({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Text(
      task.value.description,
      style: kTitleLarge,
    );
  }
}
