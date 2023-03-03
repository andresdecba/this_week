// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:isoweek/isoweek.dart';
// import 'package:todoapp/core/routes/routes.dart';
// import 'package:todoapp/data_source/db_data_source.dart';
// import 'package:todoapp/models/task_model.dart';

// class InitialPageController extends GetxController {
//   // box de tasks
//   Box<Task> tasksBox = Boxes.getTasksBox();
//   List<Task> get getTasks => tasksBox.values.toList();

//   // check for initial data
//   RxBool hasData = false.obs;

//   // lista con los datos para generar los widgets en la UI
//   final RxList dataList = [].obs;

//   int moveToWeek = 0;

//   List<DateTime> weekDays = [];

//   // cambiar de lugar una tarea
//   void reorderWhenDragAndDrop(int oldPosition, int newPosition) {
//     var item = dataList.removeAt(oldPosition); // 'removeAt' returns the item
//     dataList.insert(newPosition, item); // we insert it in a new position

//     changeTaskDate(newPosition);
//     generateWeekDaysList();
//   }

//   // cambiar y persistir la fecha de una tarea cuando se mueve
//   void changeTaskDate(int newPosition) {
//     // crear una lista con los índices de los dias en la [_widgetsList]
//     List<int> fechasIdx = [];
//     for (var element in dataList) {
//       if (element is DateTime) {
//         var idx = dataList.indexOf(element);
//         fechasIdx.add(idx);
//       }
//     }
//     // cuando una tarea cambia de lugar, vemos entre qué
//     // fechas se posciciona y así poder modificarle la fecha en hive
//     for (var i = 0; i < fechasIdx.length; i++) {
//       var indexA = 0;
//       var indexB = 0;
//       // asignar dia anterior y posterior (i+1 por que si no da error)
//       if (i + 1 != fechasIdx.length) {
//         // para la ultima position
//         indexA = fechasIdx[i];
//         indexB = fechasIdx[i + 1];
//       } else {
//         // para las demas
//         indexA = fechasIdx[i - 1];
//         indexB = fechasIdx[i];
//       }
//       // calcular el rango donde cae y cambiar la fecha de la tarea
//       if (newPosition > indexA && newPosition < indexB) {
//         Task item = dataList[newPosition];
//         item.dateTime = dataList[indexA];
//         item.save();
//       }
//     }
//   }

//   // crear los daos para los widgets
//   void generateWeekDaysList({int? addWeeks}) {
//     // limpiar lista para evitar duplicados
//     dataList.clear();
//     // crear los dias
//     Week currentWeek = Week.current();

//     if (addWeeks == null) {
//       weekDays = currentWeek.days;
//       weekDays.add(weekDays.last.add(const Duration(days: 1)));
//     }
//     if (addWeeks != null) {
//       weekDays = currentWeek.addWeeks(addWeeks).days;
//       weekDays.add(weekDays.last.add(const Duration(days: 1)));
//     }

//     // ordenar las tareas segun los dias
//     for (var day in weekDays) {
//       /// agregar el dia
//       dataList.add(day);
//       dataList.add('no-tasks-${day.toString()}');

//       /// agregar la tarea
//       for (var task in tasksBox.values) {
//         if (task.dateTime == day) {
//           dataList.add(task);
//           dataList.remove('no-tasks-$day');
//         }
//       }
//     }
//     print('hola $dataList');
//     print('hola ${tasksBox.values}');
//   }

//   void removeTask(int index) {
//     dataList.removeAt(index);
//   }

//   /// navegar para crear o editar
//   void navigate({int? taskKey}) {
//     if (taskKey != null) {
//       Map<String, String> data = {
//         "taskId": taskKey.toString(),
//       };
//       Get.offAllNamed(Routes.FORMS_PAGE, parameters: data);
//       //Get.delete<InitialPageController>();
//       return;
//     }
//     Get.offAllNamed(Routes.FORMS_PAGE);
//     //_widgetsList.clear();
//   }
// }
