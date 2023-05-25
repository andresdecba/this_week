import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';
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
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                  child: Text(
                    '${"new task".tr} ${longDateFormaterWithoutYear(controller.selectedDate)}',
                    style: kBodyLarge,
                  ),
                ),

                // FORM
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Form(
                    key: controller.formStateKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      focusNode: controller.focusNode,
                      autofocus: true,
                      controller: controller.textController,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      style: kTitleLarge,
                      maxLines: null,
                      maxLength: 200,
                      validator: (value) {
                        if (value != null && value.length < 12) {
                          return 'Between 12 and 200 characters'.tr;
                        } else {
                          return null;
                        }
                      },
                      onEditingComplete: () {
                        controller.saveTask();
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        isDense: true,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                        hintText: 'description'.tr,
                        hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
                        labelStyle: const TextStyle(color: bluePrimary),
                        filled: null,
                        fillColor: null,
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
                        counterText: "${controller.counter.value} ${'out of'.tr} 200",
                        counterStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 10,
                          height: double.minPositive,
                          fontWeight: controller.counter.value < 12 ? FontWeight.bold : FontWeight.normal,
                          color: controller.counter.value < 12 ? warning : enabledGrey,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: disabledGrey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: bluePrimary),
                        ),

                        helperText: 'between 12 and 200 characters'.tr,
                        helperStyle: kBodySmall,
                        //errorText: 'error texttt',
                        errorStyle: kBodySmall,
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: bluePrimary, width: 1.0),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: bluePrimary, width: 1.0),
                        ),
                      ),
                    ),
                  ),
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
                      listOfChipNames: controller.listOfChipNames,
                      inactiveBgColorList: const [grey_background],
                      activeTextColorList: const [witheBg],
                      activeBgColorList: const [bluePrimary],
                      inactiveTextColorList: const [bluePrimary],
                      activeBorderColorList: const [bluePrimary],
                      inactiveBorderColorList: const [bluePrimary],
                      borderRadiiList: const [20],
                      style: kLabelMedium,
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
            //SizedBox(height: kbHeight),
          ],
        ),
      );
    });
  }

  InputDecoration _myInputDecoration({
    required String hintText,
    required VoidCallback clearText,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(8),
      isDense: true,
      border: const OutlineInputBorder(),
      alignLabelWithHint: true,
      hintText: hintText,
      hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
      labelStyle: const TextStyle(color: bluePrimary),
      filled: null,
      fillColor: null,
      suffixIcon: InkWell(
        onTap: () => clearText(),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Icon(Icons.close_rounded, size: 20),
        ),
      ),
      suffixIconConstraints: const BoxConstraints(maxHeight: 100),
      counterText: "counterText",
      counterStyle: const TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 10,
        height: double.minPositive,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: disabledGrey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: bluePrimary),
      ),
      //labelText: 'label text',
      //counter: Text('new counter widget'),
      //errorText: 'error texttt',
      helperText: 'helper text',
      helperStyle: kBodySmall,
    );
  }
}
