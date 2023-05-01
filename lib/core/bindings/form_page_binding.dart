import 'package:get/get.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';

class FormPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormsPageController>(() => FormsPageController(
        // argumentos
        ));
  }
}
