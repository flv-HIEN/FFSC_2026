import 'package:test/test.dart';
import 'package:task_gest/src/models/priority.dart';
import 'package:task_gest/src/utils/input_utils.dart';
import 'package:task_gest/src/errors/task_exception.dart';

void main() {
  test('parseRequiredText throws when input is null or blank', () {
    expect(
      () => parseRequiredText(null, 'Titre'),
      throwsA(isA<InvalidInputException>()),
    );

    expect(
      () => parseRequiredText('   ', 'Titre'),
      throwsA(isA<InvalidInputException>()),
    );
  });

  test('parsePriority accepts low, medium, high', () {
    expect(parsePriority('low'), equals(Priority.low));
    expect(parsePriority('MEDIUM'), equals(Priority.medium));
    expect(parsePriority('High'), equals(Priority.high));
  });

  test('parsePriority rejects invalid values', () {
    expect(
      () => parsePriority('urgent'),
      throwsA(isA<InvalidInputException>()),
    );
  });

  test('parseDueDate returns null for empty input and parses valid dates', () {
    expect(parseDueDate(''), isNull);
    expect(parseDueDate('2026-12-31'), equals(DateTime(2026, 12, 31)));
  });

  test('parseDueDate throws for invalid date format', () {
    expect(
      () => parseDueDate('31-12-2026'),
      throwsA(isA<InvalidInputException>()),
    );
  });
}
