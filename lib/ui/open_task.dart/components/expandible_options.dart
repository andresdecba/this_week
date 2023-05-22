import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/open_task.dart/components/options_item_tile.dart';
import 'package:todoapp/ui/open_task.dart/view_task_controller.dart';
import 'package:todoapp/utils/helpers.dart';

enum _MenuItem {
  item1,
  item2,
  item3,
  item4,
}

class ExpandibleOptions extends GetView<ViewTaskController> {
  const ExpandibleOptions({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Rx<TaskModel> task;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context) {
        return [
          // CAMBIAR LA FECHA
          PopupMenuItem(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: _MenuItem.item1,
            child: OptionsItemTile(
              title: longDateFormaterWithoutYear(task.value.taskDate),
              icon: Icons.calendar_today_rounded,
              onTap: () {
                controller.datePicker(context, task);
              },
            ),
          ),

          // CAMBIAR HORA DE LA NOTIFICACION
          PopupMenuItem(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: _MenuItem.item1,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Divider(color: disabledGrey, height: 0),
                Obx(
                  () => OptionsItemTile(
                    title: task.value.notificationData?.time != null ? timeFormater(task.value.notificationData!.time) : 'Seleccionar...',
                    icon: controller.isNotificationActive.value ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                    trailing: Switch(
                      value: controller.isNotificationActive.value,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // disable notifications
                      onChanged: (value) {
                        controller.isNotificationActive.value = value;
                      },
                    ),
                    // open time picker
                    onTap: controller.isNotificationActive.value ? () => controller.timePicker(context) : null,
                  ),
                ),
              ],
            ),
          ),

          // CAMBIAR EL STATUS
          PopupMenuItem(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: _MenuItem.item1,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Divider(color: disabledGrey, height: 0),
                OptionsItemTile(
                  title: task.value.status,
                  icon: Icons.keyboard_double_arrow_right_rounded,
                ),
              ],
            ),
          ),

          // SI ES RUTINA
          PopupMenuItem(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: _MenuItem.item1,
            child: Visibility(
              visible: task.value.repeatId != null ? true : false,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Divider(color: disabledGrey, height: 0),
                  OptionsItemTile(
                    title: 'Rutina',
                    icon: Icons.push_pin_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case _MenuItem.item1:
            debugPrint('MenuItem.item1');
            break;
          case _MenuItem.item2:
            debugPrint('MenuItem.item2');
            break;
          case _MenuItem.item3:
            debugPrint('MenuItem.item3');
            break;
          case _MenuItem.item4:
            debugPrint('MenuItem.item4');
            break;
        }
      },
    );
  }
}



/*
 //var _value = 'hola1';
Expanded(
      child: DropdownButton(
        items: const [
          DropdownMenuItem(child: Text('data1'), value: 'hola1'),
          DropdownMenuItem(child: Text('data2'), value: 'hola2'),
          DropdownMenuItem(child: Text('data3'), value: 'hola3'),
        ],
        onChanged: (value) {
          _value = value!;
        },
        value: _value,
        isExpanded: true,
        icon: const Icon(Icons.more_vert_rounded),
      ),
    );

**/