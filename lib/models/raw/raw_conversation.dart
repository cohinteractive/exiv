import "raw_exchange.dart";

class RawConversation {
  final String id;
  final String title;
  final DateTime timestamp;
  final List<RawExchange> exchanges;

  RawConversation({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.exchanges,
  });
}
