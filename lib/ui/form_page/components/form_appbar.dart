import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class FormAppbar extends GetView<FormsPageController> implements PreferredSizeWidget {
  const FormAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppBar(
        // title
        title: Text(
          taskState(),
          style: kTitleLarge,
        ),

        // create or update task
        actions: [
          controller.isViewMode.value
              ? Wrap(
                  children: [
                    IconButton(
                      onPressed: () => controller.deleteTask(context),
                      icon: const Icon(Icons.delete_forever, color: text_bg),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.floatingActionButtonChangeMode();
                        controller.enableDisableNotificationStyles();
                      },
                      icon: const Icon(Icons.mode_edit_rounded),
                    ),
                  ],
                )
              : controller.isUpdateMode.value
                  ? IconButton(
                      onPressed: () {
                        controller.floatingActionButtonChangeMode();
                        controller.enableDisableNotificationStyles();
                      },
                      icon: const Icon(Icons.edit_off_rounded),
                    )
                  : IconButton(
                      onPressed: () => controller.cancelAndNavigate(context),
                      icon: const Icon(Icons.home),
                    ),
        ],
      );
    });
  }

  String taskState() {
    if (controller.currentPageMode.value == PageMode.UPDATE_MODE) {
      return 'update task'.tr;
    }
    if (controller.currentPageMode.value == PageMode.VIEW_MODE) {
      return 'view task'.tr;
    }
    return 'new task_formPage'.tr;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// default value: [kToolbarHeight]
}