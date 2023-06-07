import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:todoapp/ui/shared_components/my_chip.dart';
import 'package:todoapp/ui/view_task_page.dart/components/create_subtask_text_form.dart';
import 'package:todoapp/ui/view_task_page.dart/components/subtask_animated_list.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({Key? key}) : super(key: key);

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  @override
  void initState() {
    super.initState();
    debugPrint('ViewTask -> iniState');
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<ViewTaskController>();
    debugPrint('ViewTask -> dispose');
  }


  @override
  Widget build(BuildContext context) {

    final controller = Get.find<ViewTaskController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// SI ES ATER, HOY O MAÑANA ///
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: controller.dateStatus(),
                ),

                /// BOTON GUARDAR  ///
                Visibility(
                  visible: controller.hasUpdated.value,
                  child: TextButton(
                    onPressed: () => controller.saveUpdatedTask(),
                    child: const Text('Guargar', style: TextStyle(color: bluePrimary)),
                  ),
                ),
              ],
            ),
          ),

          /// DESCRIPCION DE LA TAREA  ///
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              focusNode: controller.descriptionFocusNode,
              autofocus: false,
              canRequestFocus: true,
              maxLines: null,
              maxLength: 200,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              controller: controller.descriptionTxtCtr,
              style: !controller.descriptionEditMode.value
                  ? kViewTaskDescripton
                  : kViewTaskDescripton.copyWith(
                      color: disabledGrey,
                    ),
              decoration: const InputDecoration(contentPadding: EdgeInsets.zero, isDense: true, border: InputBorder.none, counterText: ""),
              onTap: () => controller.descriptionEditMode.value = true,
              onEditingComplete: () {
                controller.updateDescription();
              },
            ),
          ),

          /// CHIPS ///
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // CAMBIAR LA FECHA //
                MyChip(
                  label: standardDateFormater(controller.updatedDateTime.value),
                  iconData: controller.task.value.repeatId == null ? Icons.calendar_today_rounded : Icons.push_pin_rounded,
                  onTap: () => controller.updateDate(context, controller.task),
                  isEnabled: controller.task.value.repeatId == null ? true : false,
                ),
                const SizedBox(width: 5),

                // CAMBIAR LA NOTIFICACION //
                MyChip(
                  label: controller.updatedNotification.value != null ? timeOfDayToString(controller.updatedNotification.value!) : '-- : --',
                  iconData: controller.task.value.notificationData != null ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                  onTap: () => controller.updateNotification(context),
                  isEnabled: !controller.isExpired.value,
                ),
                const SizedBox(width: 5),

                // ELIMINAR LA TAREA //
                MyChip(
                  label: 'delete'.tr,
                  iconData: Icons.delete_forever_outlined,
                  onTap: () {
                    myCustomDialog(
                      context: context,
                      title: 'this action will delete...'.tr,
                      cancelTextButton: 'cancel'.tr,
                      okTextButton: 'delete'.tr,
                      iconPath: 'assets/warning.svg',
                      iconColor: warning,
                      content: controller.task.value.repeatId != null ? const _BuildCheckBox() : null,
                      onPressOk: () => controller.deleteTask(),
                    );
                  },
                  isEnabled: true,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text('subtasks'.tr),
          ),

          //// CREAR NUEVA SUBTAREA ////
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: CreateSubtaskTextForm(),
            //child: TextField(),
          ),

          //// LISTA DE SUBTAREAS ////
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: SubtasksAnimatedList(),
          ),
        ],
      ),
    );
  }
}

class _BuildCheckBox extends GetView<ViewTaskController> {
  const _BuildCheckBox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'this is a periodic task'.tr,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: controller.isChecked.value,
                onChanged: (value) => controller.isChecked.value = !controller.isChecked.value,
              ),
              Expanded(child: Text('delete current task and subsequent...'.tr)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: !controller.isChecked.value,
                onChanged: (value) => controller.isChecked.value = !controller.isChecked.value,
              ),
              Expanded(child: Text('delete current task'.tr)),
            ],
          ),
        ],
      ),
    );
  }
}
