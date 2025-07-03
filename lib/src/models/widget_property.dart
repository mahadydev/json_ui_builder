/// Represents a widget property with type information and validation.
class WidgetProperty {
  const WidgetProperty({
    required this.name,
    required this.type,
    this.defaultValue,
    this.isRequired = false,
    this.description,
    this.validator,
  });

  /// The name of the property.
  final String name;

  /// The type of the property (e.g., 'String', 'double', 'Color', 'EdgeInsets').
  final String type;

  /// Default value for the property.
  final dynamic defaultValue;

  /// Whether this property is required.
  final bool isRequired;

  /// Description of what this property does.
  final String? description;

  /// Custom validator function for the property value.
  final bool Function(dynamic value)? validator;

  /// Validates if a value is valid for this property.
  bool isValid(dynamic value) {
    if (value == null) {
      return !isRequired;
    }

    // Use custom validator if provided
    if (validator != null) {
      return validator!(value);
    }

    // Default type validation
    return _validateByType(value);
  }

  bool _validateByType(dynamic value) {
    switch (type.toLowerCase()) {
      case 'string':
        return value is String;
      case 'int':
      case 'integer':
        return value is int || (value is String && int.tryParse(value) != null);
      case 'double':
      case 'number':
        return value is num ||
            (value is String && double.tryParse(value) != null);
      case 'bool':
      case 'boolean':
        return value is bool || value == 'true' || value == 'false';
      case 'color':
        if (value is String) {
          final hexPattern = RegExp(r'^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$');
          return hexPattern.hasMatch(value);
        }
        return false;
      case 'edgeinsets':
      case 'padding':
      case 'margin':
        return value is num ||
            value is Map<String, dynamic> ||
            (value is List && value.isNotEmpty);
      case 'alignment':
        if (value is String) {
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
          return validAlignments.contains(value);
        }
        return false;
      case 'mainaxisalignment':
        if (value is String) {
          const validAlignments = [
            'start',
            'end',
            'center',
            'spaceBetween',
            'spaceAround',
            'spaceEvenly',
          ];
          return validAlignments.contains(value);
        }
        return false;
      case 'crossaxisalignment':
        if (value is String) {
          const validAlignments = [
            'start',
            'end',
            'center',
            'stretch',
            'baseline',
          ];
          return validAlignments.contains(value);
        }
        return false;
      case 'list':
        return value is List;
      case 'map':
      case 'object':
        return value is Map;
      default:
        return true; // Unknown types are considered valid
    }
  }

  /// Gets the typed value, converting if necessary.
  T? getTypedValue<T>(dynamic value) {
    if (value == null) return defaultValue as T?;

    if (value is T) return value;

    // Try to convert common types
    switch (type.toLowerCase()) {
      case 'int':
      case 'integer':
        if (value is String) return int.tryParse(value) as T?;
        if (value is double) return value.toInt() as T?;
        break;
      case 'double':
      case 'number':
        if (value is String) return double.tryParse(value) as T?;
        if (value is int) return value.toDouble() as T?;
        break;
      case 'bool':
      case 'boolean':
        if (value is String) {
          if (value.toLowerCase() == 'true') return true as T?;
          if (value.toLowerCase() == 'false') return false as T?;
        }
        break;
      case 'string':
        return value.toString() as T?;
    }

    return defaultValue as T?;
  }

  @override
  String toString() {
    return 'WidgetProperty(name: $name, type: $type, required: $isRequired)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WidgetProperty &&
        other.name == name &&
        other.type == type &&
        other.defaultValue == defaultValue &&
        other.isRequired == isRequired &&
        other.description == description;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        defaultValue.hashCode ^
        isRequired.hashCode ^
        description.hashCode;
  }
}

/// Predefined widget properties for common use cases.
class CommonProperties {
  static const width = WidgetProperty(
    name: 'width',
    type: 'double',
    description: 'The width of the widget',
  );

  static const height = WidgetProperty(
    name: 'height',
    type: 'double',
    description: 'The height of the widget',
  );

  static const color = WidgetProperty(
    name: 'color',
    type: 'color',
    description: 'The color of the widget',
  );

  static const padding = WidgetProperty(
    name: 'padding',
    type: 'edgeinsets',
    description: 'The padding inside the widget',
  );

  static const margin = WidgetProperty(
    name: 'margin',
    type: 'edgeinsets',
    description: 'The margin outside the widget',
  );

  static const alignment = WidgetProperty(
    name: 'alignment',
    type: 'alignment',
    description: 'The alignment of the widget',
  );

  static const text = WidgetProperty(
    name: 'text',
    type: 'string',
    isRequired: true,
    description: 'The text to display',
  );

  static const fontSize = WidgetProperty(
    name: 'fontSize',
    type: 'double',
    defaultValue: 14.0,
    description: 'The size of the text',
  );

  static const fontWeight = WidgetProperty(
    name: 'fontWeight',
    type: 'string',
    defaultValue: 'normal',
    description: 'The weight of the text font',
  );

  static const mainAxisAlignment = WidgetProperty(
    name: 'mainAxisAlignment',
    type: 'mainaxisalignment',
    defaultValue: 'start',
    description: 'How to align children along the main axis',
  );

  static const crossAxisAlignment = WidgetProperty(
    name: 'crossAxisAlignment',
    type: 'crossaxisalignment',
    defaultValue: 'center',
    description: 'How to align children along the cross axis',
  );
}
