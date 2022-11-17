import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';

class FormsPageController extends GetxController {
  // load if update
  @override
  void onInit() {
    setInit();
    super.onInit();
  }

  // form key
  final taskFormKey = GlobalKey<FormBuilderState>();
  final subTaskFormKey = GlobalKey<FormBuilderState>();

  // form ctrl
  final taskTitleCtrlr = TextEditingController();
  final taskDescriptionCtrlr = TextEditingController();
  final subTaskTitleCtrlr = TextEditingController();
  final subTaskDescriptionCtrlr = TextEditingController();

  // get boxes
  final tasksBox = Boxes.getTasksBox();

  // other properties
  bool _isUpdate = false;
  bool _isSubtaskUpdate = false;
  int _subTaskIndex = 0;

  // observable list of subtasks
  final _subTasksTmp = Rx<List<SubTask>>([]);
  Rx<List<SubTask>> get getSubTaskList => _subTasksTmp;

  // time
  DateTime _time = DateTime.now();
  DateTime get getTime => _time;
  set setTime(DateTime value) {
    _time = value;
  }

  // status
  String _status = '';
  set setStatus(int value) {
    switch (value) {
      case 0:
        _status = 'PENDING';
        break;
      case 1:
        _status = 'IN PROGRESS';
        break;
      case 2:
        _status = 'DONE';
        break;
      default:
        _status = 'PENDING';
    }
  }

  /// CREATE OR UPDATE TASK ///
  final _task = Task(
    title: '',
    description: '',
    dateTime: DateTime.now(),
    status: 'PENDING',
    subTasks: [],
  ).obs;

  void setInit() {
    if (Get.parameters['taskId'] != null) {
      _task.value = tasksBox.get(int.parse(Get.parameters['taskId']!))!;
      taskTitleCtrlr.text = _task.value.title;
      taskDescriptionCtrlr.text = _task.value.description;
      _isUpdate = true;
      _task.value.subTasks.forEach((element) {
        _subTasksTmp.value.add(SubTask.copyWith(element));
      });
    }
  }

  /// SUBTASKS ///
  void fillSubTaskTFWhenUpdate(int index) {
    subTaskTitleCtrlr.text = _subTasksTmp.value[index].title;
    subTaskDescriptionCtrlr.text = _subTasksTmp.value[index].description;
    _subTaskIndex = index;
    _isSubtaskUpdate = true;
  }

  void createOrUpdateSubTask() {
    if (!_isSubtaskUpdate) {
      _subTasksTmp.update((val) {
        _subTasksTmp.value.add(SubTask(
          title: subTaskTitleCtrlr.text,
          description: subTaskDescriptionCtrlr.text,
          isDone: false,
          index: 1,
        ));
      });
    }
    if (_isSubtaskUpdate) {
      _subTasksTmp.update((val) {
        _subTasksTmp.value[_subTaskIndex].title = subTaskTitleCtrlr.text;
        _subTasksTmp.value[_subTaskIndex].description = subTaskDescriptionCtrlr.text;
        _subTasksTmp.value[_subTaskIndex].isDone = true;
      });
      _isSubtaskUpdate = false;
    }
    subTaskTitleCtrlr.clear();
    subTaskDescriptionCtrlr.clear();
  }

  void deleteSubtask(int index) {
    _subTasksTmp.update((val) {
      _subTasksTmp.value.removeAt(index);
    });
  }

  /// SAVE ///
  void createOrUpdateTask() {
    _task.value.title = taskTitleCtrlr.text;
    _task.value.description = taskDescriptionCtrlr.text;
    _task.value.dateTime = _time;
    _task.value.status = _status;

    if (!_isUpdate) {
      _task.value.subTasks.addAll(_subTasksTmp.value);
      tasksBox.add(_task.value);
    }
    if (_isUpdate) {
      _task.value.subTasks.clear();
      _task.value.subTasks.addAll(_subTasksTmp.value);
      _task.value.save();
    }
  }

  void saveAndNavigate() {
    createOrUpdateTask();
    //int idFromFirstController = Get.find<InitialPageController>().updateDataList()
    //Get.offAllNamed(Routes.INITIAL_PAGE);
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  /// CANCEL ///
  void cancelAndNavigate(BuildContext context) {
    tasksBox.flush();
    //Get.offAllNamed(Routes.INITIAL_PAGE);
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  // alert dialog
  Future<bool> onWillPop(BuildContext context) async {
    showAlertDialog(context);
    return false;
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No guardar"),
      onPressed: () => cancelAndNavigate(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Guardar cambios"),
      onPressed: () => saveAndNavigate(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Salir sin guardar ?"),
      content: const Text("Si sale ahora sin guardar perderá los cambios"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
