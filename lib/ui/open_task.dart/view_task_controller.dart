import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';

class ViewTaskController extends GetxController {
  ///
  
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


  // RxInt groupValueObs = 0.obs;

  // void selector({
  //   required dynamic value, //The value represented by this radio button.
  //   required dynamic groupValue, //The currently selected value for this group of radio buttons.
  //   required SelectedValueTypedef? onChanged, //Called when the user selects this radio button.
  // }) {
  //   if (value == groupValue) {
  //     onChanged!(0); //null
  //     return;
  //   }
  //   if (value != groupValue) {
  //     onChanged!(value); //value
  //   }
  //   update();
  // }

  //  //// DESCRIPCION DE LA TAREA ////
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: MyEditableTextForm(
  //               key: UniqueKey(),
  //               texto: task.value.description,
  //               onTap: () {
  //                 controller.selector(
  //                   value: task.hashCode,
  //                   groupValue: controller.groupValueObs.value, //task.value.subTasks[1],
  //                   onChanged: (value) {
  //                     controller.groupValueObs.value = value;
  //                   },
  //                 );
  //               },
  //               textStyle: controller.groupValueObs.value == task.hashCode ? kTitleLarge.copyWith(color: bluePrimary) : kTitleLarge,
  //               returnText: (value) {
  //                 task.value.description = value;
  //                 task.value.save();
  //               },
  //             ),
  //           );
}

typedef SelectedValueTypedef<T> = void Function(T value);
//typedef ValueChanged<T> = void Function(T value);


