import '../models/models.dart';

/// Provides mock vault and conversation data for development.
class MockDataLoader {
  /// Returns a list of [Vault] objects populated with mock conversations.
  static List<Vault> load() {
    final now = DateTime.now();
    return [
      Vault(name: 'Vault A', conversations: [
        Conversation(
            id: 'a1',
            title: 'Conversation A1',
            timestamp: now.subtract(const Duration(days: 1)),
            exchanges: []),
        Conversation(
            id: 'a2',
            title: 'Conversation A2',
            timestamp: now.subtract(const Duration(days: 2)),
            exchanges: []),
      ]),
      Vault(name: 'Vault B', conversations: [
        Conversation(
            id: 'b1',
            title: 'Conversation B1',
            timestamp: now.subtract(const Duration(days: 3)),
            exchanges: []),
      ]),
    ];
  }
}
