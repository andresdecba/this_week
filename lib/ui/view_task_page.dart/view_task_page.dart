import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/shared_components/my_chip.dart';
import 'package:todoapp/ui/view_task_page.dart/components/my_editable_text_form.dart';
import 'package:todoapp/ui/view_task_page.dart/components/create_subtask_form.dart';
import 'package:todoapp/ui/view_task_page.dart/components/subtask_animated_list.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';

class ViewTask extends GetView<ViewTaskController> {
  const ViewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// DESCRIPCION DE LA TAREA ///
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text('description'.tr),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                        child: MyEditableTextForm(
                          key: UniqueKey(),
                          texto: controller.task.value.description,
                          onTap: () {},
                          textStyle: kViewTaskDescripton,
                          returnText: (value) => controller.saveDescriptionUpdate(value),
                        ),
                      ),

                      /// CHIPS ///
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyChip(
                              label: '22/22/99',
                              iconData: Icons.calendar_today_rounded,
                              onTap: () {},
                            ),
                            const SizedBox(width: 5),
                            MyChip(
                              label: '09:00 hs.',
                              iconData: Icons.notifications_active_rounded,
                              onTap: () {},
                            ),
                            const SizedBox(width: 5),
                            MyChip(
                              label: 'Eliminar',
                              iconData: Icons.delete_forever_outlined,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text('subtasks'.tr),
                      ),

                      //// CREAR NUEVA SUBTAREA ////
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: CreateSubtaskForm(),
                        //child: TextField(),
                      ),

                      //// LISTA DE SUBTAREAS ////
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: SubtasksAnimatedList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

