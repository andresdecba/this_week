import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/build_week.dart';
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
                controller: controller.pageCtlr,
                pageSnapping: true,
                onPageChanged: (index) {},
                itemBuilder: (context, i) {
                  // cambiar la pagina y generar la lista observable
                  controller.changePage(i);
                  // widget
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: createTasks(),
                  );
                },
              ),
      ),
    );
  }

  Widget createTasks() {
    var tasks = controller.getWeekTasksDos(
      tasksBox: controller.tasksBox,
      week: controller.week.value,
    );
    var returnWidget = BuildWeek(
      key: UniqueKey(),
      week: controller.week.value,
      tasks: tasks,
    );
    return returnWidget;
  }
}


   // ver! esta bueno -> card_loading 0.3.0
                        // return const Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     CardLoading(
                        //       height: 30,
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(15)),
                        //       width: 100,
                        //       margin: EdgeInsets.only(bottom: 10),
                        //     ),
                        //     CardLoading(
                        //       height: 100,
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(15)),
                        //       margin: EdgeInsets.only(bottom: 10),
                        //     ),
                        //     CardLoading(
                        //       height: 30,
                        //       width: 200,
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(15)),
                        //       margin: EdgeInsets.only(bottom: 10),
                        //     ),
                        //   ],
                        // );