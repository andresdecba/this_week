import 'package:get/get.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';
import 'package:todoapp/ui/controllers/initial_page_week_controller.dart';

class InitialPageWeekBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<InitialPageWeekController>(
      InitialPageWeekController(),
    );
  }
}
