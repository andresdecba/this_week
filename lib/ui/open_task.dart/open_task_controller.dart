import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

mixin OpenTaskController {
  ///
  //final initialPageController = Get.put<InitialPageController>(InitialPageController());

  ///
  void cambiarValor(Rx<TaskModel> task) {
    task.value.description = 'CAMBIADOO joshaaa';
    task.refresh();
    //initialPageController.tasksMap.refresh();
  }

  RxBool isNotificationActive = true.obs;
}
