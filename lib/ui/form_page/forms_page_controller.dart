import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/services/local_notifications_service.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:todoapp/ui/shared_components/snackbar.dart';
import 'package:todoapp/utils/utils.dart';

enum PageMode { VIEW_MODE, UPDATE_MODE, NEW_MODE }

class FormsPageController extends GetxController {
  //
  @override
  void onInit() {
    setInitialConfig();
    setPageModesHelper();
    enableDisableNotificationStyles();
    hasUserInteractionInit();
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

  RxBool hasUserInteraction = false.obs;

  void hasUserInteractionInit() {
    hasUserInteraction.value = taskDescriptionCtrlr.text.length >= 7 ? true : false;
  }

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

  ////// manage NAVIGATION //////
  Future<bool> onWillPop(BuildContext context) async {
    if (isNewMode.value) {
      cancelAndNavigate(context);
      return true;
    } else if (isViewMode.value) {
      cancelAndNavigate(context);
      return true;
    } else {
      return false;
    }
  }

  void cancelAndNavigate(BuildContext context) {
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  ////// manage ICON & TEXT NOTIFICATION //////

  TimeOfDay notificationTime = TimeOfDay.now();
  RxBool enableNotificationIcon = false.obs;

  Rx<Icon> notificationIcon = const Icon(Icons.notifications_off_rounded).obs;
  Rx<Color> notificationColor = blue_primary.obs;
  Rx<Text> notificationText = const Text('').obs;

  void enableDisableNotificationStyles() {
    if (isViewMode.value && _task.value.notificationTime != null) {
      enableNotificationIcon.value = true;
      notificationTime = TimeOfDay(hour: _task.value.notificationTime!.hour, minute: _task.value.notificationTime!.minute);
    }

    String noDateTxt = 'schedule a notification'.tr;
    final String dateTxt = '${'notify me at:'.tr} ${notificationTime.hour}:${notificationTime.minute} hs.';

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

  void saveNotification() {
    enableNotificationIcon.value
        ? _task.value.notificationTime = DateTime(
            _task.value.taskDate.year,
            _task.value.taskDate.month,
            _task.value.taskDate.day,
            notificationTime.hour,
            notificationTime.minute,
          )
        : _task.value.notificationTime = null;

    // print('from bool ${enableNotificationIcon.value}');
    // print('from task ${_task.value.notificationTime}');
    // print('from var $notificationTime');
  }

  ////// manage SAVE //////
  final InitialPageController _initialPageController = Get.put(InitialPageController());

  void deleteTask(BuildContext context) {
    myCustomDialog(
      context: context,
      title: 'delete task ?'.tr,
      subtitle: 'this action will delete...'.tr,
      cancelTextButton: 'cancel'.tr,
      okTextButton: 'delete'.tr,
      iconPath: 'assets/warning.svg',
      iconColor: warning,
      onPressOk: () {
        String tmp = _task.value.description;
        _task.value.delete();
        Get.find<InitialPageController>().buildInfo();
        Get.offAllNamed(Routes.INITIAL_PAGE);
        showSnackBar(
          titleText: 'task deleted'.tr,
          messageText: tmp,
        );
      },
    );
  }

  void saveOrUpdateTask(BuildContext context) {
    var isFormValid = formKey.currentState!.validate();
    if (isFormValid) {
      _task.value.notificationTime != null ? validateNotification(context) : confirmAndNavigate();
    }
  }

  void validateNotification(BuildContext context) {
    if (_task.value.notificationTime!.isBefore(DateTime.now())) {
      myCustomDialog(
        context: context,
        title: 'atention !'.tr,
        subtitle: 'You cant create a...'.tr,
        okTextButton: 'ok'.tr,
        iconPath: 'assets/info.svg',
        iconColor: blue_primary,
        onPressOk: () => Navigator.of(context).pop(),
      );
    } else {
      confirmAndNavigate();
    }
  }

  void confirmAndNavigate() async {
    if (isUpdateMode.value) {
      _task.value.description = taskDescriptionCtrlr.text;
      createNotification();
      _task.value.save();
      currentPageMode.value = PageMode.VIEW_MODE;
      setPageModesHelper();
      enableDisableNotificationStyles();
      showSnackBar(
        titleText: 'task updated'.tr,
        messageText: _task.value.description,
      );
    }
    if (isNewMode.value) {
      _task.value.description = taskDescriptionCtrlr.text;
      createNotification();
      tasksBox.add(_task.value);
      _initialPageController.buildInfo();
      Get.offAllNamed(Routes.INITIAL_PAGE);
      showSnackBar(
        titleText: 'new task created'.tr,
        messageText: _task.value.description,
      );
    }
  }
}

/*
hay notif programada:
    si: validar
        es anterior: mostrar modal
        es posterior: guardar
    no: guardar
*/