import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/components/header.dart';
import 'package:todoapp/ui/initial_page/components/tasks_list.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/side_bar.dart';

class InitialPage extends GetView<InitialPageController> {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key
      key: controller.scaffoldKey,
      // ad
      bottomNavigationBar: Obx(
        () => controller.isAdLoaded.value
            ? Container(
                height: controller.myBanner.size.height.toDouble(),
                width: controller.myBanner.size.height.toDouble(),
                color: enabled_grey,
                child: Align(
                  alignment: Alignment.center,
                  child: AdWidget(ad: controller.myBanner),
                ),
              )
            : Container(
                height: 60.0,
                width: double.infinity,
                color: enabled_grey,
                child: const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
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
          color: const Color.fromARGB(255, 139, 115, 28),
          fit: BoxFit.contain,
          height: 21,
        ),
      ),

      // sidebar
      endDrawer: const SideBar(),

      // content
      body: Obx(
        () => controller.simulateDeleting.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
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
      ),
    );
  }
}


class _DelegateWithHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // tuto: https://www.appsloveworld.com/flutter/200/126/hide-top-header-until-scroll-to-certain-height

    return AnimatedOpacity(
      opacity: shrinkOffset == 0 ? 1 : 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
      child: Container(
        height: 80,
        color: Colors.white,
        alignment: Alignment.center,
        child: const Header(),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
