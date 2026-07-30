//import 'package:task_gest/task_gest.dart';
import 'dart:io';
import 'package:task_gest/src/models/priority.dart';
//import 'package:task_gest/src/models/task.dart';
import 'package:task_gest/src/models/urgent_task.dart';
import 'package:task_gest/src/services/task_service.dart';
import 'package:task_gest/src/repositories/task_repository.dart';

Future<void> main(List<String> arguments) async {
  TaskService<UrgentTask> createTaskService() {
    final repository = TaskRepository<UrgentTask>(UrgentTask.fromJson);
    return TaskService<UrgentTask>(repository);
  }

  final service = createTaskService();
  await service.init();

  //print('Hello world: ${task_gest.calculate()}!');
  print(
    "Welcome to TaskGest! This is a simple task management application.\nChoose a number from the menu below to get started.",
  );

  int exit = 0;
  while (exit != 4) {
    print("\nMenu:");

    print("1. Add a new task");
    print("2. View all tasks by priority");
    print("3. Mark a task as completed");
    print("4. Exit");
    print("Votre choix...");

    int? choice = int.tryParse(stdin.readLineSync() ?? '-1');
    stdout.write("");

    switch (choice) {
      case 1:
        // Add a new task
        print("Adding a new task...");
        print("add a Title");
        String title = stdin.readLineSync() ?? '';
        print("add a due date (YYYY-MM-DD) or leave empty for no due date");
        String dueDateInput = stdin.readLineSync() ?? '';
        DateTime? dueDate;
        if (dueDateInput.isNotEmpty) {
          try {
            dueDate = DateTime.parse(dueDateInput);
          } catch (e) {
            print("Invalid date format. Please use YYYY-MM-DD.");
            return;
          }
        }
        print("add a priority (low, medium, high)");
        String priorityInput = stdin.readLineSync() ?? '';
        Priority priority;
        switch (priorityInput.toLowerCase()) {
          case 'low':
            priority = Priority.low;
            break;
          case 'medium':
            priority = Priority.medium;
            break;
          case 'high':
            priority = Priority.high;
            break;
          default:
            print("Invalid priority. Please choose low, medium, or high.");
            return;
        }
        UrgentTask newTask = UrgentTask(
          title: title,
          dueDate: dueDate,
          priority: priority,
        );
        await service.addTask(newTask);
        print("Task added successfully!");
        break;
      case 2:
        // Add logic to view tasks by priority
        print("Viewing tasks by priority...");
        print("Choose a priority to filter tasks:");
        String priorityInput = stdin.readLineSync() ?? '';
        Priority priority;
        switch (priorityInput.toLowerCase()) {
          case 'low':
            priority = Priority.low;
            break;
          case 'medium':
            priority = Priority.medium;
            break;
          case 'high':
            priority = Priority.high;
            break;
          default:
            print("Invalid priority. Please choose low, medium, or high.");
            return;
        }
        final tasks = service.getTasksByPriority(priority);
        for (final task in tasks) {
          print("- ${task.title} (${task.priority})");
        }
        break;
      case 3:
        print("Marking a task as completed...");
        // Add logic to mark a task as completed
        print("Enter the title of the task to mark as completed:");
        String title = stdin.readLineSync() ?? '';
        final taskToMark = service.tasks.firstWhere(
          (task) => task.title == title,
          orElse: () => throw Exception('Task not found'),
        );
        await service.markTaskAsCompleted(taskToMark);
        print("Task ${taskToMark.title} marked as completed!");
        break;
      case 4:
        print("Exiting the application. Goodbye!");
        exit = 4;
        break;
      default:
        print("Invalid option. Please choose a number from the menu.");
        stdout.write('Votre choix : ');
    }
  }
}
