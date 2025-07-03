import 'dart:convert';
import '../models/widget_config.dart';
import '../utils/validation_utils.dart';
import '../exceptions/json_ui_exceptions.dart';

/// Converts JSON to WidgetConfig objects.
class JsonToWidgetConverter {
  /// Converts JSON (string or Map) to WidgetConfig.
  WidgetConfig convert(dynamic json) {
    Map<String, dynamic> jsonMap;

    if (json is String) {
      try {
        jsonMap = jsonDecode(json) as Map<String, dynamic>;
      } catch (e) {
        throw JsonParsingException('Invalid JSON string: $e');
      }
    } else if (json is Map<String, dynamic>) {
      jsonMap = json;
    } else {
      throw JsonParsingException(
        'JSON must be a string or Map<String, dynamic>',
      );
    }

    return _convertToWidgetConfig(jsonMap);
  }

  /// Converts multiple JSON configurations to WidgetConfig objects.
  List<WidgetConfig> convertList(List<dynamic> jsonList) {
    return jsonList.map((json) => convert(json)).toList();
  }

  WidgetConfig _convertToWidgetConfig(Map<String, dynamic> json) {
    // Validate required fields
    ValidationUtils.validateWidgetType(json);

    try {
      return WidgetConfig.fromJson(json);
    } catch (e) {
      throw JsonParsingException('Failed to parse widget configuration: $e');
    }
  }

  /// Validates JSON structure without converting.
  bool validate(dynamic json) {
    try {
      convert(json);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets validation errors without throwing exceptions.
  List<String> getValidationErrors(dynamic json) {
    final errors = <String>[];

    try {
      convert(json);
    } catch (e) {
      if (e is JsonUIException) {
        errors.add(e.message);
      } else {
        errors.add(e.toString());
      }
    }

    return errors;
  }
}
