/// Custom exceptions for JSON UI Builder package.
library;

/// Base exception class for JSON UI Builder.
abstract class JsonUIException implements Exception {
  const JsonUIException(this.message);

  final String message;

  @override
  String toString() => 'JsonUIException: $message';
}

/// Exception thrown when widget type is not supported.
class UnsupportedWidgetException extends JsonUIException {
  const UnsupportedWidgetException(String widgetType)
    : super('Unsupported widget type: $widgetType');
}

/// Exception thrown when JSON parsing fails.
class JsonParsingException extends JsonUIException {
  const JsonParsingException(String message)
    : super('JSON parsing failed: $message');
}

/// Exception thrown when widget property validation fails.
class PropertyValidationException extends JsonUIException {
  const PropertyValidationException(String property, String reason)
    : super('Property validation failed for $property: $reason');
}

/// Exception thrown when widget ID operations fail.
class WidgetIdException extends JsonUIException {
  const WidgetIdException(String message) : super('Widget ID error: $message');
}

/// Exception thrown when required property is missing.
class MissingPropertyException extends JsonUIException {
  const MissingPropertyException(String property, String widgetType)
    : super('Missing required property $property for widget type $widgetType');
}
