import 'package:todoapp/models/task_model.dart';

abstract class TaskUseCases {
  void createTaskUseCase(TaskModel task);
  void deleteTaskUseCase(TaskModel task);
  void updateTaskUseCase(TaskModel task);
}

class TaskUseCasesImpl extends TaskUseCases {
  @override
  void createTaskUseCase(TaskModel task) {
    // TODO: implement createTask
  }

  @override
  void deleteTaskUseCase(TaskModel task) {
    // TODO: implement deleteTask
  }

  @override
  void updateTaskUseCase(TaskModel task) {
    // TODO: implement updateTask
  }
}
