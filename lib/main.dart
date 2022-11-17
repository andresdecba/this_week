import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/core/bindings/initial_page_binding.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/pages/initial_page.dart';
import 'package:todoapp/ui/pages/initial_page_week.dart';

void main() async {
  // flitter
  WidgetsFlutterBinding.ensureInitialized();
  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(SubTaskAdapter());
  Hive.registerAdapter(TaskAdapter());

  // open boxes
  await Hive.openBox<Task>('tasksBox');
  await Hive.openBox<List>('dataListBox');
  // run app
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialBinding: InitialPageBinding(),
      getPages: AppPages.getPages,
      home: const InitialPageWeek(),
    );
  }
}
