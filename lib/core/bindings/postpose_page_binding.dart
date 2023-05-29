import 'package:get/get.dart';
import 'package:todoapp/ui/postpose_page/postpose_page_controller.dart';
import 'package:todoapp/use_cases/local_notifications_use_cases.dart';

class PostposePageBinding implements Bindings {

  final LocalNotificationsUseCases _localNotificationsUseCases = LocalNotificationsUseCases();

  @override
  void dependencies() {
    Get.put<PostPosePageController>(
      PostPosePageController(
        localNotificationsUseCases: _localNotificationsUseCases,
      ),
    );
  }
}
