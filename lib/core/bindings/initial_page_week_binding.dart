import 'package:get/get.dart';
import 'package:todoapp/ui/borrar/deprueba.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class InitialPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<InitialPageController>(
      InitialPageController(),
    );
  }
}


class DepruebaBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<Depruebacontroller>(
      Depruebacontroller(),
    );
  }
}
