import 'dart:math';

import '../models/priority.dart';

abstract class Task {
  final String id;
  final String title;
  DateTime? dueDate;
  final bool isCompleted;
  final Priority priority;

  Task({
    String? id,
    required this.title,
    this.dueDate,
    this.isCompleted = false,
    required this.priority,
  }) : id = id ?? _generateId();

  static String _generateId() {
    final random = Random();
    return '${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(1 << 32)}';
  }

  Task copyWith({
    String? id,
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
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson();
}
