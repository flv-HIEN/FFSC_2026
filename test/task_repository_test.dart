import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';
import 'package:task_gest/src/models/urgent_task.dart';
import 'package:task_gest/src/models/normal_task.dart';
import 'package:task_gest/src/models/priority.dart';
import 'package:task_gest/src/repositories/task_repository.dart';

void main() {
  late String filePath;

  setUp(() {
    filePath =
        'repository_tasks_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(1 << 32)}.json';
  });

  tearDown(() {
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  test('FileTaskRepository can save and load UrgentTask generically', () async {
    final repository = FileTaskRepository<UrgentTask>(
      UrgentTask.fromJson,
      filePath,
    );
    final tasks = [
      UrgentTask(title: 'A', priority: Priority.low),
      UrgentTask(title: 'B', priority: Priority.high),
    ];

    await repository.saveTasks(tasks);
    final loaded = await repository.loadTasks();

    expect(loaded, hasLength(2));
    expect(loaded.first, isA<UrgentTask>());
    expect(loaded[1].title, equals('B'));
  });

  test('FileTaskRepository can save and load NormalTask generically', () async {
    final repository = FileTaskRepository<NormalTask>(
      NormalTask.fromJson,
      filePath,
    );
    final tasks = [
      NormalTask(title: 'Normal 1', priority: Priority.medium),
      NormalTask(title: 'Normal 2', priority: Priority.low),
    ];

    await repository.saveTasks(tasks);
    final loaded = await repository.loadTasks();

    expect(loaded, hasLength(2));
    expect(loaded.first, isA<NormalTask>());
    expect(loaded.last.priority, equals(Priority.low));
  });

  test('FileTaskRepository returns empty list when file is absent', () async {
    final repository = FileTaskRepository<UrgentTask>(
      UrgentTask.fromJson,
      filePath,
    );

    final loaded = await repository.loadTasks();

    expect(loaded, isEmpty);
  });
}
