import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';
import 'package:todoapp/utils/utils.dart';

class FormAppbar extends GetView<FormsPageController> implements PreferredSizeWidget {
  const FormAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppBar(
        // back
        leading: Visibility(
          visible: !controller.isUpdateMode.value,
          child: IconButton(
            onPressed: () => controller.navigate(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),

        // title
        title: Text(taskState()),
        centerTitle: true,

        // create or update task
        actions: [
          controller.isUpdateMode.value || controller.isNewMode.value
              ? IconButton(
                  onPressed: () => controller.saveOrUpdateTask(context),
                  icon: const Icon(Icons.check_rounded),
                )
              : IconButton(
                  onPressed: () => controller.deleteTask(context),
                  icon: const Icon(Icons.delete_forever, color: text_bg),
                ),
        ],
      );
    });
  }

  String taskState() {
    if (controller.currentPageMode.value == PageMode.UPDATE_MODE) {
      return 'Update task ${Utils.parseDateTimeToShortFormat(controller.getTask.taskDate)}';
    }
    if (controller.currentPageMode.value == PageMode.VIEW_MODE) {
      return 'Task ${Utils.parseDateTimeToShortFormat(controller.getTask.taskDate)}';
    }
    return 'New task ${Utils.parseDateTimeToShortFormat(controller.getTask.taskDate)}';
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// AppBar formAppbard(FormsPageController controller, BuildContext context) {
//   return AppBar(
//     // back
//     leading: IconButton(
//       onPressed: () => controller.onWillPop(context),
//       icon: const Icon(Icons.arrow_back),
//     ),

//     // title
//     title: Text(
//       controller.isTaskUpdate ? 'Update task ${Utils.parseDateTimeToShortFormat(controller.getTask.dateTime)}' : 'New task ${Utils.parseDateTimeToShortFormat(controller.getTask.dateTime)}',
//     ),
//     centerTitle: true,

//     // create or update task
//     actions: [
//       controller.isTaskUpdate
//           ? IconButton(
//               onPressed: () => controller.isEditionEnabled.value = !controller.isEditionEnabled.value,
//               icon: const Icon(Icons.edit),
//             )
//           : IconButton(
//               onPressed: controller.isEditionEnabled.value ? () => controller.saveAndNavigate() : null,
//               icon: const Icon(Icons.done_rounded),
//             ),
//     ],
//   );
// }
