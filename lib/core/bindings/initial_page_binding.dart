import 'package:get/get.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/view_task_controller.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';
import 'package:todoapp/use_cases/tasks_use_cases.dart';

class InitialPageBinding implements Bindings {
  NotificationsUseCasesImpl notificationsUseCasesImpl = NotificationsUseCasesImpl();
  TaskUseCasesImpl taskUseCasesImpl = TaskUseCasesImpl();


  @override
  void dependencies() {
    Get.put<InitialPageController>(
      InitialPageController(),
    );

    Get.put<ViewTaskController>(
      ViewTaskController(
        notificationsUseCases: notificationsUseCasesImpl,
        tasksUseCases: taskUseCasesImpl,
      ),
    );

    Get.put<CreateTaskPageController>(
      CreateTaskPageController(
        tasksUseCases: taskUseCasesImpl,
        notificationsUseCases: notificationsUseCasesImpl,
      ),
    );
  }
}
