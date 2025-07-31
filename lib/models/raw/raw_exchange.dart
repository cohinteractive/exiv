class RawExchange {
  final String id;
  final String prompt;
  final String response;
  final DateTime timestamp;

  RawExchange({
    required this.id,
    required this.prompt,
    required this.response,
    required this.timestamp,
  });
}
