import 'package:get/get.dart';
import 'package:todoapp/ui/controllers/forms_page_controller.dart';

class FormulariosBinding implements Bindings {
@override
void dependencies() {

    Get.lazyPut<FormsPageController>(() => FormsPageController(
      // argumentos
    ));
  }
}