import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/create_task_page/components/create_task_form.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/view_task_page.dart/components/small_button.dart';
import 'package:todoapp/utils/helpers.dart';

class CreateTaskPage extends GetView<CreateTaskPageController> {
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          controller.closeAndRestoreValues();
          return true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // titulo
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: Text(
                    '${"new task".tr} ${longDateFormaterWithoutYear(controller.selectedDate)}',
                    style: kBodyLarge,
                  ),
                ),

                // FORM
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: CreateTaskForm(),
                ),

                // es rutina ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SmallButton(
                        onTap: () => controller.isRoutine.value = !controller.isRoutine.value,
                        icon: controller.isRoutine.value ? Icons.check_circle_rounded : Icons.circle_outlined,
                        //icon: controller.isRoutine.value ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                      ),
                      Text(
                        'create routine ?'.tr,
                        style: controller.isRoutine.value ? kBodyMedium : kBodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // notification
            const Divider(color: enabledGrey, height: 0),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'activate a notification'.tr,
                style: kBodyLarge,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 30),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    ChipList(
                      shouldWrap: false,
                      listOfChipNames: controller.listOfChips,

                      inactiveBgColorList: [myChipBg],
                      inactiveTextColorList: const [enabledGrey],
                      //inactiveBorderColorList: const [enabledGrey],

                      activeBgColorList: const [disabledGrey],
                      activeTextColorList: const [whiteBg],
                      //activeBorderColorList: const [bluePrimary],

                      borderRadiiList: const [20],
                      style: kBodySmall,
                      listOfChipIndicesCurrentlySeclected: [controller.currentIndex.value], // no modificar, ver documentación
                      extraOnToggle: (val) {
                        controller.currentIndex.value = val;
                        controller.selectedNotificationDateTime(context, val);
                        //FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
