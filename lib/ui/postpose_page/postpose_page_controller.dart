import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/data_source/db_data_source.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/services/ad_mob_service.dart';
import 'package:todoapp/services/local_notifications_service.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:todoapp/ui/shared_components/snackbar.dart';
import 'package:todoapp/utils/helpers.dart';

enum PostposeEnum { fifteenMinutes, oneHour, threeHours, oneDay, personalized }

class PostPosePageController extends GetxController {
  @override
  void onInit() {
    getCurrentTask();
    super.onInit();
  }

  //// manage HIVE //////
  final tasksBox = Boxes.getTasksBox();
  late Task task;

  void getCurrentTask() {
    // argumentos desde la notificacion
    if (notificationPayload != null) {
      task = tasksBox.get(int.parse(notificationPayload!['taskId']!))!;
      return;
    }
    // argumentos desde la pagina de inicio al abrir una tarea existnte
    if (Get.arguments['taskId'] != null) {
      task = tasksBox.get(int.parse(Get.arguments['taskId']!))!;
      return;
    }
  }

  //// manage SELECT ITEM /////
  Rx<PostposeEnum> selectedItem = PostposeEnum.fifteenMinutes.obs;

  String setTitle(PostposeEnum data) {
    switch (data) {
      case PostposeEnum.fifteenMinutes:
        return '15 minutes'.tr;
      case PostposeEnum.oneHour:
        return '1 hour'.tr;
      case PostposeEnum.threeHours:
        return '3 hours'.tr;
      case PostposeEnum.oneDay:
        return '1 day'.tr;
      case PostposeEnum.personalized:
        return 'personalized'.tr;
      default:
        return '15 minutes'.tr;
    }
  }

  String setSubTitle(PostposeEnum data) {
    final DateTime tmp1 = task.notificationTime!;
    final DateTime tmp2 = task.notificationTime!;
    final DateTime tmp3 = task.notificationTime!;
    final DateTime tmp4 = task.notificationTime!;
    switch (data) {
      case PostposeEnum.fifteenMinutes:
        return '${'today'.tr}, ${'at'.tr} ${timeFormater(tmp1.add(const Duration(minutes: 15)))}';
      case PostposeEnum.oneHour:
        return '${'today'.tr}, ${'at'.tr} ${timeFormater(tmp2.add(const Duration(hours: 1)))}';
      case PostposeEnum.threeHours:
        return '${'today'.tr}, ${'at'.tr} ${timeFormater(tmp3.add(const Duration(hours: 3)))}';
      case PostposeEnum.oneDay:
        return '${'tomorrow'.tr}, ${'at'.tr} ${timeFormater(tmp4.add(const Duration(days: 1)))}';
      case PostposeEnum.personalized:
        if (personalizedNotificationDateTime.value != null && personalizedTaskDate != null) {
          return '${longDateFormaterWithoutYear(personalizedNotificationDateTime.value!)}, ${'at'.tr} ${timeFormater(personalizedNotificationDateTime.value!)}';
        } else {
          return 'select...'.tr;
        }
      default:
        return '...';
    }
  }

  bool isSelected(PostposeEnum data) {
    return data == selectedItem.value;
  }

  void onChanged(PostposeEnum value, BuildContext context) async {
    selectedItem.value = value;
    if (value == PostposeEnum.personalized) {
      await datePicker();
    }
  }

  ///// manage SAVE /////
  final InitialPageController _initialPageController = Get.put(InitialPageController());

