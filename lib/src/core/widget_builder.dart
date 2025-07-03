import 'package:flutter/material.dart';

import '../models/widget_config.dart';
import 'widget_registry.dart';

/// Core widget builder that handles the conversion from WidgetConfig to Flutter widgets.
class WidgetBuilder {
  static final WidgetRegistry _registry = WidgetRegistry();

  /// Builds a widget from a WidgetConfig.
  static Widget build(WidgetConfig config) {
    return _registry.buildWidget(config);
  }

  /// Builds a widget tree from a root WidgetConfig.
  static Widget buildTree(WidgetConfig rootConfig) {
    return build(rootConfig);
  }

  /// Builds multiple widgets from a list of configurations.
  static List<Widget> buildList(List<WidgetConfig> configs) {
    return configs.map((config) => build(config)).toList();
  }

  /// Builds a widget with error handling and fallback.
  static Widget buildSafe(WidgetConfig config, {Widget? fallback}) {
    try {
      return build(config);
    } catch (e) {
      return fallback ?? _buildFallbackWidget(config, e.toString());
    }
  }

  /// Creates a fallback widget when building fails.
  static Widget _buildFallbackWidget(WidgetConfig config, String error) {
    return Container(
      width: 200,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Widget: ${config.type}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text('ID: ${config.id}', style: const TextStyle(fontSize: 10)),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red, fontSize: 10),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a widget with debug information overlay.
  static Widget buildWithDebug(
    WidgetConfig config, {
    bool showDebugInfo = false,
  }) {
    final widget = build(config);

    if (!showDebugInfo) return widget;

    return Stack(
      children: [
        widget,
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: (0.7 * 255)),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              '${config.type}[${config.id}]',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Gets the widget registry instance.
  static WidgetRegistry get registry => _registry;
}
