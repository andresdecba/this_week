import 'package:get/get.dart';
import 'package:todoapp/core/bindings/postpose_page_binding.dart';
import 'package:todoapp/core/bindings/initial_page_binding.dart';
import 'package:todoapp/ui/initial_page/initial_page.dart';
import 'package:todoapp/ui/postpose_page/postpose_page.dart';
import 'package:todoapp/ui/onboarding_page/onborading.dart';

abstract class Routes {
  static const INITIAL_PAGE = '/initial_page';
  static const ONBOARDING_PAGE = '/onboarding_page';
  static const POSTPOSE_PAGE = '/pospose_page';
  //static const VIEW_TASK_PAGE = '/view_task_page';
}

class AppPages {
  static final List<GetPage> getPages = [
    GetPage(
      name: Routes.INITIAL_PAGE,
      page: () => const InitialPage(),
      binding: InitialPageBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING_PAGE,
      page: () => const OnBoardingPage(),
    ),
    GetPage(
      name: Routes.POSTPOSE_PAGE,
      page: () => const PostPosePage(),
      binding: PostposePageBinding(),
    ),
  ];
}
