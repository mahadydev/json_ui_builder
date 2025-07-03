import 'package:flutter/material.dart';

import '../exceptions/json_ui_exceptions.dart';
import '../models/widget_config.dart';

/// Registry for managing widget builders and their configurations.
class WidgetRegistry {
  static final WidgetRegistry _instance = WidgetRegistry._internal();
  factory WidgetRegistry() => _instance;
  WidgetRegistry._internal();

  final Map<String, Widget Function(WidgetConfig)> _builders = {};
  final Map<String, List<String>> _supportedProperties = {};

  /// Registers a widget builder for a specific widget type.
  void registerWidget(
    String type,
    Widget Function(WidgetConfig) builder,
    List<String> supportedProperties,
  ) {
    _builders[type] = builder;
    _supportedProperties[type] = supportedProperties;
  }

  /// Gets a widget builder for the specified type.
  Widget Function(WidgetConfig)? getBuilder(String type) {
    return _builders[type];
  }

  /// Gets supported properties for a widget type.
  List<String> getSupportedProperties(String type) {
    return _supportedProperties[type] ?? [];
  }

  /// Checks if a widget type is supported.
  bool isSupported(String type) {
    return _builders.containsKey(type);
  }

  /// Gets all registered widget types.
  List<String> getSupportedTypes() {
    return _builders.keys.toList();
  }

  /// Builds a widget from configuration.
  Widget buildWidget(WidgetConfig config) {
    final builder = getBuilder(config.type);
    if (builder == null) {
      throw UnsupportedWidgetException(config.type);
    }

    try {
      return builder(config);
    } catch (e) {
      // Return error widget with debug information
      return _buildErrorWidget(config.type, e.toString());
    }
  }

  /// Builds an error widget to display when widget building fails.
  Widget _buildErrorWidget(String widgetType, String error) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 25),
        border: Border.all(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error: $widgetType',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(error, style: const TextStyle(color: Colors.red, fontSize: 10)),
        ],
      ),
    );
  }

  /// Clears all registered widgets (mainly for testing).
  void clear() {
    _builders.clear();
    _supportedProperties.clear();
  }

  /// Gets registry statistics.
  Map<String, int> getStats() {
    return {
      'registered_widgets': _builders.length,
      'total_properties': _supportedProperties.values.fold<int>(
        0,
        (sum, props) => sum + props.length,
      ),
    };
  }
}
