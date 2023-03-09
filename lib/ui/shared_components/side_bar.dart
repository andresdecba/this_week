import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
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
                title: Text(
                  'week'.tr,
                  style: TextStyle(),
                ),
                subtitle: const Text(
                  'Go to current week',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () {
                  controller.addWeeks = 0;
                  controller.buildInfo();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.add_rounded),
                title: const Text('New task'),
                subtitle: const Text(
                  'Add a new Task for any day',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
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
                title: const Text('Reset App'),
                subtitle: const Text(
                  'Borrará todas las tareas',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () {
                  myCustomDialog(
                    context: context,
                    title: 'Delete Tasks',
                    subtitle: 'This action will delete all tasks from the app.',
                    iconColor: warning,
                    iconPath: 'assets/warning.svg',
                    okTextButton: 'Delete tasks',
                    onPressOk: () async => await simulateDataLoading(context),
                  );
                },
              ),
              ListTile(
                  visualDensity: VisualDensity.compact,
                  trailing: const Icon(Icons.language_rounded),
                  title: const Text('Languajes'),
                  subtitle: const Text(
                    'Change current languaje',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    myCustomDialog(
                      context: context,
                      title: 'Title',
                      onPressOk: () {},
                    );
                  }),
              const Divider(),

              /// SOCIAL
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.share_rounded),
                title: const Text('Share'),
                subtitle: const Text(
                  'Share with your friends',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () => shareApp(context),
              ),
              ListTile(
                visualDensity: VisualDensity.compact,
                trailing: const Icon(Icons.rate_review),
                title: const Text('Rate'),
                subtitle: const Text(
                  'Rate in PlayStore',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: bsubTitleTextColor),
                ),
                onTap: () => goToPlaystore(context),
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

  Future<void> simulateDataLoading(BuildContext context) async {
    controller.simulateReloadPage.value = true;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    await controller.tasksBox.clear();
    controller.buildInfo();
    Timer(const Duration(seconds: 2), () {
      controller.simulateReloadPage.value = false;
    });
  }

  void shareApp(BuildContext context) {
    String message = 'Hi ! check this app out: https://play.google.com/store/apps/details?id=com.calculadora.desigual';
    Share.share(message);
    Navigator.of(context).pop();
  }

  Future<void> goToPlaystore(BuildContext context) async {
    Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.calculadora.desigual');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
    Navigator.of(context).pop();
  }
}
