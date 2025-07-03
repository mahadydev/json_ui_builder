import '../utils/id_generator.dart';

/// Represents a widget configuration that can be serialized to/from JSON.
class WidgetConfig {
  /// Creates a new widget configuration.
  WidgetConfig({
    required this.type,
    String? id,
    Map<String, dynamic>? properties,
    this.child,
    this.children,
  }) : id = id ?? IdGenerator.generateId(prefix: type.toLowerCase()),
       properties = properties ?? <String, dynamic>{};

  /// The widget type (e.g., 'Container', 'Text', 'Column').
  final String type;

  /// Unique identifier for this widget.
  final String id;

  /// Properties/attributes of the widget.
  final Map<String, dynamic> properties;

  /// Single child widget (for widgets that accept one child).
  WidgetConfig? child;

  /// Multiple child widgets (for widgets that accept multiple children).
  List<WidgetConfig>? children;

  /// Creates a widget configuration from JSON.
  factory WidgetConfig.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final id = json['id'] as String?;
    final properties = Map<String, dynamic>.from(json['properties'] ?? {});

    WidgetConfig? child;
    if (json['child'] != null) {
      child = WidgetConfig.fromJson(json['child'] as Map<String, dynamic>);
    }

    List<WidgetConfig>? children;
    if (json['children'] != null) {
      children = (json['children'] as List)
          .map(
            (childJson) =>
                WidgetConfig.fromJson(childJson as Map<String, dynamic>),
          )
          .toList();
    }

    return WidgetConfig(
      type: type,
      id: id,
      properties: properties,
      child: child,
      children: children,
    );
  }

  /// Converts the widget configuration to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type,
      'id': id,
      'properties': properties,
    };

    if (child != null) {
      json['child'] = child!.toJson();
    }

    if (children != null && children!.isNotEmpty) {
      json['children'] = children!.map((child) => child.toJson()).toList();
    }

    return json;
  }

  /// Creates a copy of this widget configuration with optional modifications.
  WidgetConfig copyWith({
    String? type,
    String? id,
    Map<String, dynamic>? properties,
    WidgetConfig? child,
    List<WidgetConfig>? children,
  }) {
    return WidgetConfig(
      type: type ?? this.type,
      id: id ?? this.id,
      properties: properties ?? Map<String, dynamic>.from(this.properties),
      child: child ?? this.child?.copyWith(),
      children: children ?? this.children?.map((c) => c.copyWith()).toList(),
    );
  }

  /// Gets a property value with type safety.
  T? getProperty<T>(String key, [T? defaultValue]) {
    final value = properties[key];
    if (value is T) return value;
    return defaultValue;
  }

  /// Sets a property value.
  void setProperty(String key, dynamic value) {
    properties[key] = value;
  }

  /// Removes a property.
  void removeProperty(String key) {
    properties.remove(key);
  }

  /// Checks if the widget has a specific property.
  bool hasProperty(String key) {
    return properties.containsKey(key);
  }

  /// Adds a child widget (for multi-child widgets).
  void addChild(WidgetConfig child) {
    children ??= <WidgetConfig>[];
    children!.add(child);
  }

  /// Removes a child widget by ID.
  bool removeChild(String childId) {
    if (children == null) return false;

    final index = children!.indexWhere((child) => child.id == childId);
    if (index != -1) {
      children!.removeAt(index);
      return true;
    }
    return false;
  }

  /// Inserts a child widget at a specific index.
  void insertChild(int index, WidgetConfig child) {
    children ??= <WidgetConfig>[];
    children!.insert(index, child);
  }

  /// Gets the number of children.
  int get childCount => children?.length ?? 0;

  /// Checks if this widget accepts multiple children.
  bool get acceptsMultipleChildren => children != null;

  /// Checks if this widget accepts a single child.
  bool get acceptsSingleChild => child != null;

  @override
  String toString() {
    return 'WidgetConfig(type: $type, id: $id, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WidgetConfig &&
        other.type == type &&
        other.id == id &&
        _mapEquals(other.properties, properties) &&
        other.child == child &&
        _listEquals(other.children, children);
  }

  @override
  int get hashCode {
    return type.hashCode ^
        id.hashCode ^
        properties.hashCode ^
        child.hashCode ^
        children.hashCode;
  }

  /// Helper method to compare maps.
  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  /// Helper method to compare lists.
  bool _listEquals(List<WidgetConfig>? a, List<WidgetConfig>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
