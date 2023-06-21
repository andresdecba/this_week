import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:todoapp/use_cases/local_notifications_use_cases.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBar extends GetView<InitialPageController> {
  SideBar({super.key});

  final LocalNotificationsUseCases _localNotificationsUseCases = LocalNotificationsUseCases();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              const Divider(),

              ///  HOME  ///
              // ListTile(
              //   visualDensity: VisualDensity.compact,
              //   trailing: const Icon(Icons.home_rounded),
              //   title: Text('home'.tr),
              //   subtitle: Text(
              //     'go to the current week'.tr,
              //     style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: disabledGrey),
              //   ),
              //   onTap: () {
              //     Get.find<InitialPageController>().returnToCurrentWeek();
              //     Globals.myScaffoldKey.currentState!.closeEndDrawer();
              //   },
              // ),

              ///  NUEVA TAREA  ///
              // ListTile(
              //   visualDensity: VisualDensity.compact,
              //   trailing: const Icon(Icons.add_rounded),
              //   title: Text('new task_sidebar'.tr),
              //   subtitle: Text(
              //     'new task for any day'.tr,
              //     style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: disabledGrey),
              //   ),
              //   onTap: () {
              //     Globals.myScaffoldKey.currentState!.closeEndDrawer();
              //     var date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              //     Get.put(CreateTaskPageController(selectedDate: date));
              //     myModalBottomSheet(
              //       context: context,
              //       child: const CreateTaskPage(),
              //       enableDrag: true,
              //     );
              //   },
              // ),
              // const Divider(color: disabledGrey),

              ///  REESTABLECER APP  ///
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.replay_rounded),
                title: Text('restore app'.tr),
                subtitle: Text(
                  'delete all tasks'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: disabledGrey),
                ),
                onTap: () {
                  myCustomDialog(
                    context: context,
                    title: 'delete tasks'.tr,
                    subtitle: 'this action will delete all...'.tr,
                    iconColor: warning,
                    iconPath: 'assets/warning.svg',
                    okTextButton: 'delete all'.tr,
                    onPressOk: () async => await deleteAll(context),
                  );
                },
              ),

              ///  CAMBIAR IDIOMA  ///
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.language_rounded),
                title: Text('languages'.tr),
                subtitle: Text(
                  'change the current language'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: disabledGrey),
                ),
                onTap: () async {
                  await changeLangDialog(
                    context: context,
                    title: 'choose a language'.tr,
                    elements: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...controller.langsCodes.map((e) {
                            var i = controller.langsCodes.indexOf(e);
                            return RadioListTile(
                              value: e.languageCode,
                              groupValue: controller.currentLang.value.languageCode,
                              title: Text(controller.langs[i]),

                              onChanged: (index) {
                                controller.saveLocale(index!);
                                Navigator.of(context, rootNavigator: true).pop();
                                // alerta reinicio
                                myCustomDialog(
                                  context: context,
                                  title: 'you will need to restart the app...'.tr,
                                  iconPath: 'assets/warning.svg',
                                  onPressOk: () {
                                    Globals.myScaffoldKey.currentState!.closeEndDrawer();
                                  },
                                );
                              },
                              //toggleable: true,
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),

              /// COMPARTIR APP ///
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.share_rounded),
                title: Text('share'.tr),
                subtitle: Text(
                  'share this app with your friends'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: disabledGrey),
                ),
                onTap: () {
                  Globals.myScaffoldKey.currentState!.closeEndDrawer();
                  shareApp(context);
                },
              ),

              /// CALIFICAR APP ///
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.rate_review),
                title: Text('rate'.tr),
                subtitle: Text(
                  'rate us in playstore'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: disabledGrey),
                ),
                onTap: () {
                  Globals.myScaffoldKey.currentState!.closeEndDrawer();
                  goToPlaystore(context);
                },
              ),

              /// LOGO ///
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset(
                    'assets/appbar_logo.svg',
                    alignment: Alignment.center,
                    color: disabledGrey,
                    width: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteAll(BuildContext context) async {
    Navigator.of(context).pop();
    Globals.myScaffoldKey.currentState!.closeEndDrawer();
    controller.simulateDeletingData();
    _localNotificationsUseCases.deleteAllNotifications();
    await controller.tasksBox.clear();
  }

  void shareApp(BuildContext context) {
    String message = '${"hi! check this app out...".tr}\nhttps://play.google.com/store/apps/details?id=site.thisweek';
    Share.share(message);
  }

  Future<void> goToPlaystore(BuildContext context) async {
    Uri url = Uri.parse('https://play.google.com/store/apps/details?id=site.thisweek');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
