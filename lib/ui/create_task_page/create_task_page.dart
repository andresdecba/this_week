import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/components/text_form.dart';
import 'package:todoapp/utils/helpers.dart';

class CreateTaskPage extends GetView<CreateTaskPageController> {
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          // titulo
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text('nueva tarea para el día: ${longDateFormaterWithoutYear(controller.selectedDate)}'),
          ),

          // input text
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: MyTextForm(
              hintText: 'Agregar tarea',
              autofocus: true,
              textStyle: kTitleLarge,
              clearTextOnTapOutside: false,
              maxLength: 200,
              returnText: (value) => controller.description.value = value,
            ),
          ),

          // notification
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 20, 0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChipList(
                    shouldWrap: true,
                    listOfChipNames: controller.listOfChipNames,
                    inactiveBgColorList: const [grey_background],
                    activeTextColorList: const [witheBg],
                    activeBgColorList: const [bluePrimary],
                    inactiveTextColorList: const [bluePrimary],
                    activeBorderColorList: const [bluePrimary],
                    inactiveBorderColorList: const [bluePrimary],
                    borderRadiiList: const [20],
                    style: kLabelMedium,
                    listOfChipIndicesCurrentlySeclected: [controller.currentIndex.value],
                    extraOnToggle: (val) {
                      controller.currentIndex.value = val;
                      print('aver currentIndex: ${controller.currentIndex.value}, value: $val');
                    },
                  ),
                ],
              ),
            ),
          ),

          // es rutina ?
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              children: [
                Text('es rutina'),
              ],
            ),
          ),

          // botón guardar tarea
        ],
      ),
    );
  }
}
