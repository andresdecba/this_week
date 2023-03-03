import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class Header extends GetView<InitialPageController> {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              color: controller.addWeeks == 0 ? bdisabledColorLightO : null,
            ),
          ),
          Column(
            children: [
              Text(
                controller.weekDaysFromTo.value,
                style: kTitleMedium,
              ),
              Text(
                controller.tasksPercentageCompleted.value,
                style: kTitleSmall,
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
    );
  }
}
