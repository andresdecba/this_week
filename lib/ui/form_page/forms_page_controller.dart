import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/services/local_notifications_service.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/alert_dialog.dart';
import 'package:todoapp/utils/utils.dart';

enum PageMode { VIEW_MODE, UPDATE_MODE, NEW_MODE }

class FormsPageController extends GetxController {
  //
  @override
  void onInit() {
    setInitialConfig();
    setPageModesHelper();
    enableDisableNotificationStyles();
    super.onInit();
  }

  @override
  void onClose() {
    taskDescriptionCtrlr.dispose();
    subTaskTitleCtrlr.dispose();
    super.onClose();
  }

  ////// manage HIVE //////
  final tasksBox = Boxes.getTasksBox();

  ////// manage INITIAL PAGE ACTIVITY //////
  Task get getTask => _task.value;
  final Rx<Task> _task = Task(
    description: '',
    taskDate: DateTime.now(),
    notificationTime: null,
    status: TaskStatus.PENDING.toValue,
    subTasks: [],
  ).obs;

  void setInitialConfig() {
    // view mode
    if (Get.parameters['taskId'] != null) {
      _task.value = tasksBox.get(int.parse(Get.parameters['taskId']!))!;
      taskDescriptionCtrlr.text = _task.value.description;
      currentPageMode.value = PageMode.VIEW_MODE;
      return;
    }
    // new mode on a specific date
    if (Get.parameters['date'] != null) {
      var arguments = DateTime.parse(Get.parameters['date']!);
      _task.value.taskDate = arguments;
      currentPageMode.value = PageMode.NEW_MODE;
      return;
    }
  }

  ////// manage PAGE MODES ///////
  Rx<PageMode> currentPageMode = PageMode.NEW_MODE.obs;
  RxBool isViewMode = false.obs;
  RxBool isNewMode = false.obs;
  RxBool isUpdateMode = false.obs;

  setPageModesHelper() {
    if (currentPageMode.value == PageMode.VIEW_MODE) {
      isViewMode.value = true;
      isUpdateMode.value = false;
      isNewMode.value = false;
    } else if (currentPageMode.value == PageMode.UPDATE_MODE) {
      isViewMode.value = false;
      isUpdateMode.value = true;
      isNewMode.value = false;
    } else if (currentPageMode.value == PageMode.NEW_MODE) {
      isViewMode.value = false;
      isUpdateMode.value = false;
      isNewMode.value = true;
    }
  }

  ////// manage UPDATE MODE //////

  void floatingActionButtonChangeMode() {
    if (currentPageMode.value == PageMode.VIEW_MODE) {
      currentPageMode.value = PageMode.UPDATE_MODE;
      saveUpdateState();
      setPageModesHelper();
      return;
    }
    if (currentPageMode.value == PageMode.UPDATE_MODE) {
      currentPageMode.value = PageMode.VIEW_MODE;
      restoreUpdateState();
      setPageModesHelper();
      return;
    }
  }

  // save old state
  Map<String, dynamic> oldState = {};
  saveUpdateState() {
    oldState = {
      'task_description': taskDescriptionCtrlr.text,
      'notifyDate': notificationText.value,
      'iconState': enableNotificationIcon.value,
    };
  }

  restoreUpdateState() {
    taskDescriptionCtrlr.text = oldState['task_description'];
    notificationText.value = oldState['notifyDate'];
    enableNotificationIcon.value = oldState['iconState'];
    print('kkkkk $oldState');
  }

  ////// manage TASK FORM //////
  final taskDescriptionCtrlr = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  ////// manage SUBTASKS //////
  final subTaskTitleCtrlr = TextEditingController();

  void createSubtask() {
    _task.update(
      (val) {
        _task.value.subTasks.add(
          SubTask(title: subTaskTitleCtrlr.text, isDone: false),
        );
        subTaskTitleCtrlr.clear();
        //_task.value.save();
      },
    );
  }

  void updateTextSubtask(int index) {
    _task.update(
      (val) {
        _task.value.subTasks[index].title = subTaskTitleCtrlr.text;
        //_task.value.save();
        subTaskTitleCtrlr.clear();
      },
    );
  }

  void updateStatusSubtask(int index) {
    _task.update(
      (val) {
        _task.value.subTasks[index].isDone = !_task.value.subTasks[index].isDone;
        //_task.value.save();
      },
    );
  }

  void deleteSubtask(int index) {
    _task.update((val) {
      _task.value.subTasks.removeAt(index);
      //_task.value.save();
    });
  }

  void onCancelSubtask(BuildContext context) {
    subTaskTitleCtrlr.clear();
    Navigator.of(context).pop();
  }

  ////// manage NOTIFICATIONS //////

  // guardar dia y hora de la notificacion en la tarea
  TimeOfDay notificationTime = TimeOfDay.now();

