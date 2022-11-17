import 'package:get/get.dart';
import 'package:todoapp/core/bindings/formularios_binding.dart';
import 'package:todoapp/core/bindings/initial_page_week_binding.dart';
import 'package:todoapp/ui/pages/forms_page.dart';
import 'package:todoapp/ui/pages/initial_page.dart';

abstract class Routes {
  static const FORMS_PAGE = '/formularios_page';
  static const INITIAL_PAGE = '/initial_page';
}

class AppPages {

  static final List<GetPage> getPages = [
   
    GetPage(
      name: Routes.FORMS_PAGE,
      page:() => const FormsPage(),
      binding: FormulariosBinding(),
    ),

    GetPage(
      name: Routes.INITIAL_PAGE,
      page: () => const InitialPage(),
      binding: InitialPageBinding(),
    ),
  ];
}

