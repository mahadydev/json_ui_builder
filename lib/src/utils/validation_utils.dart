import '../exceptions/json_ui_exceptions.dart';

/// Validation utilities for JSON UI Builder.
class ValidationUtils {
  /// Validates if a JSON map has the required 'type' property.
  static void validateWidgetType(Map<String, dynamic> json) {
    if (!json.containsKey('type') || json['type'] == null) {
      throw const JsonParsingException(
        'Widget configuration must have a "type" property',
      );
    }

    if (json['type'] is! String || (json['type'] as String).isEmpty) {
      throw const JsonParsingException(
        'Widget "type" must be a non-empty string',
      );
    }
  }

  /// Validates if a widget ID is unique within the widget tree.
  static void validateUniqueId(String id, Set<String> existingIds) {
    if (existingIds.contains(id)) {
      throw WidgetIdException('Widget ID "$id" is not unique');
    }
  }

  /// Validates color string format (hex colors).
  static bool isValidColor(String color) {
    if (color.isEmpty) return false;

    // Support hex colors with or without #
    final hexPattern = RegExp(r'^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$');
    return hexPattern.hasMatch(color);
  }

  /// Validates numeric values.
  static bool isValidNumber(dynamic value) {
    if (value == null) return false;
    if (value is num) return true;
    if (value is String) {
      return double.tryParse(value) != null;
    }
    return false;
  }

  /// Validates dimension values (numbers, percentages, or 'auto').
  static bool isValidDimension(dynamic value) {
    if (value == null) return false;
    if (value == 'auto') return true;
    if (value is num) return value >= 0;
    if (value is String) {
      if (value == 'auto') return true;
      if (value.endsWith('%')) {
        final numStr = value.substring(0, value.length - 1);
        final num = double.tryParse(numStr);
        return num != null && num >= 0;
      }
      final num = double.tryParse(value);
      return num != null && num >= 0;
    }
    return false;
  }

  /// Validates boolean values.
  static bool isValidBoolean(dynamic value) {
    return value is bool || value == 'true' || value == 'false';
  }

  /// Converts string boolean to actual boolean.
  static bool? parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    return null;
  }

  /// Validates alignment values.
  static bool isValidAlignment(String alignment) {
    const validAlignments = [
      'topLeft',
      'topCenter',
      'topRight',
      'centerLeft',
      'center',
      'centerRight',
      'bottomLeft',
      'bottomCenter',
      'bottomRight',
    ];
    return validAlignments.contains(alignment);
  }

  /// Validates main axis alignment values.
  static bool isValidMainAxisAlignment(String alignment) {
    const validAlignments = [
      'start',
      'end',
      'center',
      'spaceBetween',
      'spaceAround',
      'spaceEvenly',
    ];
    return validAlignments.contains(alignment);
  }

  /// Validates cross axis alignment values.
  static bool isValidCrossAxisAlignment(String alignment) {
    const validAlignments = ['start', 'end', 'center', 'stretch', 'baseline'];
    return validAlignments.contains(alignment);
  }
}
