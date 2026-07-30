import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';
import 'package:task_gest/src/models/urgent_task.dart';
import 'package:task_gest/src/models/priority.dart';
import 'package:task_gest/src/repositories/task_repository.dart';
import 'package:task_gest/src/services/task_service.dart';
import 'package:task_gest/src/services/task_service_interface.dart';

void main() {
  late String filePath;

  setUp(() {
    filePath =
        'service_tasks_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(1 << 32)}.json';
  });

  tearDown(() {
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  test('TaskServiceInterface can load tasks from repository', () async {
    final repository = FileTaskRepository<UrgentTask>(
      UrgentTask.fromJson,
      filePath,
    );
    await repository.saveTasks([
      UrgentTask(title: 'Interface test', priority: Priority.medium),
    ]);

    final TaskServiceInterface<UrgentTask> service = TaskService<UrgentTask>(
      repository,
    );
    await service.init();

    expect(service.getTasksByPriority(Priority.medium), hasLength(1));
  });

  test('markTaskAsCompletedById updates correct task and saves it', () async {
    final repository = FileTaskRepository<UrgentTask>(
      UrgentTask.fromJson,
      filePath,
    );
    final task = UrgentTask(title: 'Complete by id', priority: Priority.high);
    await repository.saveTasks([task]);

    final TaskServiceInterface<UrgentTask> service = TaskService<UrgentTask>(
      repository,
    );
    await service.init();
    await service.markTaskAsCompletedById(task.id);

    expect(service.getTaskById(task.id)?.isCompleted, isTrue);
    final loaded = await repository.loadTasks();
    expect(loaded.first.isCompleted, isTrue);
  });

  test('removeTaskById removes the correct task', () async {
    final repository = FileTaskRepository<UrgentTask>(
      UrgentTask.fromJson,
      filePath,
    );
    final task = UrgentTask(title: 'Remove by id', priority: Priority.low);
    await repository.saveTasks([task]);

    final TaskServiceInterface<UrgentTask> service = TaskService<UrgentTask>(
      repository,
    );
    await service.init();
    await service.removeTaskById(task.id);

    expect(service.getTaskById(task.id), isNull);
    final loaded = await repository.loadTasks();
    expect(loaded, isEmpty);
  });

  test('getTasksSortedByDate handles tasks without due dates', () async {
    final repository = FileTaskRepository<UrgentTask>(
      UrgentTask.fromJson,
      filePath,
    );
    await repository.saveTasks([
      UrgentTask(title: 'No date', priority: Priority.low),
      UrgentTask(
        title: 'Due later',
        dueDate: DateTime(2026, 12, 30),
        priority: Priority.medium,
      ),
      UrgentTask(
        title: 'Due earlier',
        dueDate: DateTime(2026, 1, 2),
        priority: Priority.high,
      ),
    ]);

    final TaskServiceInterface<UrgentTask> service = TaskService<UrgentTask>(
      repository,
    );
    await service.init();

    final sorted = service.getTasksSortedByDate();
    expect(sorted[0].title, equals('Due earlier'));
    expect(sorted[1].title, equals('Due later'));
    expect(sorted[2].title, equals('No date'));
  });

  test('getTasksByPriority filters tasks correctly', () async {
    final repository = FileTaskRepository<UrgentTask>(
      UrgentTask.fromJson,
      filePath,
    );
    await repository.saveTasks([
      UrgentTask(title: 'Low priority', priority: Priority.low),
      UrgentTask(title: 'High priority', priority: Priority.high),
    ]);

    final TaskServiceInterface<UrgentTask> service = TaskService<UrgentTask>(
      repository,
    );
    await service.init();

    final highTasks = service.getTasksByPriority(Priority.high);

    expect(highTasks, hasLength(1));
    expect(highTasks.first.title, equals('High priority'));
  });
}
