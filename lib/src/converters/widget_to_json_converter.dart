import 'dart:convert';
import '../models/widget_config.dart';

/// Converts WidgetConfig objects to JSON.
class WidgetToJsonConverter {
  /// Converts a WidgetConfig to JSON Map.
  Map<String, dynamic> convert(WidgetConfig config) {
    return config.toJson();
  }

  /// Converts a WidgetConfig to JSON string.
  String convertToString(WidgetConfig config, {bool pretty = false}) {
    final jsonMap = convert(config);

    if (pretty) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonMap);
    }

    return jsonEncode(jsonMap);
  }

  /// Converts multiple WidgetConfig objects to JSON array.
  List<Map<String, dynamic>> convertList(List<WidgetConfig> configs) {
    return configs.map((config) => convert(config)).toList();
  }

  /// Converts multiple WidgetConfig objects to JSON string array.
  String convertListToString(
    List<WidgetConfig> configs, {
    bool pretty = false,
  }) {
    final jsonList = convertList(configs);

    if (pretty) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonList);
    }

    return jsonEncode(jsonList);
  }

  /// Converts a widget tree to a flattened structure with references.
  Map<String, dynamic> convertToFlatStructure(WidgetConfig root) {
    final widgets = <String, Map<String, dynamic>>{};
    final references = <String, List<String>>{};

    _flattenRecursive(root, widgets, references);

    return {'root': root.id, 'widgets': widgets, 'references': references};
  }

  void _flattenRecursive(
    WidgetConfig config,
    Map<String, Map<String, dynamic>> widgets,
    Map<String, List<String>> references,
  ) {
    // Add current widget
    widgets[config.id] = {'type': config.type, 'properties': config.properties};

    final childIds = <String>[];

    // Handle single child
    if (config.child != null) {
      childIds.add(config.child!.id);
      _flattenRecursive(config.child!, widgets, references);
    }

    // Handle multiple children
    if (config.children != null) {
      for (final child in config.children!) {
        childIds.add(child.id);
        _flattenRecursive(child, widgets, references);
      }
    }

    if (childIds.isNotEmpty) {
      references[config.id] = childIds;
    }
  }

  /// Converts a flat structure back to hierarchical WidgetConfig.
  WidgetConfig convertFromFlatStructure(Map<String, dynamic> flatStructure) {
    final rootId = flatStructure['root'] as String;
    final widgets = flatStructure['widgets'] as Map<String, dynamic>;
    final references = flatStructure['references'] as Map<String, dynamic>?;

    return _buildHierarchical(rootId, widgets, references ?? {});
  }

  WidgetConfig _buildHierarchical(
    String id,
    Map<String, dynamic> widgets,
    Map<String, dynamic> references,
  ) {
    final widgetData = widgets[id] as Map<String, dynamic>;
    final childIds = references[id] as List<dynamic>?;

    WidgetConfig? child;
    List<WidgetConfig>? children;

    if (childIds != null && childIds.isNotEmpty) {
      if (childIds.length == 1) {
        child = _buildHierarchical(childIds[0] as String, widgets, references);
      } else {
        children = childIds
            .map(
              (childId) =>
                  _buildHierarchical(childId as String, widgets, references),
            )
            .toList();
      }
    }

    return WidgetConfig(
      type: widgetData['type'] as String,
      id: id,
      properties: Map<String, dynamic>.from(widgetData['properties'] as Map),
      child: child,
      children: children,
    );
  }
}
