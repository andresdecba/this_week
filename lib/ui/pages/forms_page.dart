import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/controllers/forms_page_controller.dart';
import 'package:todoapp/ui/widgets/alert_dialog.dart';
import 'package:todoapp/ui/widgets/background_widget.dart';
import 'package:todoapp/ui/widgets/subtask_item.dart';
import 'package:todoapp/ui/widgets/toggle_status_btn.dart';
import 'package:todoapp/utils/parse_date_utils.dart';

class FormsPage extends GetView<FormsPageController> {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.onWillPop(context),
      child: Scaffold(

        appBar: AppBar(
          leading: IconButton(
            onPressed: () => controller.onWillPop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Agregar nueva tarea'),
          actions: [
            IconButton(
              onPressed: () => controller.isEditionEnabled.value = true,
              icon: const Icon(Icons.edit),
            ),
          ],
        ),

        bottomNavigationBar: Obx(
          () {
            return controller.isEditionEnabled.value
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      onPressed: () => controller.saveAndNavigate(),
                      child: const Text(
                        'Add task',
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),

        body: SafeArea(
          child: Obx(
            () => SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // PASO 1: SELECCIONAR DIA
                  BackgroundWidget(
                    child: Obx(() {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '1 - Crear tarea para el día:',
                            style: titleTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ParseDateUtils.dateToString(controller.getTime)),
                              IconButton(
                                icon: const Icon(Icons.edit_calendar),
                                visualDensity: VisualDensity.compact,
                                color: controller.isEditionEnabled.value ? iconColor : disabledColor,
                                onPressed: () async {
                                  // show the dialog
                                  var tmpData = controller.getTime;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return CustomDialog(
                                        title: 'Cambiar fecha',
                                        content: SizedBox(
                                          height: 300,
                                          width: 200,
                                          child: CalendarDatePicker(
                                            initialDate: controller.getTime,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(const Duration(days: 365)),
                                            onDateChanged: (date) {
                                              tmpData = date;
                                            },
                                          ),
                                        ),
                                        okCallBack: () => controller.setTime = tmpData,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),

                  // PASO 2: PONER TITLE + DESCRIPTION
                  BackgroundWidget(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '2 - Ingresa un título y una descripción',
                              style: titleTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const TitleAndDescriptionForms(),
                      ],
                    ),
                  ),

                  // PASO 3: AGREGAR UN STATUS
                  BackgroundWidget(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '3 - Opcional: definir un status inical',
                          style: titleTextStyle,
                        ),
                        Center(
                          child: ToggleStatusButton(
                            task: controller.getTask,
                            onChanged: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  // PASO 4: AGREGAR SUBTAREAS
                  BackgroundWidget(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '4 - Opcional: agregar subtareas',
                              style: titleTextStyle,
                            ),
                            customAddIcon(
                              isEnabled: controller.isEditionEnabled.value,
                              onPressed: () => showSubtaskDialog(
                                context,
                                () => controller.createOrUpdateSubTask(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const SubTasksListView(),
                        //const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// textfields de titulo y descripcion
class TitleAndDescriptionForms extends GetView<FormsPageController> {
  const TitleAndDescriptionForms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Form(
          child: Column(
            children: [
              // titulo
              TextFormField(
                enabled: controller.isEditionEnabled.value,
                controller: controller.taskTitleCtrlr,
                decoration: customInputDecoration(
                  hasBorder: controller.isEditionEnabled.value,
                  label: 'Título*',
                  hintText: 'Ingrese un título para la tarea',
                  borderColor: Colors.orange,
                  clearText: () => controller.taskTitleCtrlr.clear(),
                ),
                maxLines: 4,
                maxLength: 140,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
              ),
              // descripcion
              const SizedBox(height: 10),
              TextFormField(
                enabled: controller.isEditionEnabled.value,
                controller: controller.taskDescriptionCtrlr,
                decoration: customInputDecoration(
                  hasBorder: controller.isEditionEnabled.value,
                  label: 'Descripción',
                  hintText: 'Opcional: Ingrese un descripción',
                  clearText: () => controller.taskDescriptionCtrlr.clear(),
                ),
                maxLines: 4,
                maxLength: 200,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// lista de subtareas agregadas
class SubTasksListView extends GetView<FormsPageController> {
  const SubTasksListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.getSubTaskList.value.isEmpty
          ? const Center(child: Text('No hay subtasks'))
          : ReorderableListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.getSubTaskList.value.length,
              itemBuilder: (BuildContext context, int index) {
                return SubTaskItem(
                  controller: controller,
                  index: index,
                  key: Key('$index'),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final SubTask item = controller.getSubTaskList.value.removeAt(oldIndex);
                controller.getSubTaskList.value.insert(newIndex, item);
              },
            ),
    );
  }
}

// crear subtarea modal
Future<dynamic> showSubtaskDialog(BuildContext context, VoidCallback callBack) {
  return showDialog(
    context: context,
    builder: (_) {
      return CustomDialog(
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Text('Agregar una subtarea'),
              SizedBox(height: 30),
              SubTaskForms(),
            ],
          ),
        ),
        okCallBack: callBack,
      );
    },
  );
}

// textfield de la subtarea
class SubTaskForms extends GetView<FormsPageController> {
  const SubTaskForms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: controller.subTaskTitleCtrlr,
            enabled: true,
            maxLines: 4,
            decoration: customInputDecoration(
              label: 'Subtarea',
              hintText: 'Ingresar descripcion de la subtarea',
              clearText: () => controller.subTaskTitleCtrlr.clear(),
            ),
            maxLength: 100,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            autofocus: true,
          ),
        ],
      ),
    );
  }
}
