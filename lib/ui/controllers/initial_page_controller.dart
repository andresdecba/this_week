import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:intl/intl.dart' as dateFormat;

class InitialPageController extends GetxController {
  // box de tasks
  Box<Task> tasksBox = Boxes.getTasksBox();
  List<Task> get getTasks => tasksBox.values.toList();

  // check for initial data
  RxBool hasData = false.obs;

  // box de la lista de datos para mostrar en la ui
  Box<List> dataListBox = Boxes.getDataListBox();

  @override
  void onInit() {
    // create or assign [dataList]
    if (dataListBox.get('listaDatos') == null) {
      dataListBox.put('listaDatos', []);
    }
    // validate if exists previous data
    if (dataListBox.get('listaDatos')!.isNotEmpty) {
      hasData.value = true;
    }
    super.onInit();
  }

  /////// AL CAMBIAR DE LUGAR UNA TAREA ordenar y reasignar ///////
  void reorderWhenDragAndDrop(int oldPosition, int newPosition) {
    var item = dataListBox.get('listaDatos')!.removeAt(oldPosition); // 'removeAt' returns the item
    dataListBox.get('listaDatos')!.insert(newPosition, item); // we insert it in a new position

    changeTaskDate(newPosition);
    //updateTasksList();
  }

  // flutter pub run change_app_package_name:main com.weekly-tasks

  void changeTaskDate(int newPosition) {
    // crear una lista con los índices de los dias en la [_widgetsList]
    List<int> fechasIdx = [];
    for (var element in dataListBox.get('listaDatos')!) {
      if (element is String) {
        var idx = dataListBox.get('listaDatos')!.indexOf(element);
        fechasIdx.add(idx);
      }
    }

    // cuando una tarea cambia de lugar, vemos entre qué
    // fechas se posciciona y así poder modificarle la fecha en hive
    for (var i = 0; i < fechasIdx.length; i++) {
      var indexA = 0;
      var indexB = 0;
      // asignar dia anterior y posterior (i+1 por que si no da error)
      if (i + 1 != fechasIdx.length) {
        // para la ultima position
        indexA = fechasIdx[i];
        indexB = fechasIdx[i + 1];
      } else {
        // para las demas
        indexA = fechasIdx[i - 1];
        indexB = fechasIdx[i];
      }
      // calcular el rango donde cae y cambiar la fecha de la tarea
      if (newPosition > indexA && newPosition < indexB) {
        Task item = dataListBox.get('listaDatos')![newPosition];
        item.dateTime = dataListBox.get('listaDatos')![indexA];
        item.save();
      }
    }
  }

  List dias = [];
  List dataList = [];

  /////// editar la lista de datos ya existente ///////
  void updateTasksList() {
    // separar todos los dias
    dias.clear();
    for (var element in tasksBox.values) {
      if (!dias.contains(element.dateTime)) {
        dias.add(element.dateTime);
      }
    }
    // sort days
    dias.sort((a, b) => a.compareTo(b));
    // add a last day
    DateTime lastDay = DateTime.parse(dias.last).add(const Duration(days: 1));
    String parsedDate = dateFormat.DateFormat('yyyy-MM-dd').format(lastDay);
    dias.add(parsedDate);

    // odernar las tareas por fecha
    dataList.clear();
    for (var day in dias) {
      dataList.add(day);
      for (var task in getTasks) {
        if (task.dateTime == day) {
          dataList.add(task);
        }
      }
    }
    // persist data list
    dataListBox.put('listaDatos', dataList);
    print(dataListBox.get('listaDatos'));
    print(getTasks);
  }

  /// navegar para crear o editar
  void navigate({int? taskKey}) {
    if (taskKey != null) {
      Map<String, String> data = {
        "taskId": taskKey.toString(),
      };
      Get.offAllNamed(Routes.FORMS_PAGE, parameters: data);
      //Get.delete<InitialPageController>();
      return;
    }
    Get.offAllNamed(Routes.FORMS_PAGE);
    //_widgetsList.clear();
  }
}
