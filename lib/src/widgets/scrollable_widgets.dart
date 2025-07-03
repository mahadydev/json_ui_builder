import 'package:flutter/material.dart';

import '../core/widget_registry.dart';
import '../models/widget_config.dart';
import '../parsers/property_parser.dart';
import '../parsers/widget_parser.dart';

/// Scrollable widgets implementation for JSON UI Builder.
class ScrollableWidgets {
  /// Registers all scrollable widgets with the widget registry.
  static void register() {
    final registry = WidgetRegistry();

    registry.registerWidget('ListView', _buildListView, [
      'scrollDirection',
      'padding',
      'shrinkWrap',
      'itemCount',
    ]);

    registry.registerWidget('GridView', _buildGridView, [
      'scrollDirection',
      'padding',
      'crossAxisCount',
      'mainAxisSpacing',
      'crossAxisSpacing',
      'childAspectRatio',
    ]);

    registry.registerWidget(
      'SingleChildScrollView',
      _buildSingleChildScrollView,
      ['scrollDirection', 'padding'],
    );

    registry.registerWidget('PageView', _buildPageView, [
      'scrollDirection',
      'controller',
    ]);
  }

  static Widget _buildListView(WidgetConfig config) {
    final scrollDirection = _parseAxis(
      config.getProperty<String>('scrollDirection'),
    );
    final padding = PropertyParser.parseEdgeInsets(config, 'padding');
    final shrinkWrap = PropertyParser.parseBool(config, 'shrinkWrap');
    final children = WidgetParser.parseChildren(config);

    return ListView(
      scrollDirection: scrollDirection,
      padding: padding,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }

  static Widget _buildGridView(WidgetConfig config) {
    final scrollDirection = _parseAxis(
      config.getProperty<String>('scrollDirection'),
    );
    final padding = PropertyParser.parseEdgeInsets(config, 'padding');
    final crossAxisCount =
        PropertyParser.parseInt(config, 'crossAxisCount') ?? 2;
    final mainAxisSpacing =
        PropertyParser.parseDouble(config, 'mainAxisSpacing') ?? 0.0;
    final crossAxisSpacing =
        PropertyParser.parseDouble(config, 'crossAxisSpacing') ?? 0.0;
    final childAspectRatio =
        PropertyParser.parseDouble(config, 'childAspectRatio') ?? 1.0;
    final children = WidgetParser.parseChildren(config);

    return GridView.count(
      scrollDirection: scrollDirection,
      padding: padding,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      children: children,
    );
  }

  static Widget _buildSingleChildScrollView(WidgetConfig config) {
    final scrollDirection = _parseAxis(
      config.getProperty<String>('scrollDirection'),
    );
    final padding = PropertyParser.parseEdgeInsets(config, 'padding');
    final child = WidgetParser.parseChild(config);

    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      padding: padding,
      child: child,
    );
  }

  static Widget _buildPageView(WidgetConfig config) {
    final scrollDirection = _parseAxis(
      config.getProperty<String>('scrollDirection'),
    );
    final children = WidgetParser.parseChildren(config);

    return PageView(scrollDirection: scrollDirection, children: children);
  }

  // Helper method to parse scroll direction
  static Axis _parseAxis(String? value) {
    if (value == null) return Axis.vertical;

    switch (value.toLowerCase()) {
      case 'horizontal':
        return Axis.horizontal;
      case 'vertical':
        return Axis.vertical;
      default:
        return Axis.vertical;
    }
  }
}
