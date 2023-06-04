import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class Header extends GetView<InitialPageController> {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 60,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: grey_background,
          boxShadow: [
            BoxShadow(
              color: disabledGrey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
            
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            IconButton(
              onPressed: () {}, //controller.increaseDecreaseWeeks == 0 ? null : () => controller.decreaseWeek(),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.weekDaysFromTo.value,
                  style: controller.week == Week.current() ? kTitleSmall.copyWith(fontWeight: FontWeight.bold) : kTitleSmall.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  controller.tasksPercentageCompleted.value,
                  style: kBodyMedium.copyWith(height: 1.5),
                ),
              ],
            ),
            IconButton(
              onPressed: () {}, //() => controller.nextWeek(),
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
