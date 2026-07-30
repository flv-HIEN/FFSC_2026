import '../errors/task_exception.dart';
import '../models/priority.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_service_interface.dart';

class TaskService<T extends Task> implements TaskServiceInterface<T> {
  List<T> _tasks = [];
  final TaskRepository<T> _taskRepository;

  List<T> get tasks => _tasks;
  TaskService(this._taskRepository);

  @override
  Future<void> init() async {
    _tasks = await _taskRepository.loadTasks();
  }

  @override
  Future<void> addTask(T task) async {
    _tasks.add(task);
    await _taskRepository.saveTasks(tasks);
  }

  @override
  List<T> getTasksByPriority(Priority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  @override
  List<T> getTasksSortedByPriority() {
    final sorted = List<T>.from(_tasks);
    sorted.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    return sorted;
  }

  @override
  List<T> getTasksSortedByDate() {
    final sorted = List<T>.from(_tasks);
    sorted.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sorted;
  }

  @override
  Future<void> markTaskAsCompleted(T task) async {
    final index = _tasks.indexOf(task);
    if (index == -1) {
      throw TaskNotFoundException('La tâche "${task.title}" est introuvable.');
    }

    final updatedTask = _tasks[index].copyWith(isCompleted: true);
    _tasks[index] = updatedTask as T;

    try {
      await _taskRepository.saveTasks(tasks);
    } catch (e) {
      if (e is TaskException) rethrow;
      throw TaskStorageException(
        'Impossible de sauvegarder la tâche marquée comme terminée.',
      );
    }

    print('Task "${task.title}" marked as completed.');
  }

  @override
  Future<void> removeTask(T task) async {
    final removed = _tasks.remove(task);
    if (!removed) {
      throw TaskNotFoundException('La tâche "${task.title}" est introuvable.');
    }

    try {
      await _taskRepository.saveTasks(tasks);
    } catch (e) {
      if (e is TaskException) rethrow;
      throw TaskStorageException(
        'Impossible de sauvegarder la suppression de la tâche.',
      );
    }
  }
}
