import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/components/form_appbar.dart';
import 'package:todoapp/ui/form_page/components/notification_and_date_picker.dart';
import 'package:todoapp/ui/form_page/components/task_fom.dart';
import 'package:todoapp/ui/form_page/components/todo_list.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';

class FormPage extends GetView<FormsPageController> {
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.onWillPop(context),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // appbar
          appBar: const FormAppbar(),

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

          // edit button
          floatingActionButton: Obx(
            () => Visibility(
              visible: controller.isNewMode.value || controller.isUpdateMode.value,
              replacement: FloatingActionButton(
                backgroundColor: yellow_primary,
                onPressed: () => controller.cancelAndNavigate(context),
                child: const Icon(Icons.home, color: text_bg),
              ),
              child: FloatingActionButton(
                backgroundColor: controller.hasUserInteraction.value ? blue_primary : disabled_grey,
                onPressed: controller.hasUserInteraction.value ? () => controller.saveOrUpdateTask(context) : null,
                child: const Icon(Icons.check_rounded),
              ),
            ),
          ),

          // content
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 70, left: 20, right: 20, top: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // notification
                NotificationsAndDate(),
                SizedBox(height: 30),

                // textfield
                TaskForm(),
                SizedBox(height: 20),

                // todo list
                TodoList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}