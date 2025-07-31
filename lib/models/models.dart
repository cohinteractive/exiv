class Vault {
  final String name;
  final List<Conversation> conversations;
  Vault({required this.name, required this.conversations});
}

class Conversation {
  final String title;
  final DateTime timestamp;
  Conversation({required this.title, required this.timestamp});
}
