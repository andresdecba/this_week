import 'package:get/get.dart';
import 'package:todoapp/ui/initial_page/build_page_controller.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class InitialPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<InitialPageController>(
      InitialPageController(),
    );

    Get.put<BuildPageController>(
      BuildPageController(),
    );
  }
}