  void createNotification() {
    if (enableNotificationIcon.value) {
      var data = DateTime(
        _task.value.taskDate.year,
        _task.value.taskDate.month,
        _task.value.taskDate.day,
        notificationTime.hour,
        notificationTime.minute,
      );
      LocalNotificationService.showtNotificationScheduled(
        time: data,
        id: Utils.createNotificationId(),
        body: _task.value.description,
        payload: '/formularios_page',
        fln: localNotifications,
      );
    }
    return;
  }

  void validateNotification(BuildContext context) {
    if (_task.value.notificationTime != null) {
      // if notification is not before now
      var notification = DateTime(
        _task.value.taskDate.year,
        _task.value.taskDate.month,
        _task.value.taskDate.day,
        _task.value.notificationTime!.hour,
        _task.value.notificationTime!.minute,
      );
      if (notification.isBefore(DateTime.now())) {
        showDialog(
          context: context,
          builder: (_) {
            return CustomDialog(
              title: "Warning",
              description: const Text("You can't create a notification before now"),
              okCallBack: () => Navigator.of(context).pop(),
            );
          },
        );
        return;
      }
      // then create it
      createNotification();
    }
  }

  ////// manage NAVIGATION //////
  Future<bool> onWillPop(BuildContext context) async {
    navigate(context);
    return false;
  }

  void navigate(BuildContext context) {
    if (isViewMode.value) {
      Get.offAllNamed(Routes.INITIAL_PAGE);
    }
    if (isNewMode.value) {
      if (hasUserInteraction()) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              title: "Salir sin guardar ?",
              description: const Text("Si sale ahora sin guardar perderá los cambios"),
              okCallBack: () => cancelAndNavigate(),
            );
          },
        );
      } else {
        cancelAndNavigate();
      }
    }
  }

  bool hasUserInteraction() {
    if (_task.value.subTasks.isNotEmpty || taskDescriptionCtrlr.text.isNotEmpty || enableNotificationIcon.value) {
      return true;
    } else {
      return false;
    }
  }

  void cancelAndNavigate() {
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  ////// manage ICON & TEXT NOTIFICATION //////
  RxBool enableNotificationIcon = false.obs;

  Rx<Icon> notificationIcon = const Icon(Icons.notifications_off_rounded).obs;
  Rx<Color> notificationColor = blue_primary.obs;
  Rx<Text> notificationText = const Text('').obs;

  void enableDisableNotificationStyles() {
    const String noDateTxt = 'No notifications';
    final String dateTxt = 'Notify me at ${notificationTime.hour}:${notificationTime.minute} hs.';

    if (isViewMode.value && !enableNotificationIcon.value) {
      notificationColor.value = disabled_grey;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: noDateTxtStyle);
    }
    if (isViewMode.value && enableNotificationIcon.value) {
      notificationColor.value = enabled_grey;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: dateTxtStyle);
    }

    if (isNewMode.value && !enableNotificationIcon.value) {
      notificationColor.value = blue_primary;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: noDateTxtStyle);
    }
    if (isNewMode.value && enableNotificationIcon.value) {
      notificationColor.value = blue_primary;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: newDateTxtStyle);
    }

    if (isUpdateMode.value && !enableNotificationIcon.value) {
      notificationColor.value = blue_primary;
      notificationIcon.value = const Icon(Icons.notifications_off_rounded);
      notificationText.value = Text(noDateTxt, style: noDateTxtStyle);
    }
    if (isUpdateMode.value && enableNotificationIcon.value) {
      notificationColor.value = blue_primary;
      notificationIcon.value = const Icon(Icons.notifications_active_rounded);
      notificationText.value = Text(dateTxt, style: newDateTxtStyle);
    }
  }

  void enableDisableNotification() {
    enableNotificationIcon.value = !enableNotificationIcon.value;
    enableNotificationIcon.value ? _task.value.notificationTime = notificationTime : _task.value.notificationTime = null;
  }

  ////// manage SAVE //////
  final InitialPageController _initialPageController = Get.put(InitialPageController());

  void deleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Eliminar tarea ?",
          okCallBack: () {
            _task.value.delete();
            Get.find<InitialPageController>().buildInfo();
            Get.offAllNamed(Routes.INITIAL_PAGE);
          },
        );
      },
    );
  }

  // void createOrUpdateTask() {
  //   _task.value.description = taskDescriptionCtrlr.text;
  //   tasksBox.add(_task.value);
  //   //_task.value.save();
  // }

  void confirmAndNavigate(BuildContext context) {
    // validate if form is filled
    var isFormValid = formKey.currentState!.validate();

    if (isFormValid) {
      validateNotification(context);

      if (isUpdateMode.value) {
        _task.value.description = taskDescriptionCtrlr.text;
        _task.value.save();
        currentPageMode.value = PageMode.VIEW_MODE;
        setPageModesHelper();
      }
      if (isNewMode.value) {
        _task.value.description = taskDescriptionCtrlr.text;
        tasksBox.add(_task.value);
        _initialPageController.buildInfo();
        Get.offAllNamed(Routes.INITIAL_PAGE);
      }
    }
  }
}
