import 'write_coordinator.dart';

/// Handles persistence of user tasks.
class TaskRepository {
  final WriteCoordinator coordinator;

  TaskRepository(this.coordinator);

  /// Marks the given task complete for [userId].
  Future<void> markComplete(String userId, String taskId) {
    final data = {
      'isCompleted': true,
      'completedAt': FieldValue.serverTimestamp(),
    };
    final key = WriteKey('completeTask:$taskId:$userId');
    final path = '/users/$userId/tasks/$taskId';
    return coordinator.submit(key, path, data);
  }
}
