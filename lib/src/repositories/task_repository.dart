import 'dart:convert'; // jsonEncode / jsonDecode
import 'dart:io'; // File, Directory
import '../models/task.dart';
import '../errors/task_exception.dart';

abstract class TaskRepository<T extends Task> {
  Future<void> saveTasks(List<T> tasks);
  Future<List<T>> loadTasks();
}

class FileTaskRepository<T extends Task> implements TaskRepository<T> {
  final T Function(Map<String, dynamic>) fromJson;
  final String _filePath;

  FileTaskRepository(this.fromJson, [this._filePath = 'tasks.json']);

  @override
  Future<void> saveTasks(List<T> tasks) async {
    final file = File(_filePath);
    final jsonString = jsonEncode(tasks.map((task) => task.toJson()).toList());

    try {
      await file.writeAsString(jsonString);
    } catch (e) {
      throw TaskStorageException('Impossible de sauvegarder les tâches : $e');
    }
  }

  @override
  Future<List<T>> loadTasks() async {
    final file = File(_filePath);
    if (await file.exists()) {
      try {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => fromJson(json)).toList();
      } catch (e) {
        throw TaskStorageException('Impossible de charger les tâches : $e');
      }
    }
    return [];
  }
}
