class Exchange {
  final String id;
  final String prompt;
  final String response;
  final DateTime timestamp;

  Exchange({
    required this.id,
    required this.prompt,
    required this.response,
    required this.timestamp,
  });
}

class Conversation {
  final String id;
  final String title;
  final DateTime timestamp;
  final List<Exchange> exchanges;

  Conversation({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.exchanges,
  });
}

class Vault {
  final String name;
  final List<Conversation> conversations;
  Vault({required this.name, required this.conversations});
}
