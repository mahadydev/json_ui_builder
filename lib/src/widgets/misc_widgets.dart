import 'package:flutter/material.dart';
import 'package:json_ui_builder/src/core/widget_registry.dart';
import 'package:json_ui_builder/src/models/widget_config.dart';

import '../parsers/property_parser.dart';

class MiscWidgets {
  static void register() {
    final registry = WidgetRegistry();

    registry.registerWidget('FlutterLogo', _buildFlutterLogo, ['size']);
  }

  static Widget _buildFlutterLogo(WidgetConfig config) {
    final iconSize = PropertyParser.parseDouble(config, 'size') ?? 24.0;
    return FlutterLogo(size: iconSize);
  }
}
