import '../models/priority.dart';
import '../models/task.dart';

abstract class TaskServiceInterface<T extends Task> {
  Future<void> init();
  Future<void> addTask(T task);
  Future<void> markTaskAsCompleted(T task);
  Future<void> removeTask(T task);
  List<T> getTasksByPriority(Priority priority);
  List<T> getTasksSortedByPriority();
  List<T> getTasksSortedByDate();
}
