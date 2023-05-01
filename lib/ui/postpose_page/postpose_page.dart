import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/postpose_page/postpose_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

class PostPosePage extends GetView<PostPosePageController> {
  const PostPosePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posponer tarea'),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// titulos
              Text(
                'Tarea',
                style: kTitleLarge,
              ),
              const SizedBox(height: 20),
              Text(
                controller.task.description,
                style: kTitleMedium.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 40),

              Text(
                'Posponer',
                style: kTitleLarge,
              ),
              const SizedBox(height: 20),

              /// opciones
              const _Divider(),
              RadioListTile(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                visualDensity: VisualDensity.compact,
                //selectedTileColor: yellow_primary,
                activeColor: blue_primary,
                title: Text(
                  '15 minutos',
                  style: TextStyle(fontWeight: controller.selectedDuration.value == const Duration(minutes: 15) ? FontWeight.bold : FontWeight.normal),
                ),
                subtitle: Text('Hoy a las ${timeFormater(controller.task.notificationTime!.add(const Duration(minutes: 15)))}'),
                selected: controller.selectedDuration.value == const Duration(minutes: 15),
                value: const Duration(minutes: 15),
                groupValue: controller.selectedDuration.value,
                onChanged: (duration) {
                  controller.selectedDuration.value = duration!;
                },
              ),
              const _Divider(),
              RadioListTile(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                visualDensity: VisualDensity.compact,
                //selectedTileColor: yellow_primary,
                activeColor: blue_primary,
                title: Text(
                  '1 hora',
                  style: TextStyle(fontWeight: controller.selectedDuration.value == const Duration(hours: 1) ? FontWeight.bold : FontWeight.normal),
                ),
                subtitle: Text('Hoy a las ${timeFormater(controller.task.notificationTime!.add(const Duration(hours: 1)))}'),
                selected: controller.selectedDuration.value == const Duration(hours: 1),
                value: const Duration(hours: 1),
                groupValue: controller.selectedDuration.value,
                onChanged: (duration) {
                  controller.selectedDuration.value = duration!;
                },
              ),
              const _Divider(),
              RadioListTile(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                visualDensity: VisualDensity.compact,
                //selectedTileColor: yellow_primary,
                activeColor: blue_primary,
                title: Text(
                  '3 horas',
                  style: TextStyle(fontWeight: controller.selectedDuration.value == const Duration(hours: 3) ? FontWeight.bold : FontWeight.normal),
                ),
                subtitle: Text('Hoy a las ${timeFormater(controller.task.notificationTime!.add(const Duration(hours: 3)))}'),
                selected: controller.selectedDuration.value == const Duration(hours: 3),
                value: const Duration(hours: 3),
                groupValue: controller.selectedDuration.value,
                onChanged: (duration) {
                  controller.selectedDuration.value = duration!;
                },
              ),
              const _Divider(),
              RadioListTile(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                visualDensity: VisualDensity.compact,
                //selectedTileColor: yellow_primary,
                activeColor: blue_primary,
                title: Text(
                  '1 día',
                  style: TextStyle(fontWeight: controller.selectedDuration.value == const Duration(days: 1) ? FontWeight.bold : FontWeight.normal),
                ),
                subtitle: Text('Mañana a las ${timeFormater(controller.task.notificationTime!.add(const Duration(days: 1)))}'),
                selected: controller.selectedDuration.value == const Duration(days: 1),
                value: const Duration(days: 1),
                groupValue: controller.selectedDuration.value,
                onChanged: (duration) {
                  controller.selectedDuration.value = duration!;
                },
              ),
              const _Divider(),
              RadioListTile(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                visualDensity: VisualDensity.compact,
                //selectedTileColor: yellow_primary,
                activeColor: blue_primary,
                title: Text(
                  'Personalizar',
                  style: TextStyle(fontWeight: controller.selectedDuration.value == const Duration(days: 2) ? FontWeight.bold : FontWeight.normal),
                ),
                subtitle: Text('Personalizado: ${timeFormater(controller.task.notificationTime!.add(const Duration(days: 2)))}'),
                selected: controller.selectedDuration.value == const Duration(days: 2), ////
                value: const Duration(days: 2),
                groupValue: controller.selectedDuration.value,
                onChanged: (duration) async {
                  controller.selectedDuration.value = duration!;
                  await controller.datePicker(context);
                },
                secondary: IconButton(
                  onPressed: controller.selectedDuration.value != const Duration(days: 2) ? null : () {},
                  icon: const Icon(Icons.edit_rounded),
                  color: black_bg,
                ),
                contentPadding: const EdgeInsets.only(left: 16),
              ),
              const _Divider(),

              /// botones
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: blue_primary),
                      ),
                      child: Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.selectedDuration.value == const Duration(days: 2)) {
                          // si es mañana u otro dia

                          Get.offAllNamed(Routes.INITIAL_PAGE);
                        } else {
                          // si es dentro del dia de hoy
                          controller.postposeNotification(DateTime.now().add(controller.selectedDuration.value));
                          Get.offAllNamed(Routes.INITIAL_PAGE);
                        }
                      },
                      child: Text('Aceptar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      color: disabled_grey,
      // indent: 10,
      // endIndent: 10,
    );
  }
}

/*

class _Tile extends StatelessWidget {
  const _Tile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          //tileColor: disabled_grey,
          visualDensity: VisualDensity.compact,
          secondary: Text('data'),
          selectedTileColor: Colors.yellow,
          activeColor: Colors.red,
          title: Text('15 minutos'),
          subtitle: Text('Hoy a las ${timeFormater(controller.task.notificationTime!.add(const Duration(minutes: 15)))}'),
          selected: controller.selectedDuration.value == const Duration(minutes: 15),
          value: const Duration(minutes: 15),
          groupValue: controller.selectedDuration.value,
          onChanged: (duration) {
            controller.selectedDuration.value = duration!;
          },
        ),
        const Divider(height: 0, indent: 10, color: Colors.yellow),
      ],
    );
  }
}



// ...controller.durations.map(
              //   (e) {
              //     var title = controller.durationsTitle[controller.durations.indexOf(e)];
              //     return RadioListTile(
              //       secondary: Text('data'),
              //       selectedTileColor: Colors.yellow,
              //       activeColor: Colors.red,
              //       selected: controller.selectedDuration.value == e,
              //       title: Text(title),
              //       subtitle: Text(
              //         title == '1 día' ? 'Mañana a las ${timeFormater(controller.task.notificationTime!.add(e))}' : 'Hoy a las ${timeFormater(controller.task.notificationTime!.add(e))}',
              //       ),
              //       value: e,
              //       groupValue: controller.selectedDuration.value,
              //       onChanged: (duration) {
              //         controller.selectedDuration.value = duration!;
              //       },
              //     );
              //   },
              // ),
*/