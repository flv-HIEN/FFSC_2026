import '../models/priority.dart';

abstract class Task {
  final String title;
  DateTime? dueDate;
  final bool isCompleted;
  final Priority priority;

  Task({
    required this.title,
    this.dueDate,
    this.isCompleted = false,
    required this.priority,
  });

  Task copyWith({
    String? title,
    DateTime? dueDate,
    bool? isCompleted,
    Priority? priority,
  });

  @override
  String toString() {
    final status = isCompleted ? '✔' : '✗';
    return 'Task(title: $title, dueDate: $dueDate, priority: $priority, status: $status)';
  }

  Map<String, dynamic> toJson();
}
