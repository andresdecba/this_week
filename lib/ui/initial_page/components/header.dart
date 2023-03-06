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
        height: 75,
        alignment: Alignment.center,
        //decoration: BoxDecoration(color: grey_bg, border: Border.all(color: Colors.blueAccent)),
        decoration: const BoxDecoration(
          color: grey_bg,
          border: Border(
            bottom: BorderSide(
              color: disabled_grey,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            IconButton(
              onPressed: controller.addWeeks == 0
                  ? () {}
                  : () {
                      controller.addWeeks--;
                      controller.buildInfo(); //addWks: controller.addWeeks
                    },
              icon: Icon(
                Icons.arrow_back_ios,
                color: controller.addWeeks == 0 ? disabled_grey : null,
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
                controller.addWeeks++;
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
