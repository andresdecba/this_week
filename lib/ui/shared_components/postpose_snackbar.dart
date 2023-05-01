import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';

void postposeModalBottomSheet({required BuildContext context}) {
  // controller
  final controller = Get.find<FormsPageController>();

  showModalBottomSheet(
    context: context,
    backgroundColor: blue_primary,
    enableDrag: false,
    isDismissible: false,
    useSafeArea: true,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Posponer tarea', style: kTitleLarge),
                const Icon(Icons.notifications_active_rounded),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Item(
                  title: '15 Min',
                  icon: const Icon(Icons.keyboard_arrow_right_rounded),
                  onTap: () => controller.postposeNotification(const Duration(minutes: 1)),
                ),
                _Item(
                  title: '1 Hora',
                  icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                  onTap: () => controller.postposeNotification(const Duration(hours: 1)),
                ),
                _Item(
                  title: '3 Horas',
                  icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                  onTap: () => controller.postposeNotification(const Duration(hours: 3)),
                ),
                _Item(
                  title: 'Mañana',
                  icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  onTap: () => controller.postposeNotification(const Duration(days: 1)),
                ),
                _Item(
                  title: 'Otro',
                  icon: const Icon(Icons.keyboard_control),
                  onTap: () {
                    controller.floatingActionButtonChangeMode();
                    controller.enableDisableNotificationStyles();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void postposeBottomSheet() {
  BottomSheet(
    onClosing: () {},
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Posponer tarea', style: kTitleLarge),
                const Icon(Icons.notifications_active_rounded),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Item(
                  title: '15 Min',
                  icon: const Icon(Icons.keyboard_arrow_right_rounded),
                  onTap: () {},
                ),
                _Item(
                  title: '1 Hora',
                  icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                  onTap: () {},
                ),
                _Item(
                  title: '3 Horas',
                  icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                  onTap: () {},
                ),
                _Item(
                  title: 'Mañana',
                  icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  onTap: () {},
                ),
                _Item(
                  title: 'Otro',
                  icon: const Icon(Icons.keyboard_control),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

/// SNACKBAR NATIVO ///
void snackbarNativo(BuildContext context) {
  // show
  final snackBar = SnackBar(
    padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 60),
    backgroundColor: blue_primary.withOpacity(0.50),
    onVisible: () {},
    duration: const Duration(seconds: 60),
    elevation: 0,
    behavior: SnackBarBehavior.fixed,
    shape: const RoundedRectangleBorder(
      //side: BorderSide(color: Colors.red, width: 1),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Posponer tarea', style: kTitleLarge),
            const Icon(Icons.notifications_active_rounded),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Item(
              title: '15 Min',
              icon: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {},
            ),
            _Item(
              title: '1 Hora',
              icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
              onTap: () {},
            ),
            _Item(
              title: '3 Horas',
              icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
              onTap: () {},
            ),
            _Item(
              title: 'Mañana',
              icon: const Icon(Icons.keyboard_arrow_up_rounded),
              onTap: () {},
            ),
            _Item(
              title: 'Otro',
              icon: const Icon(Icons.keyboard_control),
              onTap: () {},
            ),
          ],
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class _Item extends StatelessWidget {
  const _Item({
    required this.title,
    required this.onTap,
    required this.icon,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                onTap();
                Navigator.pop(context); // close showModalBottomSheet
                //ScaffoldMessenger.of(context).hideCurrentSnackBar(); // close snackbar
              },
              //radius: 100,
              splashColor: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
                child: icon,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: kTitleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
