import 'package:test/test.dart';
import 'package:task_gest/src/models/urgent_task.dart';
import 'package:task_gest/src/models/normal_task.dart';
import 'package:task_gest/src/models/priority.dart';

void main() {
  test('UrgentTask JSON roundtrip preserves id and fields', () {
    final original = UrgentTask(
      title: 'Urgent test',
      dueDate: DateTime(2026, 8, 1),
      priority: Priority.high,
      isCompleted: true,
    );

    final json = original.toJson();
    final copied = UrgentTask.fromJson(json);

    expect(copied.id, equals(original.id));
    expect(copied.title, equals(original.title));
    expect(copied.priority, equals(original.priority));
    expect(copied.isCompleted, isTrue);
  });

  test('NormalTask JSON roundtrip preserves id and priority', () {
    final original = NormalTask(title: 'Normal test', priority: Priority.low);

    final json = original.toJson();
    final copied = NormalTask.fromJson(json);

    expect(copied.id, equals(original.id));
    expect(copied.priority, equals(Priority.low));
    expect(copied.title, equals(original.title));
  });
}
