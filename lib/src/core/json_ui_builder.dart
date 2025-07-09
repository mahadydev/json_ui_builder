import 'package:flutter/material.dart';
import 'package:json_ui_builder/src/widgets/dropTarget_widget.dart';

import '../converters/json_to_widget_converter.dart';
import '../converters/widget_to_json_converter.dart';
import '../exceptions/json_ui_exceptions.dart';
import '../models/widget_config.dart';
import '../utils/widget_utils.dart';
import '../widgets/button_widgets.dart';
import '../widgets/image_widgets.dart';
import '../widgets/input_widgets.dart';
// Import all widget builders to register them
import '../widgets/layout_widgets.dart';
import '../widgets/material_widgets.dart';
import '../widgets/scrollable_widgets.dart';
import '../widgets/text_widgets.dart';
import 'widget_builder.dart' as widget_builder;

/// Main class for JSON UI Builder package.
/// Provides methods for converting between JSON and Flutter widgets.
class JsonUIBuilder {
  static final JsonUIBuilder _instance = JsonUIBuilder._internal();
  factory JsonUIBuilder() => _instance;
  JsonUIBuilder._internal() {
    _initialize();
  }

  late final JsonToWidgetConverter _jsonToWidgetConverter;
  late final WidgetToJsonConverter _widgetToJsonConverter;
  bool _initialized = false;

  /// Initializes the JSON UI Builder with default widget builders.
  void _initialize() {
    if (_initialized) return;

    _jsonToWidgetConverter = JsonToWidgetConverter();
    _widgetToJsonConverter = WidgetToJsonConverter();

    // Register all default widget builders
    LayoutWidgets.register();
    TextWidgets.register();
    ButtonWidgets.register();
    InputWidgets.register();
    MaterialWidgets.register();
    ScrollableWidgets.register();
    ImageWidgets.register();

    widget_builder.WidgetBuilder.registry.registerWidget(
      'DropTarget',
      (config) => DropTargetWidget(
        config: config, // Now config is WidgetConfig
        child: config.child != null
            ? buildFromConfig(config.child!)
            : const SizedBox.shrink(),
        // onDrop: ... (set up as needed)
      ),
      ['child'],
    );

    _initialized = true;
  }

  /// Builds a Flutter widget from JSON configuration.
  ///
  // ignore: unintended_html_in_doc_comment
  /// [json] can be either a Map<String, dynamic> or a JSON string.
  /// Returns the built widget.
  Widget buildFromJson(dynamic json) {
    try {
      final config = _jsonToWidgetConverter.convert(json);
      return widget_builder.WidgetBuilder.build(config);
    } catch (e) {
      throw JsonParsingException('Failed to build widget from JSON: $e');
    }
  }

  /// Builds a Flutter widget from WidgetConfig.
  Widget buildFromConfig(WidgetConfig config) {
    return widget_builder.WidgetBuilder.build(config);
  }

  /// Converts a WidgetConfig to JSON.
  Map<String, dynamic> configToJson(WidgetConfig config) {
    return _widgetToJsonConverter.convert(config);
  }

  /// Converts JSON to WidgetConfig.
  WidgetConfig jsonToConfig(dynamic json) {
    return _jsonToWidgetConverter.convert(json);
  }

  /// Validates a JSON configuration.
  bool validateJson(dynamic json) {
    try {
      _jsonToWidgetConverter.convert(json);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets validation errors for a JSON configuration.
  List<String> getValidationErrors(dynamic json) {
    final errors = <String>[];
    try {
      _jsonToWidgetConverter.convert(json);
    } catch (e) {
      if (e is JsonUIException) {
        errors.add(e.message);
      } else {
        errors.add(e.toString());
      }
    }
    return errors;
  }

  /// Finds a widget by ID in the widget tree.
  WidgetConfig? findWidgetById(WidgetConfig root, String id) {
    return WidgetUtils.findWidgetById(root, id);
  }

  /// Updates a widget by ID in the widget tree.
  bool updateWidgetById(WidgetConfig root, String id, WidgetConfig newConfig) {
    return WidgetUtils.updateWidgetById(root, id, newConfig);
  }

  /// Removes a widget by ID from the widget tree.
  bool removeWidgetById(WidgetConfig root, String id) {
    return WidgetUtils.removeWidgetById(root, id);
  }

  /// Gets all widget IDs from a widget tree.
  Set<String> getAllWidgetIds(WidgetConfig root) {
    return WidgetUtils.extractAllIds(root);
  }

  /// Registers a custom widget builder.
  void registerCustomWidget(
    String type,
    Widget Function(WidgetConfig) builder,
    List<String> supportedProperties,
  ) {
    widget_builder.WidgetBuilder.registry.registerWidget(
      type,
      builder,
      supportedProperties,
    );
  }

  /// Gets all supported widget types.
  List<String> getSupportedWidgetTypes() {
    return widget_builder.WidgetBuilder.registry.getSupportedTypes();
  }

  /// Gets supported properties for a widget type.
  List<String> getSupportedProperties(String widgetType) {
    return widget_builder.WidgetBuilder.registry.getSupportedProperties(
      widgetType,
    );
  }

  /// Checks if a widget type is supported.
  bool isWidgetTypeSupported(String type) {
    return widget_builder.WidgetBuilder.registry.isSupported(type);
  }

  /// Creates a new widget configuration with validation.
  WidgetConfig createWidgetConfig({
    required String type,
    String? id,
    Map<String, dynamic>? properties,
    WidgetConfig? child,
    List<WidgetConfig>? children,
  }) {
    if (!isWidgetTypeSupported(type)) {
      throw UnsupportedWidgetException(type);
    }

    final config = WidgetConfig(
      type: type,
      id: id,
      properties: properties,
      child: child,
      children: children,
    );

    // Validate the configuration
    final errors = getValidationErrors(config.toJson());
    if (errors.isNotEmpty) {
      throw PropertyValidationException('configuration', errors.join(', '));
    }

    return config;
  }

  /// Builds a widget with error handling and debug information.
  Widget buildSafe(
    WidgetConfig config, {
    Widget? fallback,
    bool showDebugInfo = false,
  }) {
    if (showDebugInfo) {
      return widget_builder.WidgetBuilder.buildWithDebug(
        config,
        showDebugInfo: true,
      );
    }
    return widget_builder.WidgetBuilder.buildSafe(config, fallback: fallback);
  }

  /// Gets package statistics and information.
  Map<String, dynamic> getPackageInfo() {
    final stats = widget_builder.WidgetBuilder.registry.getStats();
    return {
      'version': '0.0.1',
      'initialized': _initialized,
      'supported_widgets': stats['registered_widgets'],
      'total_properties': stats['total_properties'],
      'widget_types': getSupportedWidgetTypes(),
    };
  }

  /// Resets the builder (mainly for testing).
  void reset() {
    widget_builder.WidgetBuilder.registry.clear();
    _initialized = false;
    _initialize();
  }
}
