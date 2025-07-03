import 'dart:math';

/// Utility class for generating unique widget IDs.
class IdGenerator {
  static final Random _random = Random();
  static const String _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  /// Generates a unique widget ID with the specified prefix and length.
  static String generateId({String prefix = 'widget', int length = 8}) {
    final buffer = StringBuffer(prefix);
    buffer.write('_');

    for (int i = 0; i < length; i++) {
      buffer.write(_chars[_random.nextInt(_chars.length)]);
    }

    return buffer.toString();
  }

  /// Generates a timestamp-based ID for better uniqueness.
  static String generateTimestampId({String prefix = 'widget'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = _random.nextInt(9999).toString().padLeft(4, '0');
    return '${prefix}_${timestamp}_$randomSuffix';
  }

  /// Validates if an ID follows the expected format.
  static bool isValidId(String id) {
    if (id.isEmpty) return false;

    // Check if ID contains only valid characters
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
    return regex.hasMatch(id);
  }

  /// Ensures the ID is unique within the provided set of existing IDs.
  static String ensureUniqueId(String baseId, Set<String> existingIds) {
    if (!existingIds.contains(baseId)) {
      return baseId;
    }

    int counter = 1;
    String newId;
    do {
      newId = '${baseId}_$counter';
      counter++;
    } while (existingIds.contains(newId));

    return newId;
  }
}
