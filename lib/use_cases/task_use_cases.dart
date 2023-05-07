import 'package:todoapp/models/task_model.dart';

abstract class TaskUseCases {
  void createTaskUseCase(Task task);
  void deleteTaskUseCase(Task task);
  void updateTaskUseCase(Task task);
}

class TaskUseCasesImpl extends TaskUseCases {
  @override
  void createTaskUseCase(Task task) {
    // TODO: implement createTask
  }

  @override
  void deleteTaskUseCase(Task task) {
    // TODO: implement deleteTask
  }

  @override
  void updateTaskUseCase(Task task) {
    // TODO: implement updateTask
  }
}
