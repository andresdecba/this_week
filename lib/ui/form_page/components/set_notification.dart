import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';

class SetNotificationDatetime extends GetView<FormsPageController> {
  const SetNotificationDatetime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(children: [
        /// title ///
        Text(
          'notify me:'.tr,
          style: kTitleLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              key: UniqueKey(),
              onTap: controller.isViewMode.value
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus(); // hide keyboard if open
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: controller.notificationTime,
                      );
                      if (newTime == null) {
                        return;
                      } else {
                        controller.notificationTime = newTime;
                      }
                      controller.enableDisableNotificationStyles();
                      controller.saveNotification();
                    },
              child: controller.notificationText.value,
            ),
            IconButton(
              onPressed: controller.isViewMode.value
                  ? null
                  : () {
                      controller.enableNotificationIcon.value = !controller.enableNotificationIcon.value;
                      controller.enableDisableNotificationStyles();
                      controller.saveNotification();
                    },
              icon: controller.notificationIcon.value,
              color: controller.notificationColor.value,
            ),
          ],
        ),
      ]);
    });
  }
}
