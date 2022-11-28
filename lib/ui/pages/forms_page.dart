import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/forms_page_controller.dart';

class FormsPage extends GetView<FormsPageController> {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar nueva tarea'),
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
          ),
          child: const Text('Add task'),
          onPressed: () => controller.saveAndNavigate(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CalendarTimeline(
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    initialDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    onDateSelected: (date) => controller.setTime = date,
                    leftMargin: 20,
                    monthColor: Colors.blueGrey,
                    dayColor: Colors.teal[200],
                    activeDayColor: Colors.white,
                    activeBackgroundDayColor: Colors.redAccent[100],
                    dotsColor: Color(0xFF333A47),
                    selectableDayPredicate: (date) => date.day != 23,
                    locale: 'en_ISO',
                    //showYears: true,
                  ),
                  const SizedBox(height: 30),
                  const TaskForms(),
                  const SizedBox(height: 30),
                  const Divider(),

                  ToggleButton(
                    controller: controller,
                  ),
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Agrega una subtarea',
                        style: TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => buildSubtaskBottomSheet(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  const SubTasksListView(),
                  //const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleButton extends StatefulWidget {
  const ToggleButton({required this.controller, Key? key}) : super(key: key);
  final FormsPageController controller;
  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      //backgroundColor:  CupertinoColors.white,
      thumbColor: CupertinoColors.activeGreen,
      children: const {
        0: Text('PENDING'),
        1: Text('IN PROGRESS'),
        2: Text('DONE'),
      },
      groupValue: groupValue,
      onValueChanged: (value) {
        
        setState(() {});
        groupValue = value!;
        switch (value) {
          case 0:
            widget.controller.taskStatus = TaskStatus.PENDING.toValue;
            break;
          case 1:
            widget.controller.taskStatus = TaskStatus.IN_PROGRESS.toValue;
            break;
          case 2:
            widget.controller.taskStatus = TaskStatus.DONE.toValue;
            break;
        }
      },
    );
  }
}

class SubTasksListView extends GetView<FormsPageController> {
  const SubTasksListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.getSubTaskList.value.isEmpty
        ? const Text('No hay subtasks')
        : ReorderableListView.builder(
            shrinkWrap: true,
            itemCount: controller.getSubTaskList.value.length,
            itemBuilder: (BuildContext context, int index) {
              return ReorderableDragStartListener(
                key: Key('$index'),
                index: index,
                child: Container(
                  key: Key('$index'),
                  constraints: const BoxConstraints(minWidth: 100, maxWidth: 100),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[350],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(controller.getSubTaskList.value[index].title),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.fillSubTaskTFWhenUpdate(index);
                              buildSubtaskBottomSheet(context);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => controller.deleteSubtask(index),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final SubTask item = controller.getSubTaskList.value.removeAt(oldIndex);
              controller.getSubTaskList.value.insert(newIndex, item);
            },
          ));
  }
}

void buildSubtaskBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    backgroundColor: Colors.amber,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          right: 16,
          left: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text('Agregar una subtarea'),
            SizedBox(height: 30),
            SubTaskForms(),
          ],
        ),
      );
    },
  );
}

class TaskForms extends GetView<FormsPageController> {
  const TaskForms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilder(
          key: controller.taskFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          //onWillPop: () => controller.onWillPop(),
          skipDisabled: true,
          initialValue: const {
            //'titleField': 'Este es un titulo' //el name del field + el valor inicial que queremos
          },
          child: Column(
            children: [
              // title form
              FormBuilderTextField(
                controller: controller.taskTitleCtrlr,
                name: 'taskTitleTf',
                enabled: true,
                //initialValue: controller.getNewTask.title,
                decoration: const InputDecoration(
                  isDense: true,
                  //border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.error),
                ),
              ),

              const SizedBox(height: 10),

              // title form
              FormBuilderTextField(
                controller: controller.taskDescriptionCtrlr,
                name: 'taskDescriptionTf',
                enabled: true,
                //initialValue: controller.getNewTask.description,
                maxLines: 6,
                decoration: const InputDecoration(
                  isDense: true,
                  //border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.error),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class SubTaskForms extends GetView<FormsPageController> {
  const SubTaskForms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilder(
          key: controller.subTaskFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          skipDisabled: true,
          //onWillPop: () => controller.onWillPop(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // title form
              FormBuilderTextField(
                controller: controller.subTaskTitleCtrlr,
                name: 'subTaskTitleTf',
                enabled: true,
                //initialValue: updateSubTask?.title ?? '',
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.error),
                ),
              ),

              const SizedBox(height: 10),

              // title form
              FormBuilderTextField(
                controller: controller.subTaskDescriptionCtrlr,
                name: 'subTaskDescriptionTf',
                enabled: true,
                //initialValue: 'controller.getNewTask.title',
                maxLines: 6,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.error),
                ),
              ),

              const SizedBox(height: 10),

              // get text
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Add or update subtask'),
                onPressed: () {
                  controller.createOrUpdateSubTask();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
