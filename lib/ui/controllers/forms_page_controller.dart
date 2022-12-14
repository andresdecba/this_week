import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';
import 'package:todoapp/ui/widgets/alert_dialog.dart';

class FormsPageController extends GetxController {
  // form ctrl
  final taskTitleCtrlr = TextEditingController();
  final taskDescriptionCtrlr = TextEditingController();
  final subTaskTitleCtrlr = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // get boxes
  final tasksBox = Boxes.getTasksBox();

  // other properties
  bool _isTaskUpdate = false;
  get isTaskUpdate => _isTaskUpdate;

  bool _isSubtaskUpdate = false;
  get isSubtaskUpdate => _isSubtaskUpdate;

  int _subTaskIndex = 0;
  RxBool isEditionEnabled = false.obs;

  RxBool enableAddTaskButton = false.obs;

  final InitialPageController _initialPageController = Get.put(InitialPageController());

  // observable list of subtasks
  final _subTasksTmp = Rx<List<SubTask>>([]);
  Rx<List<SubTask>> get getSubTaskList => _subTasksTmp;

  // load if update
  @override
  void onInit() {
    setInit();
    super.onInit();
  }

  final Rx<DateTime> _time = DateTime.now().obs;
  DateTime get getTime => _time.value;
  set setTime(DateTime value) {
    _time.value = value;
  }

  /// CREATE OR UPDATE TASK ///
  final _task = Task(
    title: '',
    description: '',
    dateTime: DateTime.now(),
    status: TaskStatus.PENDING.toValue,
    subTasks: [],
  ).obs;

  Task get getTask => _task.value;

  void setInit() {
    // update an existing task
    if (Get.parameters['taskId'] != null) {
      _task.value = tasksBox.get(int.parse(Get.parameters['taskId']!))!;
      taskTitleCtrlr.text = _task.value.title;
      taskDescriptionCtrlr.text = _task.value.description;
      _isTaskUpdate = true;
      _task.value.subTasks.forEach((element) {
        _subTasksTmp.value.add(SubTask.copyWith(element));
      });
    }
    // create task on a specific date
    if (Get.parameters['date'] != null) {
      _time.value = DateTime.parse(Get.parameters['date']!);
      isEditionEnabled.value = true;
    }
  }

  /// SUBTASKS ///
  void fillSubTaskTFWhenUpdate(int index) {
    subTaskTitleCtrlr.text = _subTasksTmp.value[index].title;
    _subTaskIndex = index;
    _isSubtaskUpdate = true;
  }

  void createOrUpdateSubTask() {
    if (!_isSubtaskUpdate) {
      _subTasksTmp.update((val) {
        _subTasksTmp.value.add(SubTask(
          title: subTaskTitleCtrlr.text,
          isDone: false,
        ));
      });
    }
    if (_isSubtaskUpdate) {
      _subTasksTmp.update((val) {
        _subTasksTmp.value[_subTaskIndex].title = subTaskTitleCtrlr.text;
        _subTasksTmp.value[_subTaskIndex].isDone = true;
      });
      _isSubtaskUpdate = false;
    }
    subTaskTitleCtrlr.clear();
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
    _task.value.dateTime = DateTime(_time.value.year, _time.value.month, _time.value.day); //get date only, w/o hh:mm:ss;

    if (!_isTaskUpdate) {
      _task.value.subTasks.addAll(_subTasksTmp.value);
      tasksBox.add(_task.value);
    }
    if (_isTaskUpdate) {
      _task.value.subTasks.clear();
      _task.value.subTasks.addAll(_subTasksTmp.value);
      _task.value.save();
    }
  }

  void saveAndNavigate() {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      createOrUpdateTask();
      _initialPageController.buildInfo();
      Get.offAllNamed(Routes.INITIAL_PAGE);
    }
  }

  /// CANCEL ///
  void cancelAndNavigate(BuildContext context) {
    tasksBox.flush();
    _initialPageController.buildInfo();
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  // alert dialog
  Future<bool> onWillPop(BuildContext context) async {
    isEditionEnabled.value == true
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                title: "Salir sin guardar ?",
                content: const Text("Si sale ahora sin guardar perderá los cambios"),
                okCallBack: () => cancelAndNavigate(context),
                isNavigable: true,
              );
            })
        : cancelAndNavigate(context);
    return false;
  }

  @override
  void onClose() {
    taskTitleCtrlr.dispose();
    taskDescriptionCtrlr.dispose();
    subTaskTitleCtrlr.dispose();
    super.onClose();
  }
}
