import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/utils/parse_date_utils.dart';

class InitialPageController extends GetxController {
  // box de tasks
  Box<Task> tasksBox = Boxes.getTasksBox();
  List<Task> get getTasks => tasksBox.values.toList();

  // related to buil days an weeks
  int addWeeks = 0;
  List<DateTime> weekDays = [];
  Map<DateTime, List<Task>> buildWeek = {};
  String initialFinalDays = '';

  // create strings for head
  Week showCurrenWeekInfo = Week.current();
  Rx<String> weekDaysFromTo = ''.obs;
  Rx<String> tasksPercentageCompleted = ''.obs;

  // others
  GlobalKey<AnimatedListState> key = GlobalKey();

  @override
  void onInit() {
    buildInfo();
    super.onInit();
  }

  /// ejemplo del modelo de datos
  //Map<DateTime, List<Task>> buildWeekDemo = {
  //  'Lunes 26-11-2022'    : ['task_1', 'task_2'],
  //  'Martes 27-11-2022'   : ['task_1', 'task_2'],
  //  'Miercoles 28-11-2022': [],
  //  'Jueves 29-11-2022'   : ['task_1'],
  //  'Viernes 30-11-2022'  : ['task_1', 'task_2'],
  //  'Sabado 01-12-2022'   : [],
  //  'Domingo 02-12-2022'  : [],
  //};

  void buildInfo() {
    //{int? addWks}
    // limpiar lista para evitar duplicados
    weekDays.clear();
    buildWeek.clear();
    // crear los dias
    Week currentWeek = Week.current();

    if (addWeeks == 0) {
      //addWks == null
      weekDays = currentWeek.days;
      showCurrenWeekInfo = currentWeek;
    }
    if (addWeeks > 0) {
      currentWeek = currentWeek.addWeeks(addWeeks);
      weekDays = currentWeek.days;
      showCurrenWeekInfo = currentWeek;
    }

    // ordenar las tareas segun los dias
    for (var day in weekDays) {
      buildWeek.addAll({day: []});
    }

    for (var element in buildWeek.entries) {
      /// agregar la tarea
      for (var task in tasksBox.values) {
        if (task.dateTime == element.key) {
          element.value.add(task);
        }
      }
    }
    setInitialAndFinalWeekDays();
    createCompletedTasksPercentage();
    update();
  }

  /// create head info
  void setInitialAndFinalWeekDays() {
    var week = showCurrenWeekInfo.weekNumber.toString();
    var days = '${ParseDateUtils.dateToAbbreviateString(showCurrenWeekInfo.days.first)} al ${ParseDateUtils.dateToAbbreviateString(showCurrenWeekInfo.days.last)}';
    weekDaysFromTo.value = 'Semana $week: $days';
  }

  void createCompletedTasksPercentage() {
    int totalTasks = 0;
    int completedTotalTasks = 0;
    int completedTasksPercent = 0;

    for (var value in buildWeek.values) {
      totalTasks += value.length;
      for (var element in value) {
        if (element.status == TaskStatus.DONE.toValue) {
          completedTotalTasks += 1;
        }
      }
    }
    if (totalTasks != 0) {
      completedTasksPercent = ((completedTotalTasks / totalTasks) * 100).toInt();
    }
    // set message
    totalTasks == 0 ? tasksPercentageCompleted.value = 'No hay tareas para esta semana' : tasksPercentageCompleted.value = '$completedTasksPercent% de tareas completadas';
  }

  /// navegar para crear o editar
  void navigate({int? taskKey, DateTime? date}) {
    if (taskKey != null) {
      Map<String, String> data = {
        "taskId": taskKey.toString(),
      };
      Get.offAllNamed(Routes.FORMS_PAGE, parameters: data);
      return;
    }
    if (date != null) {
      Map<String, String> data = {
        "date": date.toString(),
      };
      Get.offAllNamed(Routes.FORMS_PAGE, parameters: data);
      return;
    }
    Get.offAllNamed(Routes.FORMS_PAGE);
  }
}

// void addItem(List<Task> currentValue, int index, Task task) {
  //   currentValue.insert(index, task);
  //   key.currentState?.insertItem(
  //     index,
  //     duration: const Duration(seconds: 1),
  //   );
  // }

// crear los daos para los widgets
  // void generateWeekDaysList({int? addWeeks}) {
  //   // limpiar lista para evitar duplicados
  //   dataList.clear();
  //   weekDays.clear();
  //   // crear los dias
  //   Week currentWeek = Week.current();

  //   if (addWeeks == null) {
  //     weekDays = currentWeek.days;
  //     //weekDays.add(weekDays.last.add(const Duration(days: 1)));
  //   }
  //   if (addWeeks != null) {
  //     weekDays = currentWeek.addWeeks(addWeeks).days;
  //     //weekDays.add(weekDays.last.add(const Duration(days: 1)));
  //   }

  //   // ordenar las tareas segun los dias
  //   for (var day in weekDays) {
  //     /// agregar el dia
  //     dataList.add(day);
  //     dataList.add('no-tasks-${day.toString()}');

  //     /// agregar la tarea
  //     for (var task in tasksBox.values) {
  //       if (task.dateTime == day) {
  //         dataList.add(task);
  //         dataList.remove('no-tasks-$day');
  //       }
  //     }
  //   }
  //   // print('hola $dataList');
  //   // print('hola ${tasksBox.values}');
  //   buildCoso();
  // }

  // cambiar de lugar una tarea
  // void reorderWhenDragAndDrop(int oldPosition, int newPosition) {
  //   var item = dataList.removeAt(oldPosition); // 'removeAt' returns the item
  //   dataList.insert(newPosition, item); // we insert it in a new position

  //   changeTaskDate(newPosition);
  //   //generateWeekDaysList();
  // }

  // cambiar y persistir la fecha de una tarea cuando se mueve
  // void changeTaskDate(int newPosition) {
  //   // crear una lista con los índices de los dias en la [_widgetsList]
  //   List<int> fechasIdx = [];
  //   for (var element in dataList) {
  //     if (element is DateTime) {
  //       var idx = dataList.indexOf(element);
  //       fechasIdx.add(idx);
  //     }
  //   }
  //   // cuando una tarea cambia de lugar, vemos entre qué
  //   // fechas se posciciona y así poder modificarle la fecha en hive
  //   for (var i = 0; i < fechasIdx.length; i++) {
  //     var indexA = 0;
  //     var indexB = 0;
  //     // asignar dia anterior y posterior (i+1 por que si no da error)
  //     if (i + 1 != fechasIdx.length) {
  //       // para la ultima position
  //       indexA = fechasIdx[i];
  //       indexB = fechasIdx[i + 1];
  //     } else {
  //       // para las demas
  //       indexA = fechasIdx[i - 1];
  //       indexB = fechasIdx[i];
  //     }
  //     // calcular el rango donde cae y cambiar la fecha de la tarea
  //     if (newPosition > indexA && newPosition < indexB) {
  //       Task item = dataList[newPosition];
  //       item.dateTime = dataList[indexA];
  //       item.save();
  //     }
  //   }
  // }

  // void removeTask(int index) {
  //   dataList.removeAt(index);
  // }