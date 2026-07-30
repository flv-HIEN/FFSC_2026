import 'dart:io';

import 'package:test/test.dart';
import 'package:task_gest/src/models/priority.dart';
import 'package:task_gest/src/models/urgent_task.dart';
import 'package:task_gest/src/repositories/task_repository.dart';
import 'package:task_gest/src/services/task_service.dart';

void main() {
  group('UrgentTask JSON', () {
    test('roundtrip preserves all fields', () {
      final task = UrgentTask(
        title: 'Test task',
        dueDate: DateTime(2026, 12, 31),
        isCompleted: true,
        priority: Priority.high,
      );

      final json = task.toJson();
      final reloaded = UrgentTask.fromJson(json);

      expect(reloaded.title, equals('Test task'));
      expect(reloaded.dueDate, equals(DateTime(2026, 12, 31)));
      expect(reloaded.isCompleted, isTrue);
      expect(reloaded.priority, equals(Priority.high));
    });
  });

  group('TaskRepository', () {
    const filePath = 'test_tasks.json';

    tearDown(() {
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('saves and loads tasks from JSON file', () async {
      final repository = TaskRepository<UrgentTask>(
        UrgentTask.fromJson,
        filePath,
      );
      final tasks = [
        UrgentTask(title: 'A', priority: Priority.low),
        UrgentTask(title: 'B', priority: Priority.high, isCompleted: true),
      ];

      await repository.saveTasks(tasks);
      final loaded = await repository.loadTasks();

      expect(loaded, hasLength(2));
      expect(loaded[0].title, equals('A'));
      expect(loaded[1].priority, equals(Priority.high));
      expect(loaded[1].isCompleted, isTrue);
    });

    test('returns empty list when file is missing', () async {
      final repository = TaskRepository<UrgentTask>(
        UrgentTask.fromJson,
        filePath,
      );

      final loaded = await repository.loadTasks();

      expect(loaded, isEmpty);
    });
  });

  group('TaskService', () {
    const filePath = 'service_tasks.json';

    tearDown(() {
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('init loads tasks from repository', () async {
      final repository = TaskRepository<UrgentTask>(
        UrgentTask.fromJson,
        filePath,
      );
      await repository.saveTasks([
        UrgentTask(title: 'Init test', priority: Priority.medium),
      ]);

      final service = TaskService<UrgentTask>(repository);
      await service.init();

      expect(service.tasks, hasLength(1));
      expect(service.tasks.first.title, equals('Init test'));
    });

    test('markTaskAsCompleted updates task and saves it', () async {
      final repository = TaskRepository<UrgentTask>(
        UrgentTask.fromJson,
        filePath,
      );
      final task = UrgentTask(title: 'Complete me', priority: Priority.medium);
      await repository.saveTasks([task]);

      final service = TaskService<UrgentTask>(repository);
      await service.init();
      await service.markTaskAsCompleted(task);

      expect(service.tasks.first.isCompleted, isTrue);

      final loaded = await repository.loadTasks();
      expect(loaded.first.isCompleted, isTrue);
    });

    test('getTasksByPriority filters tasks correctly', () async {
      final repository = TaskRepository<UrgentTask>(
        UrgentTask.fromJson,
        filePath,
      );
      await repository.saveTasks([
        UrgentTask(title: 'Low task', priority: Priority.low),
        UrgentTask(title: 'High task', priority: Priority.high),
      ]);

      final service = TaskService<UrgentTask>(repository);
      await service.init();

      final highTasks = service.getTasksByPriority(Priority.high);

      expect(highTasks, hasLength(1));
      expect(highTasks.first.title, equals('High task'));
    });

    test('removeTask removes task and saves changes', () async {
      final repository = TaskRepository<UrgentTask>(
        UrgentTask.fromJson,
        filePath,
      );
      final task = UrgentTask(title: 'Remove me', priority: Priority.medium);
      await repository.saveTasks([task]);

      final service = TaskService<UrgentTask>(repository);
      await service.init();
      await service.removeTask(task);

      expect(service.tasks, isEmpty);
      final loaded = await repository.loadTasks();
      expect(loaded, isEmpty);
    });

    test(
      'getTasksSortedByPriority returns tasks ordered by priority',
      () async {
        final repository = TaskRepository<UrgentTask>(
          UrgentTask.fromJson,
          filePath,
        );
        await repository.saveTasks([
          UrgentTask(title: 'High', priority: Priority.high),
          UrgentTask(title: 'Low', priority: Priority.low),
          UrgentTask(title: 'Medium', priority: Priority.medium),
        ]);

        final service = TaskService<UrgentTask>(repository);
        await service.init();

        final sorted = service.getTasksSortedByPriority();
        expect(sorted.map((task) => task.priority).toList(), [
          Priority.low,
          Priority.medium,
          Priority.high,
        ]);
      },
    );

    test(
      'getTasksSortedByDate orders tasks by due date with nulls last',
      () async {
        final repository = TaskRepository<UrgentTask>(
          UrgentTask.fromJson,
          filePath,
        );
        await repository.saveTasks([
          UrgentTask(title: 'No date', priority: Priority.low),
          UrgentTask(
            title: 'Later date',
            dueDate: DateTime(2026, 12, 31),
            priority: Priority.medium,
          ),
          UrgentTask(
            title: 'Earlier date',
            dueDate: DateTime(2026, 1, 1),
            priority: Priority.high,
          ),
        ]);

        final service = TaskService<UrgentTask>(repository);
        await service.init();

        final sorted = service.getTasksSortedByDate();
        expect(sorted[0].title, equals('Earlier date'));
        expect(sorted[1].title, equals('Later date'));
        expect(sorted[2].title, equals('No date'));
      },
    );
  });
}
