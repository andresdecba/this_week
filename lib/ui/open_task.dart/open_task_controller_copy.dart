import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';

mixin OpenTaskController {
  //
  RxBool isNotificationActive = true.obs;

  ////// manage DATE AND TIME PICKERS //////
  Future<void> datePicker(BuildContext context, Rx<TaskModel> task) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: task.value.taskDate, // dia seleccionado
      firstDate: DateTime.now(), // primer dia habilitado
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 500,
              width: 350,
              child: child,
            ),
          ],
        );
      },
    );
    if (pickedDate == null) {
      return;
    } else {
      task.value.taskDate = pickedDate;
      task.refresh();
    }
  }

  Future<void> timePicker(BuildContext context, Rx<TaskModel> task) async {
    late Time timeValue;

    if (task.value.notificationTime == null) {
      timeValue = Time(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute,
      );
    } else if (task.value.notificationTime != null && task.value.notificationTime!.isBefore(DateTime.now())) {
      timeValue = Time(
        hour: DateTime.now().hour,
        minute: DateTime.now().add(const Duration(minutes: 5)).minute,
      );
    } else {
      timeValue = Time(
        hour: task.value.notificationTime!.hour,
        minute: task.value.notificationTime!.minute,
      );
    }

    Navigator.of(context).push(
      showPicker(
        //accentColor: bluePrimary,
        iosStylePicker: true,
        borderRadius: 20,
        context: context,
        value: timeValue,
        //minHour: timeValue.hour.toDouble(),
        //minMinute: timeValue.minute.toDouble(),
        is24HrFormat: false,
        hourLabel: 'Hrs.',
        minuteLabel: 'Mins.',
        okStyle: kTitleLarge,
        cancelStyle: kTitleLarge,
        onChange: (time) {
          var value = DateTime(
            task.value.notificationTime?.year ?? DateTime.now().year,
            task.value.notificationTime?.month ?? DateTime.now().month,
            task.value.notificationTime?.day ?? DateTime.now().day,
            time.hour,
            time.minute,
          );
          task.value.notificationTime = value;
          task.refresh();
        },
      ),
    );
  }

  ////// manage FORMS //////
  ///;
  List<FocusNode> focusList = [];

  // propiedades para el formulario
  final GlobalKey<FormState> newFormKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  RxBool isUpdateFormStyle = false.obs;

  // lista animada de las subtareas
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey();
  final Duration listDuration = const Duration(milliseconds: 500);

  void createSubtask({required TaskModel task, required String textValue}) {
    animatedListKey.currentState!.insertItem(
      0,
      duration: listDuration,
    );
    task.subTasks.insert(0, SubTaskModel(title: textValue, isDone: false));
  }

  void removeSubtask({required int index, required Widget child, required TaskModel task}) {
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
    task.subTasks.remove(task.subTasks[index]);
  }

  // void updateTextSubtask(int index) {
  //   _task.update(
  //     (val) {
  //       val!.subTasks[index].title = subTaskTitleCtrlr.text;
  //       if (currentPageMode.value == PageMode.VIEW_MODE || currentPageMode.value == PageMode.UPDATE_MODE) {
  //         _task.value.save();
  //       }
  //       subTaskTitleCtrlr.clear();
  //     },
  //   );
  // }

  // void updateStatusSubtask(int index) {
  //   _task.update(
  //     (val) {
  //       val!.subTasks[index].isDone = !_task.value.subTasks[index].isDone;
  //       if (currentPageMode.value == PageMode.VIEW_MODE || currentPageMode.value == PageMode.UPDATE_MODE) {
  //         _task.value.save();
  //       }
  //     },
  //   );
  // }

  // void deleteSubtask(int index) {
  //   _task.update((val) {
  //     val!.subTasks.removeAt(index);
  //     if (currentPageMode.value == PageMode.VIEW_MODE || currentPageMode.value == PageMode.UPDATE_MODE) {
  //       _task.value.save();
  //     }
  //   });
  // }

  // void onCancelSubtask(BuildContext context) {
  //   subTaskTitleCtrlr.clear();
  //   Navigator.of(context).pop();
  // }
}
