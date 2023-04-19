import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class Header extends GetView<InitialPageController> {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 80,
        alignment: Alignment.center,
        //decoration: BoxDecoration(color: grey_bg, border: Border.all(color: Colors.blueAccent)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: yellow_header,      
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            IconButton(
              onPressed: controller.week == 0
                  ? () {}
                  : () {
                      controller.decreaseWeek();
                      controller.buildInfo(); //addWks: controller.addWeeks
                    },
              icon: Icon(
                Icons.arrow_back_ios,
                color: controller.week == 0 ? disabled_grey : null,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.weekDaysFromTo.value,
                  style: kTitleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  controller.tasksPercentageCompleted.value,
                  style: kTitleSmall.copyWith(height: 1.5),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                controller.increaseWeek();
                controller.buildInfo(); //addWks: controller.addWeeks
              },
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
