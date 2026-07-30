import 'package:test/test.dart';
import 'package:task_gest/src/errors/task_exception.dart';

void main() {
  test('TaskNotFoundException toString includes class name and message', () {
    final exception = TaskNotFoundException('Erreur de test');

    expect(exception.toString(), contains('TaskException: Erreur de test'));
  });

  test('TaskNotFoundException inherits TaskException', () {
    final exception = TaskNotFoundException('Tâche introuvable');

    expect(exception, isA<TaskException>());
    expect(exception.message, equals('Tâche introuvable'));
  });
}
