import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/create_week.dart';

import 'package:todoapp/ui/shared_components/side_bar.dart';

class InitialPage extends GetView<InitialPageController> {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // keyboard
      resizeToAvoidBottomInset: false,

      // key
      key: Globals.myScaffoldKey,
      // ad
      bottomNavigationBar: controller.obx(
        (ad) => Container(
          height: ad.size.height.toDouble(),
          width: ad.size.height.toDouble(),
          color: enabledGrey,
          child: Align(
            alignment: Alignment.center,
            child: AdWidget(ad: ad),
          ),
        ),
        onLoading: Container(
          height: 60.0,
          width: double.infinity,
          color: enabledGrey,
          child: const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
        onError: (error) => Container(
          height: 60.0,
          width: double.infinity,
          color: enabledGrey,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              error!,
              style: kTitleMedium.copyWith(color: whiteBg),
            ),
          ),
        ),
      ),

      // app bar
      appBar: AppBar(
        titleSpacing: 24,
        //title: SizedBox(),
        title: SvgPicture.asset(
          'assets/appbar_logo.svg',
          alignment: Alignment.center,
          color: appBarLogo,
          fit: BoxFit.contain,
          height: 21,
        ),
      ),

      // sidebar
      endDrawer: SideBar(),
      endDrawerEnableOpenDragGesture: false,

      // content

      body: Obx(
        () => controller.simulateDeleting.value
            ? const Center(child: CircularProgressIndicator())
            : PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: controller.pageController,
                pageSnapping: true,
                onPageChanged: (index) {},
                itemBuilder: (context, i) {
                  // cambiar la pagina y generar la lista observable
                  controller.changePage(i);
                  // desplegar la listaylor observable
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: CreateWeek(
                      week: controller.week.value,
                      tasks: controller.getWeekTasks(
                        tasksBox: controller.tasksBox,
                        week: controller.week.value,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/*
CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  // header with weeks
                  SliverPersistentHeader(
                    delegate: _DelegateWithHeader(),
                    floating: true,
                  ),
                  // tasks list
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                          child: TasksList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

*/

// class _DelegateWithHeader extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     // tuto: https://www.appsloveworld.com/flutter/200/126/hide-top-header-until-scroll-to-certain-height

//     return AnimatedOpacity(
//       opacity: shrinkOffset == 0 ? 1 : 0.0,
//       duration: const Duration(milliseconds: 400), // no es
//       curve: Curves.easeIn,
//       child: Container(
//         height: 60,
//         color: Colors.white,
//         alignment: Alignment.center,
//         child: const Header(),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 60; //no es

//   @override
//   double get minExtent => 60; // no es

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
// }
