import 'package:flutter/material.dart';
import '../core/widget_registry.dart';
import '../models/widget_config.dart';
import '../parsers/property_parser.dart';

/// Input widgets implementation for JSON UI Builder.
class InputWidgets {
  /// Registers all input widgets with the widget registry.
  static void register() {
    final registry = WidgetRegistry();

    registry.registerWidget('Checkbox', _buildCheckbox, [
      'value',
      'onChanged',
      'activeColor',
    ]);

    registry.registerWidget('Radio', _buildRadio, [
      'value',
      'groupValue',
      'onChanged',
      'activeColor',
    ]);

    registry.registerWidget('Switch', _buildSwitch, [
      'value',
      'onChanged',
      'activeColor',
    ]);

    registry.registerWidget('Slider', _buildSlider, [
      'value',
      'min',
      'max',
      'divisions',
      'onChanged',
    ]);

    registry.registerWidget('DropdownButton', _buildDropdownButton, [
      'value',
      'items',
      'onChanged',
      'hint',
    ]);
  }

  static Widget _buildCheckbox(WidgetConfig config) {
    final value = PropertyParser.parseBool(config, 'value');
    final activeColor = PropertyParser.parseColor(config, 'activeColor');

    return Checkbox(
      value: value,
      activeColor: activeColor,
      onChanged: (bool? newValue) {
        debugPrint('Checkbox changed: ${config.id} = $newValue');
        // In a real implementation, this would trigger a state update
      },
    );
  }

  static Widget _buildRadio(WidgetConfig config) {
    final value = config.getProperty('value');
    final groupValue = config.getProperty('groupValue');
    final activeColor = PropertyParser.parseColor(config, 'activeColor');

    return Radio<dynamic>(
      value: value,
      groupValue: groupValue,
      activeColor: activeColor,
      onChanged: (dynamic newValue) {
        debugPrint('Radio changed: ${config.id} = $newValue');
      },
    );
  }

  static Widget _buildSwitch(WidgetConfig config) {
    final value = PropertyParser.parseBool(config, 'value');
    final activeColor = PropertyParser.parseColor(config, 'activeColor');

    return Switch(
      value: value,
      activeColor: activeColor,
      onChanged: (bool newValue) {
        debugPrint('Switch changed: ${config.id} = $newValue');
      },
    );
  }

  static Widget _buildSlider(WidgetConfig config) {
    final value = PropertyParser.parseDouble(config, 'value') ?? 0.0;
    final min = PropertyParser.parseDouble(config, 'min') ?? 0.0;
    final max = PropertyParser.parseDouble(config, 'max') ?? 1.0;
    final divisions = PropertyParser.parseInt(config, 'divisions');
    final activeColor = PropertyParser.parseColor(config, 'activeColor');

    return Slider(
      value: value.clamp(min, max),
      min: min,
      max: max,
      divisions: divisions,
      activeColor: activeColor,
      onChanged: (double newValue) {
        debugPrint('Slider changed: ${config.id} = $newValue');
      },
    );
  }

  static Widget _buildDropdownButton(WidgetConfig config) {
    final value = config.getProperty('value');
    final hint = PropertyParser.parseString(config, 'hint');
    final items = _parseDropdownItems(config.getProperty('items'));

    return DropdownButton<dynamic>(
      value: value,
      hint: hint != null ? Text(hint) : null,
      items: items,
      onChanged: (dynamic newValue) {
        debugPrint('DropdownButton changed: ${config.id} = $newValue');
      },
    );
  }

  // Helper method to parse dropdown items
  static List<DropdownMenuItem<dynamic>>? _parseDropdownItems(
    dynamic itemsValue,
  ) {
    if (itemsValue == null) return null;

    if (itemsValue is List) {
      return itemsValue.map((item) {
        if (item is Map<String, dynamic>) {
          final value = item['value'];
          final text = item['text']?.toString() ?? value.toString();

          return DropdownMenuItem<dynamic>(value: value, child: Text(text));
        } else {
          return DropdownMenuItem<dynamic>(
            value: item,
            child: Text(item.toString()),
          );
        }
      }).toList();
    }

    return null;
  }
}
