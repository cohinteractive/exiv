
/// Represents a conversation item with a title and timestamp.
class Conversation {
  final String title;
  final DateTime timestamp;

  Conversation({required this.title, required this.timestamp});
}

/// Represents a vault containing a list of conversations.
class Vault {
  final String name;
  final List<Conversation> conversations;

  Vault({required this.name, required this.conversations});
}

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
