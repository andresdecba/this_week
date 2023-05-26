import 'package:get/get.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';
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

    Get.lazyPut(
      () => ViewTaskController(
        notificationsUseCases: notificationsUseCasesImpl,
        tasksUseCases: taskUseCasesImpl,
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => CreateTaskPageController(
        tasksUseCases: taskUseCasesImpl,
        notificationsUseCases: notificationsUseCasesImpl,
      ),
      fenix: true,
    );
  }
}
