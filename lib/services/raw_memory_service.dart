import '../models/raw/raw_conversation.dart';

class RawMemoryService {
  RawMemoryService._();

  static final RawMemoryService instance = RawMemoryService._();

  final List<RawConversation> _conversations = [];

  List<RawConversation> get conversations => List.unmodifiable(_conversations);

  void clear() {
    _conversations.clear();
  }

  void addAll(List<RawConversation> convos) {
    _conversations.addAll(convos);
  }
}
