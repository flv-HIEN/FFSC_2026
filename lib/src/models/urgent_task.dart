import '../models/task.dart';
import '../models/priority.dart';

class UrgentTask extends Task {
  UrgentTask({
    super.id,
    required super.title,
    super.dueDate,
    super.isCompleted = false,
    required super.priority,
  });

  @override
  UrgentTask copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? isCompleted,
    Priority? priority,
  }) {
    return UrgentTask(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority.toString().split('.').last,
    };
  }

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as String?,
      title: json['title'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
      priority: Priority.values.firstWhere(
        (p) => p.toString().split('.').last == json['priority'],
        orElse: () => Priority.high,
      ),
    );
  }
}
