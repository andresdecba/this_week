import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/open_task.dart/borrar_dos.dart';
import 'package:todoapp/ui/open_task.dart/components/description.dart';
import 'package:todoapp/ui/open_task.dart/components/info.dart';
import 'package:todoapp/ui/open_task.dart/components/subtasks.dart';
import 'package:todoapp/ui/open_task.dart/components/task_options.dart';
import 'package:todoapp/ui/shared_components/custom_text_field.dart';

class OpenTask extends GetView<InitialPageController> {
  OpenTask({required this.task, Key? key}) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        BorrarDos(),

        // Expanded(
        //   child: SingleChildScrollView(
        //     physics: const BouncingScrollPhysics(),
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        //           child: Form(
        //             key: controller.newFormKey,
        //             onWillPop: () async {
        //               //FocusScope.of(context).unfocus();
        //               //controller.focusNode.unfocus();
        //               debugPrint('aver: newFormKey');
        //               return true;
        //             },
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 // desxription
        //                 const Padding(
        //                   padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        //                   child: Text('Descripción'),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        //                   child: Description(task: task),
        //                 ),

        //                 // subtasks
        //                 const Padding(
        //                   padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        //                   child: Text('Subtareas'),
        //                 ),

        //                 // insert subtask
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        //                   child: CustomTextField(
        //                     //textValue: 'hola cambiar...',
        //                     //enableReadOnly: true,
        //                     key: UniqueKey(),
        //                     focusNode: controller.focusNode,
        //                     hintText: 'Escribe una subtarea',
        //                     getValue: (value) {
        //                       controller.createSubtask(
        //                         task: task.value,
        //                         textValue: value,
        //                       );
        //                     },
        //                   ),
        //                 ),

        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        //                   child: Subtasks(task: task),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // info de la task
        // const Divider(color: blackBg, height: 0),
        // Info(task: task),

        // opciones del widget
        // const Divider(color: disabledGrey, height: 0),
        // TaskOptions(task: task),
        //const SizedBox(height: 8),
      ],
    );
  }
}
