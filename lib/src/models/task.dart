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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.title == title &&
        other.dueDate == dueDate &&
        other.isCompleted == isCompleted &&
        other.priority == priority;
  }

  @override
  int get hashCode => Object.hash(title, dueDate, isCompleted, priority);

  Map<String, dynamic> toJson();
}
