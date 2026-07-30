abstract class TaskException implements Exception {
  final String message;

  TaskException(this.message);

  @override
  String toString() => 'TaskException: $message';
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException(super.message);
}

class TaskStorageException extends TaskException {
  TaskStorageException(super.message);
}
