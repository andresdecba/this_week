import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/form_page/components/form_appbar.dart';
import 'package:todoapp/ui/form_page/components/notification_and_date_picker.dart';
import 'package:todoapp/ui/form_page/components/task_fom.dart';
import 'package:todoapp/ui/form_page/components/todo_list.dart';
import 'package:todoapp/ui/form_page/forms_page_controller.dart';

class FormPageA extends GetView<FormsPageController> {
  const FormPageA({Key? key}) : super(key: key);

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
                ? SizedBox(
                    height: controller.myBanner.size.height.toDouble(),
                    width: controller.myBanner.size.height.toDouble(),
                    child: AdWidget(ad: controller.myBanner),
                  )
                : const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
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
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // notification
                NotificationAndDatePicker(),
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
