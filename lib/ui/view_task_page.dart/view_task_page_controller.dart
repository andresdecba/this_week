import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/shared_components/my_time_picker.dart';
import 'package:todoapp/ui/shared_components/snackbar.dart';
import 'package:todoapp/use_cases/local_notifications_use_cases.dart';
import 'package:todoapp/use_cases/tasks_use_cases.dart';
import 'package:todoapp/utils/helpers.dart';

class ViewTaskController extends GetxController {
  final Rx<TaskModel> task;

  ViewTaskController({
    required this.task,
  });

  @override
  void onInit() {
    super.onInit();
    focusNode = FocusNode();
    textController = TextEditingController();
    localNotificationsUseCases = LocalNotificationsUseCases();
    tasksUseCases = TaskUseCasesImpl();
    setInitialValues();
    textController.addListener(() {
      counter.value = textController.text.length;
    });
    descriptionTxtCtr.text = task.value.description;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    textController.dispose();
  }

  late LocalNotificationsUseCases localNotificationsUseCases;
  late TaskUseCasesImpl tasksUseCases;

  //// task values ////
  // intentar pasar estas variables a late (da un error, puede ser mal declarado en getx)
  RxString updatedDescription = ''.obs;
  Rx<DateTime> updatedDateTime = DateTime.now().obs;
  Rxn<TimeOfDay> updatedNotification = Rxn<TimeOfDay>();
  RxBool isExpired = false.obs;

  void setInitialValues() {
    updatedDateTime.value = task.value.date;
    updatedDescription.value = task.value.description;
    updatedNotification.value = task.value.notificationData != null //
        ? TimeOfDay(hour: task.value.notificationData!.time.hour, minute: task.value.notificationData!.time.minute) //
        : null; //
    isExpired.value = isTaskExpired(updatedDateTime.value);
  }

  //// DATE STATUS ////
  Widget dateStatus() {
    if (isExpired.value) {
      return Text(
        'expired_state'.tr,
        style: kBodyMedium.copyWith(color: Colors.orange[900], fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      );
    } else if (updatedDateTime.value.day == DateTime.now().day) {
      return Text(
        'today_state'.tr,
        style: kBodyMedium.copyWith(color: Colors.green[900], fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        'another day_state'.tr,
        style: kBodyMedium.copyWith(color: Colors.purple[900], fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      );
    }
  }

  //// UPDATE DESCRIPTION ////
  RxBool descriptionEditMode = false.obs;
  final FocusNode descriptionFocusNode = FocusNode();
  final TextEditingController descriptionTxtCtr = TextEditingController();

  void updateDescription() {
    if (updatedDescription.value != descriptionTxtCtr.text) {
      hasUpdated.value = true;
      updatedDescription.value = descriptionTxtCtr.text;
    }
    descriptionEditMode.value = false;
    descriptionFocusNode.unfocus();
  }

  ////// UPDATE DATE //////
  Future<void> updateDate(BuildContext context, Rx<TaskModel> task) async {
    late DateTime initialDate;
    late DateTime firstDate;
    // si la tarea es vencida
    if (task.value.date.isBefore(DateTime.now())) {
      initialDate = DateTime.now();
      firstDate = DateTime.now();
    }
    // si la tarea esta en el futuro
    if (task.value.date.isAfter(DateTime.now())) {
      initialDate = task.value.date;
      firstDate = DateTime.now();
    }
    // pick a date
    await showDatePicker(
      context: context,
      initialDate: initialDate, // dia seleccionado del calendario (no puede ser anterior al fisrtDate)
      firstDate: firstDate, // primer dia habilitado del calendario (igual o anterior al initialDate)
      lastDate: DateTime(2050),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        hasUpdated.value = true;
        updatedDateTime.value = value;
      }
    });
  }

  ////// UPDATE NOTIFICATION TIME //////
  void updateNotification(BuildContext context) async {
    await myTimePicker(context, task.value.date).then((value) {
      if (value != null) {
        updatedNotification.value = value;
        hasUpdated.value = true;
      } else {
        return;
      }
    });
  }

  //// DELETE TASK ////
  RxBool isChecked = false.obs;
  void deleteTask(BuildContext context) {
    tasksUseCases.deleteTaskUseCase(task: task, deleteRoutine: isChecked.value);
    Get.back();
    showSnackBar(titleText: 'task deleted', messageText: task.value.description);
  }

  ////// SUBTASKS //////
  final Duration listDuration = const Duration(milliseconds: 500);

  // subtask form //
  late FocusNode focusNode;
  late TextEditingController textController;
  RxInt counter = 0.obs;
  // methods //
  void createSubtask() {
    if (Globals.formStateKey.currentState!.validate()) {
      Globals.animatedListStateKey.currentState!.insertItem(
        0,
        duration: listDuration,
      );
      task.value.subTasks.insert(0, SubTaskModel(title: textController.text, isDone: false));
      tasksUseCases.updateTaskState(task: task);
      textController.clear();
    }
  }

  void updateTitleSubtask(SubTaskModel subTask, String? title) {
    subTask.title = title ?? subTask.title;
    tasksUseCases.updateTaskState(task: task);
  }

  void updateStatusSubtask(SubTaskModel subTask) {
    subTask.isDone = !subTask.isDone;
    tasksUseCases.updateTaskState(task: task);
  }

  void removeSubtask({required int index, required Widget child, required Rx<TaskModel> task}) {
    Globals.animatedListStateKey.currentState!.removeItem(
      index,
      duration: listDuration,
      (context, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        ); //;
      },
    );
    task.value.subTasks.remove(task.value.subTasks[index]);
    tasksUseCases.updateTaskState(task: task);
  }

