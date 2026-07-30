import '../errors/task_exception.dart';
import '../models/priority.dart';

String parseRequiredText(String? input, String fieldName) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) {
    throw InvalidInputException('$fieldName ne peut pas être vide.');
  }
  return value;
}

Priority parsePriority(String input) {
  switch (input.trim().toLowerCase()) {
    case 'low':
      return Priority.low;
    case 'medium':
      return Priority.medium;
    case 'high':
      return Priority.high;
    default:
      throw InvalidInputException(
        'Priorité invalide. Choisissez low, medium ou high.',
      );
  }
}

DateTime? parseDueDate(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  try {
    return DateTime.parse(trimmed);
  } catch (_) {
    throw InvalidInputException(
      'Format de date invalide. Utilisez YYYY-MM-DD.',
    );
  }
}
