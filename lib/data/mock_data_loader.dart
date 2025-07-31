import '../models/models.dart';

/// Provides mock vault and conversation data for development.
class MockDataLoader {
  /// Returns a list of [Vault] objects populated with mock conversations.
  static List<Vault> load() {
    final now = DateTime.now();
    return [
      Vault(name: 'Vault A', conversations: [
        Conversation(title: 'Conversation A1', timestamp: now.subtract(const Duration(days: 1))),
        Conversation(title: 'Conversation A2', timestamp: now.subtract(const Duration(days: 2))),
      ]),
      Vault(name: 'Vault B', conversations: [
        Conversation(title: 'Conversation B1', timestamp: now.subtract(const Duration(days: 3))),
      ]),
    ];
  }
}
