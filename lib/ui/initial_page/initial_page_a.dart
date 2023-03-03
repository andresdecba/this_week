import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/initial_page/components/header.dart';
import 'package:todoapp/ui/initial_page/components/tasks_list.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/side_bar.dart';

class InitialPageA extends GetView<InitialPageController> {
  const InitialPageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        leadingWidth: 300,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(
            'assets/weekly-logo.svg',
            alignment: Alignment.center,
            color: Colors.black,
          ),
        ),
      ),

      // sidebar
      endDrawer: const SideBar(),

      // content
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        // TODO poner un key de scroll,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [
            Header(),
            Divider(height: 40),
            TasksList(),
          ],
        ),
      ),
    );
  }
}
