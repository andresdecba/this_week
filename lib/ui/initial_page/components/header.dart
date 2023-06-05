import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';

class Header extends GetView<InitialPageController> {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(3, 20, 3, 10),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // week number
            Text(
              '${"week".tr} ${controller.week.value.weekNumber}',
              style: headlineMedium.copyWith(color: disabledGrey),
            ),
            const SizedBox(height: 5),
            // completed %

            _Item(
              text: '${controller.done.value}%  ${'of tasks done'.tr}',
              iconColor: statusTaskDone,
            ),
            const SizedBox(height: 3),
            // in progress %
            _Item(
              text: '${controller.inProgress.value}%  ${'of tasks in progress'.tr}',
              iconColor: statusTaskInProgress,
            ),
            const SizedBox(height: 3),
            // done %
            _Item(
              text: '${controller.pending.value}%  ${'of tasks pending'.tr}',
              iconColor: disabledGrey,
              iconData: Icons.circle_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String text;
  final Color iconColor;
  final IconData? iconData;

  const _Item({
    required this.text,
    required this.iconColor,
    this.iconData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData ?? Icons.circle,
          color: iconColor,
          size: 12,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: kBodySmall.copyWith(color: disabledGrey),
        ),
      ],
    );
  }
}
