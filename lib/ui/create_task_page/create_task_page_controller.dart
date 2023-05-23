import 'package:get/get.dart';
import 'package:todoapp/use_cases/notifications_use_cases.dart';

import 'package:todoapp/use_cases/tasks_use_cases.dart';

class CreateTaskPageController extends GetxController {
  final TasksUseCases tasksUseCases;
  final NotificationsUseCases notificationsUseCases;

  CreateTaskPageController({
    required this.tasksUseCases,
    required this.notificationsUseCases,
  });

  late DateTime selectedDate;
  RxString description = ''.obs;
  RxBool isRoutine = false.obs;

  // SELECT NOTIFICATION //
  RxInt currentIndex = 0.obs;
  List<String> listOfChipNames = [
    'Desactivado',
    'Mañana 09 hs.',
    'Mediodia 12 hs.',
    'Tarde 17 hs.',
    'Noche 21 hs.',
    'Personalizado',
  ];

  DateTime selectedNotificationDateTime(index) {
    switch (listOfChipNames[index]) {
      case 'Mañana 09 hs.':
        return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
      case 'Mediodia 12 hs.':
        return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12, 0);
      case 'Tarde 17 hs.':
        return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 17, 0);
      case 'Noche 21 hs.':
        return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 21, 0);
      default:
        return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
    }
  }

  void saveTask() {
    // var task = tasksUseCases.createTaskUseCase(
    //   description: description.value,
    //   date: selectedDate,
    //   isRoutine: isRoutine.value,
    // );

    //notificationsUseCases.createUpdateNotificationUseCase(task: task, context: context)
  }
}
