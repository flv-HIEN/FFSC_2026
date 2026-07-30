import '../models/priority.dart';
import '../models/task.dart';

abstract class TaskServiceInterface<T extends Task> {
  Future<void> init();
  Future<void> addTask(T task);
  Future<void> markTaskAsCompleted(T task);
  Future<void> markTaskAsCompletedById(String id);
  Future<void> removeTask(T task);
  Future<void> removeTaskById(String id);
  T? getTaskById(String id);
  List<T> getTasksByPriority(Priority priority);
  List<T> getTasksSortedByPriority();
  List<T> getTasksSortedByDate();
}