  ////// SAVE UPDATED TASK //////
  // este botón solo guarda cambios en: descripción, cambio de fecha y cambio de notificación
  // los cambios en las subtareas se guardan al momento de interactuar
  RxBool hasUpdated = false.obs;
  void saveUpdatedTask() {
    // cambió la descripcion
    if (task.value.description != updatedDescription.value) {
      task.value.description = updatedDescription.value;
    }

    // cambió la fecha
    if (task.value.date != updatedDateTime.value) {
      task.value.date = updatedDateTime.value;
      // -2e: Tareas que se mueven al dia de hoy:
      // si hora de notificacion queda vencida: eliminar, si no queda vencida: mantener.
      if (isTaskToday(updatedDateTime.value) && updatedNotification.value != null) {
        if (timeOfDayIsBeforeNow(updatedNotification.value!)) {
          localNotificationsUseCases.deleteNotification(task: task);
        } else {
          localNotificationsUseCases.createNotification(
            task: task,
            newTime: updatedNotification.value!,
          );
        }
      }

      tasksUseCases.updateTaskState(task: task, isDateUpdated: true);
      showSnackBar(
        titleText: 'task updated',
        messageText: task.value.description,
      );
      Get.back();
      return;
    }

    // cambió la notificacion
    if (updatedNotification.value != null) {
      if (task.value.notificationData != null) {
        final TimeOfDay taskNotificationTime = TimeOfDay(
          hour: task.value.notificationData!.time.hour,
          minute: task.value.notificationData!.time.minute,
        );
        if (updatedNotification.value != taskNotificationTime) {
          localNotificationsUseCases.createNotification(
            task: task,
            newTime: updatedNotification.value!,
          );
        }
      } else {
        localNotificationsUseCases.createNotification(
          task: task,
          newTime: updatedNotification.value!,
        );
      }
    }
    // guardar
    tasksUseCases.updateTaskState(task: task, isDateUpdated: true);
    showSnackBar(
      titleText: 'task updated',
      messageText: task.value.description,
    );
    Get.back();
    return;
  }
}

typedef SelectedValueTypedef<T> = void Function(T value);
