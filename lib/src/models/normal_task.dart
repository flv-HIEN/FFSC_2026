import '../models/task.dart';
import '../models/priority.dart';

class NormalTask extends Task {
  NormalTask({
    super.id,
    required super.title,
    super.dueDate,
    super.isCompleted = false,
    required super.priority,
  });

  @override
  NormalTask copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? isCompleted,
    Priority? priority,
  }) {
    return NormalTask(
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
      'type': 'normal',
    };
  }

  factory NormalTask.fromJson(Map<String, dynamic> json) {
    return NormalTask(
      id: json['id'] as String?,
      title: json['title'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
      priority: Priority.values.firstWhere(
        (p) => p.toString().split('.').last == json['priority'],
        orElse: () => Priority.medium,
      ),
    );
  }
}
