import 'package:get/get.dart';
import 'package:todoapp/core/bindings/formularios_binding.dart';
import 'package:todoapp/core/bindings/initial_page_week_binding.dart';
import 'package:todoapp/ui/form_page/form_page.dart';
import 'package:todoapp/ui/initial_page/initial_page.dart';
import 'package:todoapp/ui/shared_components/onborading.dart';

abstract class Routes {
  static const FORMS_PAGE = '/formularios_page';
  static const INITIAL_PAGE = '/initial_page';
  static const ONBOARDING_PAGE = '/onboarding_page';
}

class AppPages {
  static final List<GetPage> getPages = [   
    GetPage(
      name: Routes.FORMS_PAGE,
      page: () => const FormPage(),
      binding: FormulariosBinding(),
    ),

    GetPage(
      name: Routes.INITIAL_PAGE,
      page: () => const InitialPage(),
      binding: InitialPageBinding(),
    ),

    GetPage(
      name: Routes.ONBOARDING_PAGE,
      page: () => const OnBoardingPage(),
    ),
  ];
}

