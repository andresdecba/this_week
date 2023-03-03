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
    changeNotificationIconAndText();
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
    dateTime: DateTime.now(),
    notificationDateTime: DateTime.now(),
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
      _task.value.dateTime = DateTime.parse(Get.parameters['date']!);
      tasksBox.add(_task.value);
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

  void floatingActionButtonChangeMode() {
    if (currentPageMode.value == PageMode.VIEW_MODE) {
      currentPageMode.value = PageMode.UPDATE_MODE;
      setPageModesHelper();
      return;
    }
    if (currentPageMode.value == PageMode.UPDATE_MODE) {
      currentPageMode.value = PageMode.VIEW_MODE;
      setPageModesHelper();
      return;
    }
  }

  ////// manage TASK FORM //////
  final taskDescriptionCtrlr = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ////// manage SUBTASKS //////
  final subTaskTitleCtrlr = TextEditingController();

  void createSubtask() {
    _task.update(
      (val) {
        _task.value.subTasks.add(
          SubTask(title: subTaskTitleCtrlr.text, isDone: false),
        );
        subTaskTitleCtrlr.clear();
        _task.value.save();
      },
    );
  }

  void updateTextSubtask(int index) {
    _task.update(
      (val) {
        _task.value.subTasks[index].title = subTaskTitleCtrlr.text;
        _task.value.save();
        subTaskTitleCtrlr.clear();
      },
    );
  }

  void updateStatusSubtask(int index) {
    _task.update(
      (val) {
        _task.value.subTasks[index].isDone = !_task.value.subTasks[index].isDone;
        _task.value.save();
      },
    );
  }

  void deleteSubtask(int index) {
    _task.update((val) {
      _task.value.subTasks.removeAt(index);
      _task.value.save();
    });
  }

  void onCancelSubtask(BuildContext context) {
    subTaskTitleCtrlr.clear();
    Navigator.of(context).pop();
  }

  ////// manage NOTIFICATIONS //////

  // guardar dia y hora de la notificacion en la tarea
  void setNotificationTime(TimeOfDay value) {
    _task.value.notificationDateTime = DateTime(
      _task.value.dateTime.year,
      _task.value.dateTime.month,
      _task.value.dateTime.day,
      value.hour,
      value.minute,
    );
    _task.value.save();
  }

  void createNotification() {
    if (enableNotificationIcon.value) {
      LocalNotificationService.showtNotificationScheduled(
        time: _task.value.notificationDateTime!,
        id: Utils.createNotificationId(),
        // title: _task.value.title,
        body: _task.value.description,
        payload: '/formularios_page',
        fln: localNotifications,
      );
    }
    return;
  }

  ////// manage TASK //////
  void createOrUpdateTask() {
    _task.value.description = taskDescriptionCtrlr.text;
    _task.value.save();
  }

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
          isNavigable: true,
        );
      },
    );
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Salir sin guardar ?",
            content: const Text("Si sale ahora sin guardar perderá los cambios"),
            okCallBack: () => cancelAndNavigate(),
            isNavigable: true,
          );
        },
      );
    }
  }

  void cancelAndNavigate() {
    _task.value.delete();
    Get.offAllNamed(Routes.INITIAL_PAGE);
  }

  ////// manage NOTIFY ICON & TEXT //////
  RxBool enableNotificationIcon = false.obs;

  Rx<Icon> notificationIcon = const Icon(Icons.notifications_off_rounded).obs;
  Rx<Color> notificationColor = blue_primary.obs;
  Rx<Text> notificationText = const Text('').obs;

  void changeNotificationIconAndText() {
    print('--- init ${enableNotificationIcon.value} ---');

    const String noDateTxt = 'No notifications';
    final String dateTxt = 'Notify me at ${getTask.notificationDateTime!.hour}:${getTask.notificationDateTime!.minute} hs.';

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

    enableNotificationIcon.value = !enableNotificationIcon.value;
    print('--- end ${enableNotificationIcon.value} ---');
  }

  ////// manage SAVE //////
  final InitialPageController _initialPageController = Get.put(InitialPageController());

  void confirmAndNavigate() {
    final FormState form = formKey.currentState!;
    var now = DateTime.now();
    var notification = _task.value.notificationDateTime;

    if (notification != null) {
      if (notification.isBefore(now)) {
        print('### no se puede before now ###'); //TODO probar esto
        return;
      }
    }

    if (form.validate()) {
      createNotification();

      if (isUpdateMode.value) {
        createOrUpdateTask();
        currentPageMode.value = PageMode.VIEW_MODE;
        setPageModesHelper();
      }

      if (isNewMode.value) {
        createOrUpdateTask();
        _initialPageController.buildInfo();
        Get.offAllNamed(Routes.INITIAL_PAGE);
      }
    }
  }
}

/*
extension PageStateExtension on PageMode {
  String get toValue {
    switch (this) {
      case PageMode.VIEW_TASK:
        return 'Pending';
      case PageMode.UPDATE_TASK:
        return 'In progress';
      case PageMode.NEW_TASK:
        return 'Done';
    }
  }
}

*/
