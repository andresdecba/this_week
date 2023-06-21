import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/build_page_controller.dart';
import 'package:todoapp/ui/initial_page/initial_page_controller.dart';
import 'package:todoapp/ui/shared_components/my_icon_button.dart';
import 'package:todoapp/utils/helpers.dart';

class Header extends GetView<BuildPageController> {
  const Header({
    required this.week,
    required this.textColor,
    super.key,
  });

  final Week week;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    Text(
                      'your tasks for'.tr,
                      style: kBodyMedium.copyWith(color: blackBg.withOpacity(0.6)),
                    ),
                    Text(
                      weekToHumanRead(week),
                      style: headlineSmall.copyWith(color: blackBg.withOpacity(0.6)),
                    ),
                  ],
                ),
                Text(
                  rangeDateFormater(week.days.first, week.days.last),
                  style: kTitleMedium.copyWith(color: blackBg.withOpacity(0.6), fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => Globals.myScaffoldKey.currentState!.openEndDrawer(),
                icon: const Icon(Icons.menu_rounded),
              ),
              week != Week.current()
                  ? MyIconButton(
                      label: 'HOME',
                      onTap: () {
                        Get.find<InitialPageController>().returnToCurrentWeek();
                      },
                      isEnabled: true,
                      iconData: Icons.home_rounded,
                      color: Colors.white.withOpacity(0.5),
                    )
                  : const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       rangeDateFormater(week.days.first, week.days.last),
    //       style: headlineSmall.copyWith(
    //         color: textColor,
    //       ),
    //     ),
    //     const SizedBox(height: 10),
    //     Text(
    //       '${"week".tr} ${week.weekNumber}',
    //       style: kTitleLarge.copyWith(
    //         color: textColor,
    //         fontStyle: FontStyle.italic,
    //       ),
    //     ),
    //   ],
    // );

    // return RichText(
    //   text: TextSpan(
    //     text: '${"week".tr} ${week.weekNumber}: ',
    //     style: headlineSmall.copyWith(color: disabledGrey),
    //     children: <TextSpan>[
    //       TextSpan(
    //         text: rangeDateFormater(week.days.first, week.days.last),
    //         style: kTitleLarge.copyWith(color: disabledGrey, fontStyle: FontStyle.italic),
    //       ),
    //     ],
    //   ),
    // );
    /*
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

            RichText(
              text: TextSpan(
                text: '${"week".tr} ${week.weekNumber}: ',
                style: headlineSmall.copyWith(color: disabledGrey),
                children: <TextSpan>[
                  TextSpan(
                    text: rangeDateFormater(week.days.first, week.days.last),
                    style: kTitleLarge.copyWith(color: disabledGrey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            // completed
            _Item(
              text: '${controller.pending.value}%  ${'of tasks pending'.tr}',
              iconColor: disabledGrey,
              iconData: Icons.circle_outlined,
            ),
            const SizedBox(height: 3),

            // in progress
            _Item(
              text: '${controller.inProgress.value}%  ${'of tasks in progress'.tr}',
              iconColor: statusTaskInProgress,
            ),
            const SizedBox(height: 3),

            // done
            _Item(
              text: '${controller.done.value}%  ${'of tasks done'.tr}',
              iconColor: statusTaskDone,
            ),
          ],
        ),
      ),
    );
    */
  }
}

// class _Item extends StatelessWidget {
//   final String text;
//   final Color iconColor;
//   final IconData? iconData;

//   const _Item({
//     required this.text,
//     required this.iconColor,
//     this.iconData,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(
//           iconData ?? Icons.circle,
//           color: iconColor,
//           size: 12,
//         ),
//         const SizedBox(width: 5),
//         Text(
//           text,
//           style: kBodySmall.copyWith(color: disabledGrey),
//         ),
//       ],
//     );
//   }
// }
