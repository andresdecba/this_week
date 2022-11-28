import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';

class TaskCardWidgetController extends GetxController {
  Rx<Color> statusColor = Colors.grey.obs;

  late Task tarea;
  set setTarea(Task data) {
    tarea = data;
  }

  @override
  void onInit() {
    setStatusColor(tarea);
    super.onInit();
  }

  void setStatusColor(Task data) {
    switch (data.status) {
      case 'Pending':
        statusColor.value = Colors.grey;
        break;
      case 'In progress':
        statusColor.value = Colors.green;
        break;
      case 'Done':
        statusColor.value = Colors.orange;
        break;
    }
  }
}
