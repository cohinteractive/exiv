import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/models.dart';

class RawLoader {
  /// Loads a ChatGPT raw JSON export [file] and returns parsed conversations.
  static Future<List<Conversation>> loadRawJson(File file) async {
    try {
      final text = await file.readAsString();
      final dynamic data = jsonDecode(text);

      dynamic convData;
      if (data is Map && data.containsKey('mapping')) {
        convData = [data];
      } else if (data is Map && data.containsKey('conversations')) {
        convData = data['conversations'];
      } else if (data is List) {
        convData = data;
      } else {
        throw FormatException('Unknown ChatGPT export structure');
      }

      if (convData is! List) {
        throw FormatException('Invalid conversations list');
      }

      final parsed = <Conversation>[];
      for (final conv in convData) {
        if (conv is! Map) continue;
        if (!conv.containsKey('title') || !conv.containsKey('mapping')) {
          continue;
        }
        final ctRaw = conv['create_time'] ?? conv['createTime'];
        if (ctRaw == null) {
          continue;
        }

        final id = conv['id']?.toString() ?? '';
        final title = conv['title']?.toString() ?? 'Untitled';
        final timestamp = ctRaw is num
            ? DateTime.fromMillisecondsSinceEpoch((ctRaw * 1000).toInt())
            : DateTime.tryParse(ctRaw.toString()) ?? DateTime.now();

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

        final exchanges = <Exchange>[];
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
            exchanges.add(Exchange(
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
        parsed.add(Conversation(
            id: id, title: title, timestamp: timestamp, exchanges: exchanges));
      }

      return parsed;
    } catch (e, stack) {
      debugPrint('Error loading raw JSON: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }
}

