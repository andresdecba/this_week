import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/notification_model.dart';

import 'package:todoapp/models/subtask_model.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';

class ViewTaskController extends GetxController {
  Rx<TaskModel> task;

  ViewTaskController({
    required this.task,
  });

  @override
  void onInit() async {
    super.onInit();
    hasNotification();
  }

  ////// DATE PICKER //////
  Future<void> datePicker(BuildContext context, Rx<TaskModel> task) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // dia seleccionado (no puede ser anterior al fisrtDate)
      firstDate: task.value.taskDate, // primer dia habilitado del calendario (igual o anterior al initialDate)
      lastDate: DateTime(2050),
    );
    if (pickedDate == null) {
      return;
    } else {
      task.value.taskDate = pickedDate;
      //task.refresh();
    }
  }

  ////// NOTIFICATION TIME PICKER //////
  RxBool isNotificationActive = true.obs;
  late NotificationModel _notification;

  void hasNotification() {
    // si no tiene una notificacion, crearle una.
    _notification = NotificationModel(
      title: task.value.description,
      time: task.value.notificationData == null ? task.value.taskDate.add(const Duration(minutes: 10)) : task.value.notificationData!.time,
      payload: task.value.key.toString(),
    );
  }

  Future<void> timePicker(BuildContext context) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _notification.time.hour,
        minute: _notification.time.minute,
      ),
    );
    if (newTime == null) {
      return;
    } else {
      _notification.time = DateTime(
        _notification.time.year,
        _notification.time.month,
        _notification.time.day,
        newTime.hour,
        newTime.minute,
      );
    }
  }

  ////// SUBTASKS //////
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey();
  final Duration listDuration = const Duration(milliseconds: 500);
  final GlobalKey<FormState> newFormKey = GlobalKey<FormState>();
  void removeSubtask({required int index, required Widget child, required Rx<TaskModel> task}) {
    animatedListKey.currentState!.removeItem(
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
    task.value.save();
    task.refresh();
  }

  void createSubtask({required Rx<TaskModel> task, required String value}) {
    animatedListKey.currentState!.insertItem(
      0,
      duration: listDuration,
    );
    task.value.subTasks.insert(0, SubTaskModel(title: value, isDone: false));
    task.value.subTasks.add(SubTaskModel(title: value, isDone: false));
    task.value.save();
    task.refresh();
  }

  //// SAVE ////
  final NotificationsUseCases notificationsUseCases = NotificationsUseCasesImpl();
  void saveTaskandNavigate() async {
    // crear la notificacion
    await notificationsUseCases.createNotificationScheduledUseCase(
      notification: _notification,
      task: task.value,
    );
    // guardar y navegar
    task.value.save();
    Get.find<InitialPageController>().tasksMap.refresh();
    Get.find<InitialPageController>().buildInfo();
    Get.back();
  }
}

typedef SelectedValueTypedef<T> = void Function(T value);


/*
**** 1. CREAR TAREAS ****
-NO se puede crear una tarea anterior a hoy
-SOLO se pueden crear tareas al dia de hoy a dias futuros: limitar por UI desactivando los dias previos a hoy en el calendario
-Notificaciones: mismas reglas que crear notificaciones (punto 3)

**** 2. MOVER TAREAS ****
-NO se puede mover una tarea a dias anteriores a hoy.
-SÓLO se pueden mover las tareas al día de hoy y a dias futuros: limitar por UI desactivando los dias previos a hoy en el calendario
-Notificaciones: 
  -Tareas que se mueven posteriores a hoy: mantener notificacion con su respectiva hora.
  -Tareas que se mueven al dia de hoy: si queda vencida: eliminar, si no queda vencida: mantener.
    *ej: si reprograma una tarea para el dia de hoy y la notificacion es para las 10 pero ahora son las 11: eliminar notificacion
    *IMPORTANTE: al reprogramar recordar eliminar la notificacion vieja y crear la nueva, ver punto 5 y 6

**** 4. ELIMINAR TAREA ****
-SE PUEDEN eliminar todas las tareas pasadas, presentes y futuras.
-ACCIONES:
  *Eliminar la notificacion, si tiene.

**** 5. CREAR NOTIFICACION ****
-Solo se puede crear una notificacion desde la hora y minutos actual hacia adelante
    *Idealmente: limitar por UI desactivando los minutos y horas previas a la hora actual
    *Si no es posible lo anterior: validar y mostrar un modal avisando al usuario que no se puede crear antes de ahora.

**** 6. EDITAR NOTIFICACION ****
-Solo se puede modificar la notificacion desde la hora y minutos actual hacia adelante.
  *Idealmente: limitar por UI desactivando los minutos y horas previas a la hora actual
  *Si no es posible lo anterior: validar y mostrar un modal avisando al usuario que no se puede crear antes de ahora.
  *IMPORTANTE: al reprogramar recordar eliminar la notificacion vieja y crear la nueva

**** 7. ELIMINAR NOTIFICACION ****
-Solo se pueden eliminar las notificaciones que aun no vencieron
-ACCIONES:
  *validar que la notificacion NO venció
  *eliminar notificacion programada

**** 8. TAREAS RUTINAS ****
-crear:
  -aplica mismas reglas que crear notificacion normal (punto 1)
  ACCIONES:
    *las tareas repiten durante los proximos 12 meses
    *crear todas las notificaciones futuras

-editar:
  -solo se edita ESA intancia de la tarea, no todas las demás.
  -si quiere editar todas las tareas rutinas deberá eliminarlas y crearlas de nuevo
  -al editar, aplica mismas reglas que si fuera una notificacion normal

-eliminar:
  -eliminar ESTA tarea rutina:
    -acciones:
      *eliminar tarea
      *eliminar notificacion

  -eliminar TODAS las tareas rutinas
    -acciones:
      *eliminar todas las tareas
      *eliminar todas las notificaciones

*/
