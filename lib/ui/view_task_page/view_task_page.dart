import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/utils/helpers.dart';

class ViewTaskPage extends StatelessWidget {
  const ViewTaskPage({required this.task, Key? key}) : super(key: key);
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //

              ListTile(
                leading: const Icon(Icons.date_range_rounded),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 0,
                visualDensity: VisualDensity.compact,
                title: Text(
                  longDateFormaterWithoutYear(task.taskDate),
                  style: kBodyMedium,
                ),
              ),

              ListTile(
                leading: const Icon(Icons.notifications_active_rounded),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 0,
                visualDensity: VisualDensity.compact,
                title: Text(
                  timeFormater(task.notificationTime!),
                  style: kBodyMedium,
                ),
              ),

              ListTile(
                leading: const Icon(Icons.circle_rounded),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 0,
                visualDensity: VisualDensity.compact,
                title: Text(
                  task.status,
                  style: kBodyMedium,
                ),
              ),
              const SizedBox(height: 20),

              const Text('Descripción'),
              const Divider(color: black_bg),
              Text(
                task.description,
                style: kBodyMedium,
              ),
              const SizedBox(height: 30),

              const Text('Subtareas'),
              const Divider(color: black_bg),
              ...task.subTasks.map((e) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    e.title,
                    style: e.isDone ? kBodyMedium.copyWith(fontStyle: FontStyle.italic, decoration: TextDecoration.lineThrough) : kBodyMedium,
                  ),
                  visualDensity: VisualDensity.compact,
                  leading: e.isDone ? const Icon(Icons.check_circle_outline_rounded) : const Icon(Icons.circle_outlined),
                  minLeadingWidth: 0,
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

////

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(
        'assets/appbar_logo.svg',
        alignment: Alignment.center,
        color: appBar_logo,
        fit: BoxFit.contain,
        height: 21,
      ),
      backgroundColor: yellow_primary,
      iconTheme: IconThemeData(color: black_bg),
      toolbarTextStyle: TextStyle(color: black_bg),
      titleTextStyle: TextStyle(color: black_bg, fontSize: 16),
      elevation: 0,
      //titleSpacing: 24,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
