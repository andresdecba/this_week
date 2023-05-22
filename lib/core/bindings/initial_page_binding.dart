import 'package:get/get.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
//import 'package:todoapp/ui/open_task.dart/view_task_controller.dart';

class InitialPageBinding implements Bindings {
  @override
  void dependencies() {

    Get.put<InitialPageController>(
      InitialPageController(),
    );

    // Get.put<ViewTaskController>(
    //   ViewTaskController(),
    // );
  }
}