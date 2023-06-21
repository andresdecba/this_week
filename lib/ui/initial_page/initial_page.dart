import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/build_page.dart';
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

      // sidebar
      endDrawer: SideBar(),
      endDrawerEnableOpenDragGesture: false,

      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Label'),
      //     BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Label'),
      //     BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Label'),
      //   ],
      // ),

      // content
      body: Obx(
        () => controller.simulateDeleting.value
            ? const Center(child: CircularProgressIndicator())
            : PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: controller.pageCtlr,
                pageSnapping: true,
                onPageChanged: (index) {
                  print('hash: on page change ${Globals.tasksGlobal.hashCode}');
                },
                itemBuilder: (context, index) {
                  return BuildPage(
                    week: controller.onPageChange(index),
                    key: UniqueKey(),
                  );
                },
              ),
      ),
    );
  }
}

// // ver! esta bueno -> card_loading 0.3.0
// // return const Column(
// //   crossAxisAlignment: CrossAxisAlignment.start,
// //   children: [
// //     CardLoading(
// //       height: 30,
// //       borderRadius:
// //           BorderRadius.all(Radius.circular(15)),
// //       width: 100,
// //       margin: EdgeInsets.only(bottom: 10),
// //     ),
// //     CardLoading(
// //       height: 100,
// //       borderRadius:
// //           BorderRadius.all(Radius.circular(15)),
// //       margin: EdgeInsets.only(bottom: 10),
// //     ),
// //     CardLoading(
// //       height: 30,
// //       width: 200,
// //       borderRadius:
// //           BorderRadius.all(Radius.circular(15)),
// //       margin: EdgeInsets.only(bottom: 10),
// //     ),
// //   ],
// // );