  void savePostpose(PostposeEnum data) {
    switch (data) {
      case PostposeEnum.fifteenMinutes:
        task.notificationTime = task.notificationTime!.add(const Duration(minutes: 15));
        break;
      case PostposeEnum.oneHour:
        task.notificationTime = task.notificationTime!.add(const Duration(hours: 1));
        break;
      case PostposeEnum.threeHours:
        task.notificationTime = task.notificationTime!.add(const Duration(hours: 3));
        break;
      case PostposeEnum.oneDay:
        task.taskDate = task.taskDate.add(const Duration(days: 1));
        task.notificationTime = task.notificationTime!.add(const Duration(days: 1));
        break;
      case PostposeEnum.personalized:
        if (personalizedNotificationDateTime.value != null && personalizedTaskDate != null) {
          task.taskDate = personalizedTaskDate!;
          task.notificationTime = personalizedNotificationDateTime.value;
          break;
        } else {
          myCustomDialog(
            context: Get.context!,
            title: 'select date and time'.tr,
            onPressOk: () => Get.back(),
          );
          return;
        }
    }
    saveAndNavigate();
  }

  void saveAndNavigate() {
    task.notificationId = createNotificationId();
    _createNotificationREFACTORIZED(task);
    task.save();
    _initialPageController.buildInfo();
    Get.offAllNamed(Routes.INITIAL_PAGE);
    showSnackBar(
      titleText: 'postponed task title'.tr,
      messageText: '${'postponed task description'.tr} ${longDateFormaterWithoutYear(task.taskDate)}, ${'at'.tr} ${timeFormater(task.notificationTime!)}',
    );
  }

  Future<void> _createNotificationREFACTORIZED(Task task) async {
    await LocalNotificationService.createNotificationScheduled(
      time: task.notificationTime!,
      id: task.notificationId!,
      body: task.description,
      payload: task.key.toString(),
      fln: localNotifications,
    );
  }

  ///// manage CANCEL AND NAVIGATE /////
  void cancelPostpose() {
    Map<String, String> data = {
      "taskId": task.key.toString(),
    };
    Get.offAllNamed(Routes.FORMS_PAGE, arguments: data);
  }

  ///// manage PERSONALIZED DATE AND TIME /////
  DateTime? personalizedTaskDate;
  Rxn<DateTime> personalizedNotificationDateTime = Rxn<DateTime>();

  Future<void> datePicker() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: task.taskDate,
      firstDate: task.taskDate,
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      personalizedTaskDate = picked;
      await timePicker();
    } else {
      print('picking cancelled');
    }
  }

  Future<void> timePicker() async {
    //FocusScope.of(context).unfocus(); // hide keyboard if open
    TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().add(const Duration(minutes: 5)).minute),
    );
    if (picked != null) {
      personalizedNotificationDateTime.value = DateTime(
        personalizedTaskDate!.year, // año
        personalizedTaskDate!.month, // mes
        personalizedTaskDate!.day, // dia
        picked.hour, // hora
        picked.minute, // minuto
      );
    } else {
      print('picking cancelled');
    }
  }

  ///// manage TASK CARD /////
  void navigateCard() {
    Map<String, String> data = {
      "taskId": task.key.toString(),
    };
    Get.toNamed(Routes.FORMS_PAGE, arguments: data);
  }

  void changeTaskStatus(Task task) {
    switch (task.status) {
      case 'Pending':
        task.status = TaskStatus.IN_PROGRESS.toValue;
        task.save();
        break;
      case 'In progress':
        task.status = TaskStatus.DONE.toValue;
        task.save();
        break;
      case 'Done':
        task.status = TaskStatus.PENDING.toValue;
        task.save();
        break;
    }
  }

  ////// manage GOOGLE ADS //////

  late BannerAd bannerAd;
  RxBool isAdLoaded = false.obs;

  @override
  void onReady() {
    initSmartBannerAd();
    super.onReady();
  }

  void initSmartBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(Get.context!).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    bannerAd = BannerAd(
      adUnitId: AdMobService.testBanner!,
      //adUnitId: AdMobService.postposePageBanner!,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isAdLoaded.value = true;
          print('INITIAL page banner: responseId = ${ad.responseInfo!.responseId} / adId = ${ad.adUnitId}');
        },
        onAdFailedToLoad: (ad, error) {
          isAdLoaded.value = true;
          ad.dispose();
          print('**banner_1 error** $error');
        },
      ),
    );
    bannerAd.load();
  }
}
