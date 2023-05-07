import 'package:get/get.dart';
import 'package:todoapp/ui/postpose_page/postpose_page_controller.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';

class PostposePageBinding implements Bindings {

  final NotificationsUseCasesImpl notificationsUseCasesImpl = NotificationsUseCasesImpl();
  
  @override
  void dependencies() {
    Get.put<PostPosePageController>(
      PostPosePageController(
        notificationsUseCases: notificationsUseCasesImpl,
      ),
    );
  }
}
