//import 'package:task_gest/task_gest.dart';
import 'dart:io';
import 'package:task_gest/src/models/priority.dart';
import 'package:task_gest/src/models/urgent_task.dart';
import 'package:task_gest/src/services/task_service.dart';
import 'package:task_gest/src/repositories/task_repository.dart';
import 'package:task_gest/src/errors/task_exception.dart';

Future<void> main(List<String> arguments) async {
  TaskService<UrgentTask> createTaskService() {
    final repository = FileTaskRepository<UrgentTask>(UrgentTask.fromJson);
    return TaskService<UrgentTask>(repository);
  }

  final service = createTaskService();
  await service.init();

  //print('Hello world: ${task_gest.calculate()}!');
  print(
    "Welcome to TaskGest! This is a simple task management application.\nChoose a number from the menu below to get started.",
  );

  int exit = 0;
  while (exit != 5) {
    print("\nMenu:");

    print("1. Add a new task");
    print("2. List all tasks");
    print("3. Mark a task as completed");
    print("4. Remove a task");
    print("5. Exit");
    print("Votre choix...");

    int? choice = int.tryParse(stdin.readLineSync() ?? '-1');

    switch (choice) {
      case 1:
        try {
          print("Adding a new task...");
          print("Add a title:");
          String title = stdin.readLineSync() ?? '';
          print("Add a due date (YYYY-MM-DD) or leave empty for no due date:");
          String dueDateInput = stdin.readLineSync() ?? '';
          DateTime? dueDate;
          if (dueDateInput.isNotEmpty) {
            try {
              dueDate = DateTime.parse(dueDateInput);
            } catch (e) {
              throw InvalidInputException(
                'Invalid date format. Please use YYYY-MM-DD.',
              );
            }
          }
          print("add a priority (low, medium, high):");
          String priorityInput = stdin.readLineSync() ?? '';
          Priority? priority;
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
              throw InvalidInputException(
                'Invalid priority. Please choose low, medium, or high.',
              );
          }

          UrgentTask newTask = UrgentTask(
            title: title,
            dueDate: dueDate,
            priority: priority,
          );
          await service.addTask(newTask);
          print("Task added successfully!");
        } on InvalidInputException catch (e) {
          print('Input error: ${e.message}');
        } on TaskException catch (e) {
          print('Task error: ${e.message}');
        } catch (e) {
          print('Error: ${e.toString()}');
        }
        break;
      case 2:
        print("List all tasks:");
        print("Choose a sort option: 1) priority, 2) due date");
        final sortChoice = int.tryParse(stdin.readLineSync() ?? '-1');
        List<UrgentTask>? tasksToShow;
        if (sortChoice == 1) {
          tasksToShow = service.getTasksSortedByPriority();
        } else if (sortChoice == 2) {
          tasksToShow = service.getTasksSortedByDate();
        } else {
          print("Invalid sort option.");
          break;
        }
        if (tasksToShow.isEmpty) {
          print('No tasks available.');
          break;
        }
        for (final task in tasksToShow) {
          final due = task.dueDate != null
              ? task.dueDate!.toIso8601String()
              : 'no due date';
          final status = task.isCompleted ? 'completed' : 'pending';
          print(
            '- [${task.id}] ${task.title} (${task.priority}, due: $due, $status)',
          );
        }
        break;
      case 3:
        print("Marking a task as completed...");
        print("Enter the id of the task to mark as completed:");
        String idToMark = stdin.readLineSync() ?? '';
        try {
          await service.markTaskAsCompletedById(idToMark);
          print("Task $idToMark marked as completed!");
        } on TaskException catch (e) {
          print('Task error: ${e.message}');
        } catch (e) {
          print('Error: ${e.toString()}');
        }
        break;
      case 4:
        print("Removing a task...");
        print("Enter the id of the task to remove:");
        String idToRemove = stdin.readLineSync() ?? '';
        try {
          await service.removeTaskById(idToRemove);
          print('Task $idToRemove removed successfully.');
        } on TaskException catch (e) {
          print('Task error: ${e.message}');
        } catch (e) {
          print('Error: ${e.toString()}');
        }
        break;
      case 5:
        print("Exiting the application. Goodbye!");
        exit = 5;
        break;
      default:
        print("Invalid option. Please choose a number from the menu.");
    }
  }
}
