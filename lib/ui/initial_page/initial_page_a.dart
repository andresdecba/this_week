import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/ui/initial_page/components/header.dart';
import 'package:todoapp/ui/initial_page/components/tasks_list.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/side_bar.dart';

class InitialPageA extends GetView<InitialPageController> {
  const InitialPageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      key: controller.scaffoldKey,

      // ad
      bottomNavigationBar: Obx(
        () => controller.isAdLoaded.value
            ? SizedBox(
                height: controller.myBanner.size.height.toDouble(),
                width: controller.myBanner.size.height.toDouble(),
                child: AdWidget(ad: controller.myBanner),
              )
            : const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
      ),

      // app bar
      appBar: AppBar(
        titleSpacing: 24,
        title: SvgPicture.asset(
          'assets/weekly-logo.svg',
          alignment: Alignment.center,
          color: Colors.black,
          fit: BoxFit.contain,
          height: 30,
        ),
      ),

      // sidebar
      endDrawer: SideBar(),

      // content
      body: Obx(
        () => controller.simulateReloadPage.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Header(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: const [
                          TasksList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
