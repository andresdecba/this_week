import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/postpose_page/components/view_task.dart';
import 'package:todoapp/ui/shared_components/bottomsheet.dart';
import 'package:todoapp/ui/postpose_page/postpose_page_controller.dart';

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
          color: black_bg,
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
                    side: const BorderSide(color: blue_primary),
                  ),
                  child: Text('cancel'.tr),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => controller.savePostpose(controller.selectedItem.value),
                  child: Text('ok'.tr),
                ),
              ),
            ],
          ),
        ),
      ],

      // adMob
      bottomNavigationBar: Obx(
        () => controller.isAdLoaded.value
            ? Container(
                height: controller.bannerAd.size.height.toDouble(),
                width: controller.bannerAd.size.height.toDouble(),
                color: enabled_grey,
                child: Align(
                  alignment: Alignment.center,
                  child: AdWidget(ad: controller.bannerAd),
                ),
              )
            : Container(
                height: 60.0,
                width: double.infinity,
                color: enabled_grey,
                child: const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
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
                      onPressed: () => openBottomSheet(context: context, widget: ViewTask(task: controller.task)),
                    ),
                  ],
                ),

                /// opciones de posponer
                ...PostposeEnum.values.toList().map((e) {
                  bool isSelected = controller.isSelected(e);
                  return Column(
                    children: [
                      RadioListTile(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        visualDensity: VisualDensity.compact,
                        activeColor: blue_primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          controller.setTitle(e),
                          style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                        ),
                        subtitle: Text(controller.setSubTitle(e)),
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
                }),
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
      color: disabled_grey,
      // indent: 10,
      // endIndent: 10,
    );
  }
}
