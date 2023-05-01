import 'package:get/get.dart';
import 'package:todoapp/ui/postpose_page/postpose_page_controller.dart';

class PostposePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PostPosePageController>(
      PostPosePageController(),
    );
  }
}
