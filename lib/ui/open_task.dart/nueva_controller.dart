import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';

class NuevaController extends GetxController {
  ///
  ///
  ///
  @override
  void onInit() {
    super.onInit();
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


