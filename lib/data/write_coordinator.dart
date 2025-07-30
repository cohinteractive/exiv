import 'package:flutter/foundation.dart';

/// Identifier for tracing write operations.
class WriteKey {
  final String value;
  const WriteKey(this.value);

  @override
  String toString() => value;
}

/// Placeholder utility coordinating backend writes.
class WriteCoordinator {
  Future<void> submit(
    WriteKey key,
    String path,
    Map<String, dynamic> data,
  ) async {
    debugPrint('Write: $path key=${key.value} data=$data');
    // In a real implementation this would persist to Firestore or another store.
  }
}

/// Minimal stand-in for Firestore's FieldValue.serverTimestamp().
class FieldValue {
  const FieldValue._();

  static DateTime serverTimestamp() => DateTime.now();
}
