import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class Description extends GetView<InitialPageController> {
  const Description({required this.task, Key? key}) : super(key: key);
  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    controller.taskDescriptionCtrlr.text = task.value.description;

    return WillPopScope(
      onWillPop: () async {
        controller.isReadOnly.value = true;
        return true;
      },
      child: Obx(
        () => Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: GestureDetector(
            onDoubleTap: () {
              controller.isReadOnly.value = false;
              controller.focusNode1.requestFocus();
            },
            child: TextFormField(
              controller: controller.taskDescriptionCtrlr,
              autofocus: !controller.isReadOnly.value,
              focusNode: controller.focusNode1,
              readOnly: controller.isReadOnly.value,
              decoration: _customInputDecoration(
                isEnabled: !controller.isReadOnly.value,
                label: 'task description'.tr,
                hintText: 'task description_description'.tr,
                clearText: () => controller.taskDescriptionCtrlr.clear(),
              ),
              maxLines: null,
              maxLength: 200,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              style: kTitleLarge,
              validator: (value) {
                if (value != null && value.length < 7) {
                  return 'task description error'.tr;
                } else {
                  return null;
                }
              },
              onEditingComplete: () {
                controller.isReadOnly.value = true;
                task.value.description = controller.taskDescriptionCtrlr.text;
                task.refresh();
              },
              onTapOutside: (event) {
                controller.isReadOnly.value = true;
              },
            ),
          ),
        ),
      ),
    );
  }

  // textfield style
  InputDecoration _customInputDecoration({
    required String label,
    required String hintText,
    required VoidCallback clearText,
    required bool isEnabled,
  }) {
    return InputDecoration(
      contentPadding: isEnabled ? const EdgeInsets.all(10) : EdgeInsets.zero,
      isDense: true,
      border: isEnabled == true ? const OutlineInputBorder() : InputBorder.none,
      labelStyle: const TextStyle(color: bluePrimary),
      alignLabelWithHint: true,
      hintText: hintText,
      hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
      filled: isEnabled,
      fillColor: witheBg.withOpacity(0.4),
      suffixIcon: isEnabled == true
          ? IconButton(
              icon: const Icon(
                Icons.clear,
                color: enabledGrey,
              ), // clear text
              onPressed: clearText,
            )
          : null,
      counterText: isEnabled ? null : "",
      counterStyle: const TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 10,
        height: double.minPositive,
      ),
      enabledBorder: isEnabled == true
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: bluePrimary),
            )
          : null,
      focusedBorder: isEnabled == true
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: bluePrimary),
            )
          : null,
    );
  }
}
