import 'package:flutter/material.dart';
import '../core/widget_registry.dart';
import '../models/widget_config.dart';
import '../parsers/property_parser.dart';
import '../parsers/widget_parser.dart';

/// Layout widgets implementation for JSON UI Builder.
class LayoutWidgets {
  /// Registers all layout widgets with the widget registry.
  static void register() {
    final registry = WidgetRegistry();

    registry.registerWidget('Container', _buildContainer, [
      'width',
      'height',
      'color',
      'padding',
      'margin',
      'alignment',
      'decoration',
    ]);

    registry.registerWidget('Column', _buildColumn, [
      'mainAxisAlignment',
      'crossAxisAlignment',
      'mainAxisSize',
    ]);

    registry.registerWidget('Row', _buildRow, [
      'mainAxisAlignment',
      'crossAxisAlignment',
      'mainAxisSize',
    ]);

    registry.registerWidget('Stack', _buildStack, ['alignment', 'fit']);

    registry.registerWidget('Positioned', _buildPositioned, [
      'top',
      'right',
      'bottom',
      'left',
      'width',
      'height',
    ]);

    registry.registerWidget('Expanded', _buildExpanded, ['flex']);

    registry.registerWidget('Flexible', _buildFlexible, ['flex', 'fit']);

    registry.registerWidget('Wrap', _buildWrap, [
      'direction',
      'alignment',
      'spacing',
      'runSpacing',
    ]);

    registry.registerWidget('Center', _buildCenter, []);

    registry.registerWidget('Align', _buildAlign, ['alignment']);

    registry.registerWidget('Padding', _buildPadding, ['padding']);

    registry.registerWidget('SizedBox', _buildSizedBox, ['width', 'height']);
  }

  static Widget _buildContainer(WidgetConfig config) {
    final width = PropertyParser.parseDimension(config, 'width');
    final height = PropertyParser.parseDimension(config, 'height');
    final color = PropertyParser.parseColor(config, 'color');
    final padding = PropertyParser.parseEdgeInsets(config, 'padding');
    final margin = PropertyParser.parseEdgeInsets(config, 'margin');
    final alignment = PropertyParser.parseAlignment(config, 'alignment');
    final decoration = PropertyParser.parseBoxDecoration(config, 'decoration');
    final child = WidgetParser.parseChild(config);

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

  static Widget _buildColumn(WidgetConfig config) {
    final mainAxisAlignment = PropertyParser.parseMainAxisAlignment(
      config,
      'mainAxisAlignment',
    );
    final crossAxisAlignment = PropertyParser.parseCrossAxisAlignment(
      config,
      'crossAxisAlignment',
    );
    final mainAxisSize = PropertyParser.parseMainAxisSize(
      config,
      'mainAxisSize',
    );
    final children = WidgetParser.parseChildren(config);

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  static Widget _buildRow(WidgetConfig config) {
    final mainAxisAlignment = PropertyParser.parseMainAxisAlignment(
      config,
      'mainAxisAlignment',
    );
    final crossAxisAlignment = PropertyParser.parseCrossAxisAlignment(
      config,
      'crossAxisAlignment',
    );
    final mainAxisSize = PropertyParser.parseMainAxisSize(
      config,
      'mainAxisSize',
    );
    final children = WidgetParser.parseChildren(config);

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  static Widget _buildStack(WidgetConfig config) {
    final alignment =
        PropertyParser.parseAlignment(config, 'alignment') ??
        AlignmentDirectional.topStart;
    final fit = _parseStackFit(config.getProperty<String>('fit'));
    final children = WidgetParser.parseChildren(config);

    return Stack(alignment: alignment, fit: fit, children: children);
  }

  static Widget _buildPositioned(WidgetConfig config) {
    final top = PropertyParser.parseDouble(config, 'top');
    final right = PropertyParser.parseDouble(config, 'right');
    final bottom = PropertyParser.parseDouble(config, 'bottom');
    final left = PropertyParser.parseDouble(config, 'left');
    final width = PropertyParser.parseDouble(config, 'width');
    final height = PropertyParser.parseDouble(config, 'height');
    final child = WidgetParser.parseChild(config) ?? const SizedBox.shrink();

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

  static Widget _buildExpanded(WidgetConfig config) {
    final flex = PropertyParser.parseInt(config, 'flex') ?? 1;
    final child = WidgetParser.parseChild(config) ?? const SizedBox.shrink();

    return Expanded(flex: flex, child: child);
  }

  static Widget _buildFlexible(WidgetConfig config) {
    final flex = PropertyParser.parseInt(config, 'flex') ?? 1;
    final fit = _parseFlexFit(config.getProperty<String>('fit'));
    final child = WidgetParser.parseChild(config) ?? const SizedBox.shrink();

    return Flexible(flex: flex, fit: fit, child: child);
  }

  static Widget _buildWrap(WidgetConfig config) {
    final direction = _parseAxis(config.getProperty<String>('direction'));
    final alignment = _parseWrapAlignment(
      config.getProperty<String>('alignment'),
    );
    final spacing = PropertyParser.parseDouble(config, 'spacing') ?? 0.0;
    final runSpacing = PropertyParser.parseDouble(config, 'runSpacing') ?? 0.0;
    final children = WidgetParser.parseChildren(config);

    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      children: children,
    );
  }

  static Widget _buildCenter(WidgetConfig config) {
    final child = WidgetParser.parseChild(config);

    return Center(child: child);
  }

  static Widget _buildAlign(WidgetConfig config) {
    final alignment =
        PropertyParser.parseAlignment(config, 'alignment') ?? Alignment.center;
    final child = WidgetParser.parseChild(config);

    return Align(alignment: alignment, child: child);
  }

  static Widget _buildPadding(WidgetConfig config) {
    final padding =
        PropertyParser.parseEdgeInsets(config, 'padding') ?? EdgeInsets.zero;
    final child = WidgetParser.parseChild(config) ?? const SizedBox.shrink();

    return Padding(padding: padding, child: child);
  }

  static Widget _buildSizedBox(WidgetConfig config) {
    final width = PropertyParser.parseDimension(config, 'width');
    final height = PropertyParser.parseDimension(config, 'height');
    final child = WidgetParser.parseChild(config);

    return SizedBox(width: width, height: height, child: child);
  }

  // Helper methods for parsing enums

  static StackFit _parseStackFit(String? value) {
    if (value == null) return StackFit.loose;

    switch (value.toLowerCase()) {
      case 'loose':
        return StackFit.loose;
      case 'expand':
        return StackFit.expand;
      case 'passthrough':
        return StackFit.passthrough;
      default:
        return StackFit.loose;
    }
  }

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

  static Axis _parseAxis(String? value) {
    if (value == null) return Axis.horizontal;

    switch (value.toLowerCase()) {
      case 'horizontal':
        return Axis.horizontal;
      case 'vertical':
        return Axis.vertical;
      default:
        return Axis.horizontal;
    }
  }

  static WrapAlignment _parseWrapAlignment(String? value) {
    if (value == null) return WrapAlignment.start;

    switch (value.toLowerCase()) {
      case 'start':
        return WrapAlignment.start;
      case 'end':
        return WrapAlignment.end;
      case 'center':
        return WrapAlignment.center;
      case 'spaceBetween':
        return WrapAlignment.spaceBetween;
      case 'spaceAround':
        return WrapAlignment.spaceAround;
      case 'spaceEvenly':
        return WrapAlignment.spaceEvenly;
      default:
        return WrapAlignment.start;
    }
  }
}
