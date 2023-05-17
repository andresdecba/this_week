import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/backup_open_task.dart';
import 'package:todoapp/ui/open_task.dart/components/description.dart';
import 'package:todoapp/ui/open_task.dart/components/info.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';
import 'package:todoapp/ui/open_task.dart/components/subtasks.dart';
import 'package:todoapp/ui/open_task.dart/components/task_options.dart';
import 'package:todoapp/ui/open_task.dart/open_task_controller.dart';
import 'package:todoapp/ui/shared_components/custom_text_field.dart';

class OpenTask extends GetView<OpenTaskController> {
  OpenTask({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;
  final controler = Get.lazyPut<OpenTaskController>(() => OpenTaskController());

  @override
  Widget build(BuildContext context) {
    final TextEditingController ctrlr1 = TextEditingController();
    ctrlr1.text = task.value.description;
    FocusNode focusNodeDesc = FocusNode();

    return Obx(
      () => Form(
        key: controller.newFormKey,
        onWillPop: () async {
          if (FocusScope.of(context).hasFocus) {
            //controller.isUpdateFormStyle.value && ocusScope.of(context).hasFocus
            FocusScope.of(context).unfocus();
            controller.isUpdateFormStyle.value = false;
            return false;
          } else {
            return true;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                //key: UniqueKey(),
                focusNode: focusNodeDesc,
                controller: ctrlr1,
                maxLines: null,
                maxLength: 200,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                style: controller.isUpdateFormStyle.value
                    ? kTitleLarge.copyWith(
                        fontSize: 22,
                        color: blackBg,
                        backgroundColor: bluePrimary.withOpacity(0.15),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                      )
                    : kTitleLarge.copyWith(fontSize: 22),
                decoration: _customInputDecoration(
                  isUpdateStyle: controller.isUpdateFormStyle.value, //
                  label: 'task description'.tr,
                  hintText: 'hintText', //'task description_description'.tr,
                  clearText: () => ctrlr1.clear(),
                ),
                onTap: () {
                  controller.isUpdateFormStyle.value = true;
                  //debugPrint('aver: ${controller.isUpdateFormStyle.value}');
                },
                validator: (value) {
                  //
                },
                onEditingComplete: () {
                  controller.isUpdateFormStyle.value = false;
                  task.value.description = ctrlr1.text;
                  //task.refresh();
                  task.value.save();
                  debugPrint('aver: holhlhlhlh');
                  FocusScope.of(context).unfocus();
                },
                onTapOutside: (event) {
                  controller.isUpdateFormStyle.value = false;
                  //FocusScope.of(context).unfocus();
                  debugPrint('aver: description outside: ${focusNodeDesc.hasFocus}');
                  if (focusNodeDesc.hasFocus) {
                    focusNodeDesc.unfocus();
                  }
                },
              ),

              const SizedBox(height: 20),

              // subtareas
              //Subtasks(task: task),
              AnimatedList(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                initialItemCount: task.value.subTasks.length,
                key: controller.animatedListKey,
                itemBuilder: (context, index, animation) {
                  SubTaskModel e = task.value.subTasks[index];
                  final TextEditingController textEditingController = TextEditingController();
                  controller.textEditingControllerList.add(textEditingController);
                  FocusNode focusNode = FocusNode();
                  controller.focusNodeList.add(focusNode);
                  textEditingController.text = e.title;
                  bool cambiar = false;
                  Widget child = Row(
                    key: UniqueKey(),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // leading
                      SmallButton(
                        onTap: () {},
                        icon: e.isDone ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
                        iconColor: e.isDone ? disabledGrey : null,
                      ),
                      // descripcion
                      Flexible(
                        child: CustomTextField(
                          focusNode: controller.focusNode,
                          initialValue: e.title,
                          textStyle: e.isDone ? doneTxtStyle : kTitleMedium,
                          getValue: (value) {},
                        ),
                      ),
                      // trailing
                      Visibility(
                        visible: e.isDone,
                        child: SmallButton(
                          icon: Icons.close_rounded,
                          iconColor: disabledGrey,
                          onTap: () {},
                        ),
                      ),
                    ],
                  );
                  return FadeTransition(
                    key: UniqueKey(),
                    opacity: animation,
                    child: SizeTransition(
                      key: UniqueKey(),
                      sizeFactor: animation,
                      child: Container(
                        decoration: BoxDecoration(
                          border: index + 1 == task.value.subTasks.length ? null : const Border(bottom: BorderSide(width: 1.0, color: disabledGrey)),
                        ),
                        child: Row(
                          key: UniqueKey(),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // leading
                            SmallButton(
                              onTap: () {
                                e.isDone = !e.isDone;
                                task.refresh();
                              },
                              icon: e.isDone ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
                              iconColor: e.isDone ? disabledGrey : null,
                            ),
                            // descripcion
                            Expanded(
                              child: TextFormField(
                                key: UniqueKey(),
                                focusNode: focusNode,
                                controller: textEditingController,
                                maxLines: null,
                                maxLength: 200,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                                textInputAction: TextInputAction.done,
                                style: focusNode.hasFocus
                                    ? kBodyMedium.copyWith(
                                        color: blackBg,
                                        backgroundColor: bluePrimary.withOpacity(0.15),
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.normal,
                                      )
                                    : kBodyMedium,
                                decoration: _customInputDecoration(
                                  isUpdateStyle: cambiar, //
                                  label: 'task description'.tr,
                                  hintText: 'hintText', //'task description_description'.tr,
                                  clearText: () => ctrlr1.clear(),
                                ),
                                onTap: () {
                                  debugPrint('aver: subtask $index onTap: ${focusNode.hasPrimaryFocus}');
                                  //cambiar = true;
                                  //debugPrint('aver: onTap $cambiar');
                                },
                                onChanged: (value) {
                                  debugPrint('aver: subtask $index onChanged: ${focusNode.hasPrimaryFocus}');
                                },
                                validator: (value) {},
                                onEditingComplete: () {
                                  cambiar = false;
                                  //FocusScope.of(context).unfocus();
                                },
                                onTapOutside: (event) {
                                  cambiar = false;
                                  debugPrint('aver: subtask $index outside: ${focusNode.hasPrimaryFocus}');
                                  if (focusNode.hasFocus) {
                                    focusNode.unfocus();
                                  }
                                  //FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                            // trailing
                            Visibility(
                              visible: e.isDone,
                              child: SmallButton(
                                icon: Icons.close_rounded,
                                iconColor: disabledGrey,
                                onTap: () {
                                  controller.removeSubtask(
                                    index: index,
                                    task: task.value,
                                    child: child,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class Cosooo extends StatelessWidget {
//   const Cosooo({
//     required this.focusNode,
//     required this.textEditingController,
//     required this.textStyle,
//     required this.isUpdate,
//     Key? key,
//   }) : super(key: key);

//   final FocusNode focusNode;
//   final TextEditingController textEditingController;
//   final TextStyle textStyle;
//   final bool isUpdate;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       //key: UniqueKey(),
//       focusNode: focusNode,
//       controller: textEditingController,
//       maxLines: null,
//       maxLength: 200,
//       keyboardType: TextInputType.text,
//       textCapitalization: TextCapitalization.sentences,
//       textInputAction: TextInputAction.done,
//       style: textStyle,
//       decoration: _customInputDecoration(
//         isUpdateStyle: isUpdate,
//         label: 'task description'.tr,
//         hintText: 'hintText',
//         clearText: () => textEditingController.clear(),
//       ),
//       onTap: () {
//         controller.isUpdateFormStyle.value = true;
//       },
//       validator: (value) {},
//       onEditingComplete: () {
//         controller.isUpdateFormStyle.value = false;
//         task.value.description = ctrlr1.text;
//         task.value.save();
//         focusNode.unfocus();
//       },
//       onTapOutside: (event) {
//         controller.isUpdateFormStyle.value = false;
//         if (focusNode.hasFocus) {
//           focusNode.unfocus();
//         }
//       },
//     );
//   }
// }

///// DECORATION STYLES   /////

final doneTxtStyle = kTitleMedium.copyWith(
  decoration: TextDecoration.lineThrough,
  fontStyle: FontStyle.italic,
  color: disabledGrey,
);

InputDecoration _customInputDecoration({
  required String label,
  required String hintText,
  required VoidCallback clearText,
  required bool isUpdateStyle,
}) {
  return InputDecoration(
    //labelStyle: const TextStyle(color: bluePrimary),
    //filled: true,
    contentPadding: EdgeInsets.zero, // readOnly ? const EdgeInsets.fromLTRB(8, 8, 8, 8) : EdgeInsets.zero,
    isDense: true,
    border: InputBorder.none, // readOnly ? const OutlineInputBorder() : InputBorder.none,
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: kBodyMedium.copyWith(fontStyle: FontStyle.italic, color: disabledGrey),
    fillColor: witheBg.withOpacity(0.4),
    counterText: "",
    suffixIconConstraints: const BoxConstraints(maxHeight: 100),
    counterStyle: const TextStyle(
      fontStyle: FontStyle.italic,
      fontSize: 10,
      height: double.minPositive,
    ),
  );
}
