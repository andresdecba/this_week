import 'package:get/get.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';

class InitialPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<InitialPageController>(
      InitialPageController(),
    );
  }
}
