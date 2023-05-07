import 'package:get/get.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';

class FormPageBinding implements Bindings {

  final NotificationsUseCasesImpl notificationsUseCasesImpl = NotificationsUseCasesImpl();

  @override
  void dependencies() {
    Get.lazyPut<FormsPageController>(() => FormsPageController(
        notificationsUseCases: notificationsUseCasesImpl));
  }
}
