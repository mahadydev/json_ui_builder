import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../core/widget_builder.dart' as ui_builder;
import '../parsers/property_parser.dart';
import '../exceptions/json_ui_exceptions.dart';

/// Core widget parser that handles parsing of WidgetConfig into Flutter widgets.
class WidgetParser {
  /// Parses a child widget from WidgetConfig.
  static Widget? parseChild(WidgetConfig config) {
    if (config.child == null) return null;
    return ui_builder.WidgetBuilder.build(config.child!);
  }

  /// Parses multiple children widgets from WidgetConfig.
  static List<Widget> parseChildren(WidgetConfig config) {
    if (config.children == null || config.children!.isEmpty) {
      return <Widget>[];
    }

    return config.children!
        .map((childConfig) => ui_builder.WidgetBuilder.build(childConfig))
        .toList();
  }

  /// Parses an optional child widget with fallback.
  static Widget parseChildWithFallback(WidgetConfig config, Widget fallback) {
    final child = parseChild(config);
    return child ?? fallback;
  }

  /// Parses children with minimum count validation.
  static List<Widget> parseChildrenWithMinCount(
    WidgetConfig config,
    int minCount,
  ) {
    final children = parseChildren(config);

    if (children.length < minCount) {
      throw PropertyValidationException(
        'children',
        'Expected at least $minCount children, got ${children.length}',
      );
    }

    return children;
  }

  /// Parses children with exact count validation.
  static List<Widget> parseChildrenWithExactCount(
    WidgetConfig config,
    int exactCount,
  ) {
    final children = parseChildren(config);

    if (children.length != exactCount) {
      throw PropertyValidationException(
        'children',
        'Expected exactly $exactCount children, got ${children.length}',
      );
    }

    return children;
  }

  /// Parses children with maximum count validation.
  static List<Widget> parseChildrenWithMaxCount(
    WidgetConfig config,
    int maxCount,
  ) {
    final children = parseChildren(config);

    if (children.length > maxCount) {
      throw PropertyValidationException(
        'children',
        'Expected at most $maxCount children, got ${children.length}',
      );
    }

    return children;
  }

  /// Creates a SizedBox with parsed dimensions.
  static Widget parseSizedBox(WidgetConfig config) {
    final width = PropertyParser.parseDimension(config, 'width');
    final height = PropertyParser.parseDimension(config, 'height');
    final child = parseChild(config);

    return SizedBox(width: width, height: height, child: child);
  }

  /// Creates a Container with parsed properties.
  static Widget parseContainer(WidgetConfig config) {
    final width = PropertyParser.parseDimension(config, 'width');
    final height = PropertyParser.parseDimension(config, 'height');
    final color = PropertyParser.parseColor(config, 'color');
    final padding = PropertyParser.parseEdgeInsets(config, 'padding');
    final margin = PropertyParser.parseEdgeInsets(config, 'margin');
    final alignment = PropertyParser.parseAlignment(config, 'alignment');
    final decoration = PropertyParser.parseBoxDecoration(config, 'decoration');
    final child = parseChild(config);

    return Container(
      width: width,
      height: height,
      color: decoration == null ? color : null,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: decoration,
      child: child,
    );
  }

  /// Creates a Padding widget with parsed properties.
  static Widget parsePadding(WidgetConfig config) {
    final padding =
        PropertyParser.parseEdgeInsets(config, 'padding') ?? EdgeInsets.zero;
    final child = parseChild(config) ?? const SizedBox.shrink();

    return Padding(padding: padding, child: child);
  }

  /// Creates a Center widget.
  static Widget parseCenter(WidgetConfig config) {
    final child = parseChild(config);

    return Center(child: child);
  }

  /// Creates an Align widget with parsed properties.
  static Widget parseAlign(WidgetConfig config) {
    final alignment =
        PropertyParser.parseAlignment(config, 'alignment') ?? Alignment.center;
    final child = parseChild(config);

    return Align(alignment: alignment, child: child);
  }

  /// Creates an Expanded widget with parsed properties.
  static Widget parseExpanded(WidgetConfig config) {
    final flex = PropertyParser.parseInt(config, 'flex') ?? 1;
    final child = parseChild(config) ?? const SizedBox.shrink();

    return Expanded(flex: flex, child: child);
  }

  /// Creates a Flexible widget with parsed properties.
  static Widget parseFlexible(WidgetConfig config) {
    final flex = PropertyParser.parseInt(config, 'flex') ?? 1;
    final fit = _parseFlexFit(config.getProperty<String>('fit'));
    final child = parseChild(config) ?? const SizedBox.shrink();

    return Flexible(flex: flex, fit: fit, child: child);
  }

  /// Parses FlexFit from string.
  static FlexFit _parseFlexFit(String? value) {
    if (value == null) return FlexFit.loose;

    switch (value.toLowerCase()) {
      case 'tight':
        return FlexFit.tight;
      case 'loose':
        return FlexFit.loose;
      default:
        return FlexFit.loose;
    }
  }

  /// Creates a Positioned widget for Stack children.
  static Widget parsePositioned(WidgetConfig config) {
    final top = PropertyParser.parseDouble(config, 'top');
    final right = PropertyParser.parseDouble(config, 'right');
    final bottom = PropertyParser.parseDouble(config, 'bottom');
    final left = PropertyParser.parseDouble(config, 'left');
    final width = PropertyParser.parseDouble(config, 'width');
    final height = PropertyParser.parseDouble(config, 'height');
    final child = parseChild(config) ?? const SizedBox.shrink();

    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Validates required properties for a widget type.
  static void validateRequiredProperties(
    WidgetConfig config,
    List<String> requiredProperties,
  ) {
    for (final property in requiredProperties) {
      if (!config.hasProperty(property)) {
        throw MissingPropertyException(property, config.type);
      }
    }
  }

  /// Validates widget has child or children as required.
  static void validateChildRequirement(
    WidgetConfig config, {
    bool requiresChild = false,
    bool requiresChildren = false,
  }) {
    if (requiresChild && config.child == null) {
      throw PropertyValidationException(
        'child',
        'Widget ${config.type} requires a child',
      );
    }

    if (requiresChildren &&
        (config.children == null || config.children!.isEmpty)) {
      throw PropertyValidationException(
        'children',
        'Widget ${config.type} requires children',
      );
    }
  }
}
