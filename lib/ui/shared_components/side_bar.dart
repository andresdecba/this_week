import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todoapp/services/local_notifications_service.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBar extends GetView<InitialPageController> {
  const SideBar({super.key});

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

              /// NAVEGACION
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.home_rounded),
                title: Text('week'.tr),
                subtitle: Text(
                  'go to the current week'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () {
                  controller.addWeeks = 0;
                  controller.buildInfo();
                  controller.scaffoldKey.currentState!.closeEndDrawer();
                },
              ),
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.add_rounded),
                title: Text('new task_sidebar'.tr),
                subtitle: Text(
                  'add a new task for any day'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () {
                  controller.navigate(date: DateTime.now());
                },
              ),
              const Divider(),

              /// CONFIGURACIÓN
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.replay_rounded),
                title: Text('restore app'.tr),
                subtitle: Text(
                  'delete all tasks'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () {
                  myCustomDialog(
                    context: context,
                    title: 'delete tasks'.tr,
                    subtitle: 'this action will delete all...'.tr,
                    iconColor: warning,
                    iconPath: 'assets/warning.svg',
                    okTextButton: 'delete all'.tr,
                    onPressOk: () async => await deleteAndSimulateDataLoading(context),
                  );
                },
              ),
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.language_rounded),
                title: Text('languages'.tr),
                subtitle: Text(
                  'change the current language'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
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
                              value: e,
                              groupValue: controller.currentLang.value,
                              title: Text(controller.langs[i]),
                              onChanged: (ind) {
                                controller.saveLocale(ind!);
                                Navigator.of(context, rootNavigator: true).pop();
                                controller.scaffoldKey.currentState!.closeEndDrawer();
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
              const Divider(),

              /// SOCIAL
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.share_rounded),
                title: Text('share'.tr),
                subtitle: Text(
                  'share this app with your friends'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () {
                  controller.scaffoldKey.currentState!.closeEndDrawer();
                  shareApp(context);
                },
              ),
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.rate_review),
                title: Text('rate'.tr),
                subtitle: Text(
                  'rate us in playstore'.tr,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () {
                  controller.scaffoldKey.currentState!.closeEndDrawer();
                  goToPlaystore(context);
                },
              ),

              // LOGO
              const Divider(),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/weekly-logo.svg',
                    alignment: Alignment.center,
                    color: disabled_grey,
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

  Future<void> deleteAndSimulateDataLoading(BuildContext context) async {
    controller.simulateReloadPage.value = true;
    Navigator.of(context).pop();
    LocalNotificationService.deleteAllNotifications();
    await controller.tasksBox.clear();
    controller.buildInfo();
    Timer(const Duration(seconds: 2), () {
      controller.simulateReloadPage.value = false;
    });
  }

  void shareApp(BuildContext context) {
    String message = '${"hi! check this app out...".tr}\nhttps://play.google.com/store/apps/details?id=com.calculadora.desigual';
    Share.share(message);
  }

  Future<void> goToPlaystore(BuildContext context) async {
    Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.calculadora.desigual');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
