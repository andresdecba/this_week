import 'package:get/get.dart';
import 'package:todoapp/core/bindings/initial_page_binding.dart';
import 'package:todoapp/core/bindings/formularios_binding.dart';
import 'package:todoapp/core/bindings/initial_page_week_binding.dart';
import 'package:todoapp/ui/pages/forms_page.dart';
import 'package:todoapp/ui/pages/initial_page.dart';
import 'package:todoapp/ui/pages/initial_page_week.dart';

abstract class Routes{
  static const INITIAL_PAGE = '/borrar_page';
  static const FORMS_PAGE = '/formularios_page';
  static const INITIAL_PAGE_WEEK = '/initial_page_Week';

}

class AppPages {

  static final List<GetPage> getPages = [
    GetPage(
      name: Routes.INITIAL_PAGE,
      page:() => const InitialPage(),
      binding: InitialPageBinding(),
    ),

    GetPage(
      name: Routes.FORMS_PAGE,
      page:() => const FormsPage(),
      binding: FormulariosBinding(),
    ),

    GetPage(
      name: Routes.INITIAL_PAGE_WEEK,
      page:() => const InitialPageWeek(),
      binding: InitialPageWeekBinding(),
    ),
  ];
}

