import 'package:flutter/material.dart';
import '../core/widget_registry.dart';
import '../models/widget_config.dart';
import '../parsers/property_parser.dart';
import '../parsers/widget_parser.dart';

/// Button widgets implementation for JSON UI Builder.
class ButtonWidgets {
  /// Registers all button widgets with the widget registry.
  static void register() {
    final registry = WidgetRegistry();

    registry.registerWidget('ElevatedButton', _buildElevatedButton, [
      'text',
      'onPressed',
      'style',
    ]);

    registry.registerWidget('TextButton', _buildTextButton, [
      'text',
      'onPressed',
      'style',
    ]);

    registry.registerWidget('OutlinedButton', _buildOutlinedButton, [
      'text',
      'onPressed',
      'style',
    ]);

    registry.registerWidget('IconButton', _buildIconButton, [
      'icon',
      'onPressed',
      'iconSize',
      'color',
    ]);

    registry.registerWidget(
      'FloatingActionButton',
      _buildFloatingActionButton,
      ['onPressed', 'child', 'backgroundColor', 'mini'],
    );
  }

  static Widget _buildElevatedButton(WidgetConfig config) {
    final text = PropertyParser.parseRequiredString(config, 'text');
    final child = WidgetParser.parseChild(config);

    return ElevatedButton(
      onPressed: () {
        // Handle onPressed - can be extended for event handling
        debugPrint('ElevatedButton pressed: ${config.id}');
      },
      child: child ?? Text(text),
    );
  }

  static Widget _buildTextButton(WidgetConfig config) {
    final text = PropertyParser.parseRequiredString(config, 'text');
    final child = WidgetParser.parseChild(config);

    return TextButton(
      onPressed: () {
        debugPrint('TextButton pressed: ${config.id}');
      },
      child: child ?? Text(text),
    );
  }

  static Widget _buildOutlinedButton(WidgetConfig config) {
    final text = PropertyParser.parseRequiredString(config, 'text');
    final child = WidgetParser.parseChild(config);

    return OutlinedButton(
      onPressed: () {
        debugPrint('OutlinedButton pressed: ${config.id}');
      },
      child: child ?? Text(text),
    );
  }

  static Widget _buildIconButton(WidgetConfig config) {
    final iconName = PropertyParser.parseRequiredString(config, 'icon');
    final iconSize = PropertyParser.parseDouble(config, 'iconSize') ?? 24.0;
    final color = PropertyParser.parseColor(config, 'color');

    final icon = _parseIcon(iconName);

    return IconButton(
      onPressed: () {
        debugPrint('IconButton pressed: ${config.id}');
      },
      icon: Icon(icon, size: iconSize, color: color),
    );
  }

  static Widget _buildFloatingActionButton(WidgetConfig config) {
    final mini = PropertyParser.parseBool(config, 'mini');
    final backgroundColor = PropertyParser.parseColor(
      config,
      'backgroundColor',
    );
    final child = WidgetParser.parseChild(config);

    return FloatingActionButton(
      onPressed: () {
        debugPrint('FloatingActionButton pressed: ${config.id}');
      },
      mini: mini,
      backgroundColor: backgroundColor,
      child: child ?? const Icon(Icons.add),
    );
  }

  // Helper method to parse icon names to IconData
  static IconData _parseIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'add':
        return Icons.add;
      case 'remove':
        return Icons.remove;
      case 'edit':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'save':
        return Icons.save;
      case 'cancel':
        return Icons.cancel;
      case 'check':
        return Icons.check;
      case 'close':
        return Icons.close;
      case 'menu':
        return Icons.menu;
      case 'home':
        return Icons.home;
      case 'search':
        return Icons.search;
      case 'settings':
        return Icons.settings;
      case 'favorite':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      case 'person':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'location':
        return Icons.location_on;
      case 'camera':
        return Icons.camera_alt;
      case 'photo':
        return Icons.photo;
      case 'video':
        return Icons.videocam;
      case 'music':
        return Icons.music_note;
      case 'download':
        return Icons.download;
      case 'upload':
        return Icons.upload;
      case 'share':
        return Icons.share;
      case 'print':
        return Icons.print;
      case 'copy':
        return Icons.copy;
      case 'paste':
        return Icons.paste;
      case 'cut':
        return Icons.cut;
      case 'undo':
        return Icons.undo;
      case 'redo':
        return Icons.redo;
      case 'refresh':
        return Icons.refresh;
      case 'sync':
        return Icons.sync;
      case 'info':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'help':
        return Icons.help;
      case 'visibility':
        return Icons.visibility;
      case 'visibility_off':
        return Icons.visibility_off;
      case 'lock':
        return Icons.lock;
      case 'unlock':
        return Icons.lock_open;
      case 'keyboard_arrow_down':
        return Icons.keyboard_arrow_down;
      case 'keyboard_arrow_up':
        return Icons.keyboard_arrow_up;
      case 'keyboard_arrow_left':
        return Icons.keyboard_arrow_left;
      case 'keyboard_arrow_right':
        return Icons.keyboard_arrow_right;
      case 'expand_more':
        return Icons.expand_more;
      case 'expand_less':
        return Icons.expand_less;
      case 'chevron_left':
        return Icons.chevron_left;
      case 'chevron_right':
        return Icons.chevron_right;
      case 'arrow_back':
        return Icons.arrow_back;
      case 'arrow_forward':
        return Icons.arrow_forward;
      case 'arrow_upward':
        return Icons.arrow_upward;
      case 'arrow_downward':
        return Icons.arrow_downward;
      default:
        return Icons.help_outline; // Default fallback icon
    }
  }
}
