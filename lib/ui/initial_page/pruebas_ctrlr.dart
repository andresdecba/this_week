import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/models/task_model.dart';

mixin PruebasCtrlr {
  ////////////
  List<Rx<TaskModel>> getWeekTasks({required Week week, required Box<TaskModel> tasksBox}) {
    //
    List<Rx<TaskModel>> listadeobservables = [];
    var firstDay = week.days.first.subtract(const Duration(days: 1));
    var lastDay = week.days.last.add(const Duration(days: 1));

    List<TaskModel> result = tasksBox.values.where((task) {
      return task.taskDate.isAfter(firstDay) && task.taskDate.isBefore(lastDay);
    }).toList();

    for (var element in result) {
      Rx<TaskModel> taskObs = element.obs;
      listadeobservables.add(taskObs);
    }

    debugPrint('averga $result');
    return listadeobservables;
  }

  // //////////// RESPALDO
  // List<TaskModel> getWeekTasks({required Week week, required Box<TaskModel> tasksBox}) {
  //   //
  //   var firstDay = week.days.first.subtract(const Duration(days: 1));
  //   var lastDay = week.days.last.add(const Duration(days: 1));

  //   List<TaskModel> result = tasksBox.values.where((task) {
  //     return task.taskDate.isAfter(firstDay) && task.taskDate.isBefore(lastDay);
  //   }).toList();

  //   debugPrint('averga $result');
  //   return result;
  // }
}
