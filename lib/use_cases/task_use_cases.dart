import 'package:todoapp/models/task_model.dart';

abstract class TaskUseCases {
  void createTaskUseCase(TaskModel task);
  void deleteTaskUseCase(TaskModel task);
  void updateTaskUseCase(TaskModel task);
}


class TaskUseCasesImpl implements TaskUseCases {
  @override
  void createTaskUseCase(TaskModel task) {
    // implement createTask
  }

  @override
  void deleteTaskUseCase(TaskModel task) {
    // implement deleteTask
  }

  @override
  void updateTaskUseCase(TaskModel task) {
    // implement updateTask
  }
}
