import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';

class CreateSubtaskForm extends GetView<ViewTaskController> {
  const CreateSubtaskForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: Globals.formStateKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          //focusNode: controller.focusNode,
          autofocus: false,
          controller: controller.textController,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          style: kTitleLarge,
          maxLines: null,
          maxLength: 100,
          validator: (value) {
            if (value != null && value.length < 6) {
              return 'between 6 and 00 characters'.tr;
            } else {
              return null;
            }
          },
          onEditingComplete: () {
            controller.createSubtask();
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            isDense: true,
            border: const OutlineInputBorder(),
            hintText: 'description'.tr,
            // styles
            hintStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal, fontSize: 13),
            helperStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal),
            errorStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal),
            counterStyle: kBodySmall.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: controller.counter.value < 6 ? FontWeight.bold : FontWeight.normal,
              color: controller.counter.value < 6 ? warning : disabledGrey,
            ),
            // others
            filled: false,
            suffixIcon: controller.counter.value == 0
                ? null
                : InkWell(
                    onTap: () => controller.textController.clear(),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: disabledGrey,
                      ),
                    ),
                  ),
            suffixIconConstraints: const BoxConstraints(maxHeight: 100),
            counterText: "${controller.counter.value}",
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: disabledGrey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: bluePrimary),
            ),
            helperText: 'between 12 and 200 characters'.tr,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: bluePrimary, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: bluePrimary, width: 1.0),
            ),
          ),
        ),
      ),
    );
  }
}
