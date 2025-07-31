import 'dart:convert';
import 'dart:io';

import '../models/raw/raw_conversation.dart';
import '../models/raw/raw_exchange.dart';
import 'raw_memory_service.dart';

class RawLoader {
  /// Loads a ChatGPT raw JSON export [file] into memory.
  static Future<void> loadRawJson(File file) async {
    final text = await file.readAsString();
    final dynamic data = jsonDecode(text);
    if (data is! Map || !data.containsKey('conversations')) {
      throw FormatException('Invalid ChatGPT export structure');
    }
    final convList = data['conversations'];
    if (convList is! List) {
      throw FormatException('Invalid conversations list');
    }
    final parsed = <RawConversation>[];
    for (final conv in convList) {
      if (conv is! Map) continue;
      final id = conv['id']?.toString() ?? '';
      final title = conv['title']?.toString() ?? 'Untitled';
      final tsNum = conv['create_time'];
      final timestamp = tsNum is num
          ? DateTime.fromMillisecondsSinceEpoch((tsNum * 1000).toInt())
          : DateTime.now();
      final mapping = conv['mapping'];
      if (mapping is! Map) continue;
      final messages = mapping.values
          .whereType<Map>()
          .where((m) => m['message'] != null)
          .toList();
      messages.sort((a, b) {
        final ta = a['message']['create_time'] ?? 0;
        final tb = b['message']['create_time'] ?? 0;
        if (ta is num && tb is num) return ta.compareTo(tb);
        return 0;
      });

      final exchanges = <RawExchange>[];
      String? prompt;
      String? idHolder;
      DateTime? tsHolder;
      for (final msg in messages) {
        final message = msg['message'];
        final role = message['author']?['role'];
        final parts = message['content']?['parts'];
        final text =
            (parts is List && parts.isNotEmpty) ? parts.first.toString() : '';
        final timeNum = message['create_time'];
        final msgTime = timeNum is num
            ? DateTime.fromMillisecondsSinceEpoch((timeNum * 1000).toInt())
            : DateTime.now();
        if (role == 'user') {
          prompt = text;
          idHolder = message['id']?.toString() ?? msg['id']?.toString();
          tsHolder = msgTime;
        } else if (role == 'assistant' && prompt != null) {
          exchanges.add(RawExchange(
            id: idHolder ?? message['id']?.toString() ?? '',
            prompt: prompt,
            response: text,
            timestamp: tsHolder ?? msgTime,
          ));
          prompt = null;
          idHolder = null;
          tsHolder = null;
        }
      }
      parsed.add(RawConversation(
          id: id, title: title, timestamp: timestamp, exchanges: exchanges));
    }

    final memory = RawMemoryService.instance;
    memory.clear();
    memory.addAll(parsed);
  }
}
