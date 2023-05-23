import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/postpose_page/components/view_task.dart';
import 'package:todoapp/ui/postpose_page/postpose_page_controller.dart';
import 'package:todoapp/ui/shared_components/bottomsheet_with_scroll.dart';

class PostPosePage extends GetView<PostPosePageController> {
  const PostPosePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        titleSpacing: 24,
        //title: SizedBox(),
        title: SvgPicture.asset(
          'assets/appbar_logo.svg',
          alignment: Alignment.center,
          color: blackBg,
          fit: BoxFit.contain,
          height: 21,
        ),
      ),

      // Aceptar o cancelar
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => controller.cancelPostpose(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: bluePrimary),
                  ),
                  child: Text('cancel'.tr),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => controller.savePostpose(controller.selectedItem.value, context),
                  child: Text('ok'.tr),
                ),
              ),
            ],
          ),
        ),
      ],

      // adMob
      bottomNavigationBar: controller.obx(
        (ad) => Container(
          height: ad.size.height.toDouble(),
          width: ad.size.height.toDouble(),
          color: enabledGrey,
          child: Align(
            alignment: Alignment.center,
            child: AdWidget(ad: ad),
          ),
        ),
        onLoading: Container(
          height: 60.0,
          width: double.infinity,
          color: enabledGrey,
          child: const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
        onError: (error) => Container(
          height: 60.0,
          width: double.infinity,
          color: enabledGrey,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              error!,
              style: kTitleMedium.copyWith(color: witheBg),
            ),
          ),
        ),
      ),

      // body
      body: Obx(
        () => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// titulo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'postpone task'.tr,
                      style: kTitleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () => openBottomSheetWithScroll(context: context, widget: ViewTask(task: controller.task)),
                    ),
                  ],
                ),

                /// opciones de posponer
                ...PostposeEnum.values.toList().map((e) {
                  bool isSelected = controller.isSelected(e);
                  controller.subtitle.value = controller.setSubTitle(e);
                  return Column(
                    children: [
                      RadioListTile(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        visualDensity: VisualDensity.compact,
                        activeColor: bluePrimary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          controller.setTitle(e),
                          style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                        ),
                        subtitle: Text(controller.subtitle.value), //Text(controller.setSubTitle(e)),
                        selected: isSelected,
                        value: e,
                        groupValue: controller.selectedItem.value,
                        onChanged: (value) {
                          controller.onChanged(value!, context);
                        },
                        secondary: e == PostposeEnum.personalized
                            ? IconButton(
                                onPressed: isSelected ? () => controller.datePicker() : null,
                                icon: const Icon(Icons.edit_rounded),
                              ) //
                            : null, //
                      ),
                      e.index == 4 ? const SizedBox() : const _Divider(),
                    ],
                  );
                })
              ],
            ),
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
      color: disabledGrey,
      // indent: 10,
      // endIndent: 10,
    );
  }
}
