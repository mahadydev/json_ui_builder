import 'package:flutter/material.dart';
import '../core/widget_registry.dart';
import '../models/widget_config.dart';
import '../parsers/property_parser.dart';

/// Text widgets implementation for JSON UI Builder.
class TextWidgets {
  /// Registers all text widgets with the widget registry.
  static void register() {
    final registry = WidgetRegistry();

    registry.registerWidget('Text', _buildText, [
      'text',
      'style',
      'textAlign',
      'overflow',
      'maxLines',
    ]);

    registry.registerWidget('RichText', _buildRichText, [
      'text',
      'textAlign',
      'overflow',
      'maxLines',
    ]);

    registry.registerWidget('TextField', _buildTextField, [
      'hintText',
      'labelText',
      'obscureText',
      'enabled',
      'maxLines',
      'controller',
    ]);

    registry.registerWidget('TextFormField', _buildTextFormField, [
      'hintText',
      'labelText',
      'obscureText',
      'enabled',
      'maxLines',
      'validator',
    ]);
  }

  static Widget _buildText(WidgetConfig config) {
    final text = PropertyParser.parseRequiredString(config, 'text');
    final fontSize = PropertyParser.parseDouble(config, 'fontSize');
    final letterSpacing = PropertyParser.parseDouble(config, 'letterSpacing');
    final color = PropertyParser.parseColor(config, 'color');
    final fontWeight = PropertyParser.parseFontWeight(config, 'fontWeight');
    final style = PropertyParser.parseTextStyle(config, 'style');
    final textAlign = PropertyParser.parseTextAlign(config, 'textAlign');
    final overflow = _parseTextOverflow(config.getProperty<String>('overflow'));
    final maxLines = PropertyParser.parseInt(config, 'maxLines');

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16.0,
        letterSpacing: letterSpacing ?? 0.0,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  static Widget _buildRichText(WidgetConfig config) {
    final textSpans = _parseTextSpans(config.getProperty('text'));
    final textAlign =
        PropertyParser.parseTextAlign(config, 'textAlign') ?? TextAlign.start;
    final overflow =
        _parseTextOverflow(config.getProperty<String>('overflow')) ??
        TextOverflow.clip;
    final maxLines = PropertyParser.parseInt(config, 'maxLines');

    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  static Widget _buildTextField(WidgetConfig config) {
    final hintText = PropertyParser.parseString(config, 'hintText');
    final labelText = PropertyParser.parseString(config, 'labelText');
    final obscureText = PropertyParser.parseBool(config, 'obscureText');
    final enabled = PropertyParser.parseBool(config, 'enabled', true);
    final maxLines = PropertyParser.parseInt(config, 'maxLines', 1);

    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
    );
  }

  static Widget _buildTextFormField(WidgetConfig config) {
    final hintText = PropertyParser.parseString(config, 'hintText');
    final labelText = PropertyParser.parseString(config, 'labelText');
    final obscureText = PropertyParser.parseBool(config, 'obscureText');
    final enabled = PropertyParser.parseBool(config, 'enabled', true);
    final maxLines = PropertyParser.parseInt(config, 'maxLines', 1);

    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      validator: (value) {
        // Basic validation - can be extended
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  // Helper methods for parsing enums and complex types

  static TextOverflow? _parseTextOverflow(String? value) {
    if (value == null) return null;

    switch (value.toLowerCase()) {
      case 'clip':
        return TextOverflow.clip;
      case 'fade':
        return TextOverflow.fade;
      case 'ellipsis':
        return TextOverflow.ellipsis;
      case 'visible':
        return TextOverflow.visible;
      default:
        return null;
    }
  }

  static List<TextSpan> _parseTextSpans(dynamic value) {
    if (value == null) return [];

    if (value is String) {
      return [TextSpan(text: value)];
    }

    if (value is List) {
      return value.map((item) => _parseTextSpan(item)).toList();
    }

    if (value is Map<String, dynamic>) {
      return [_parseTextSpan(value)];
    }

    return [];
  }

  static TextSpan _parseTextSpan(dynamic value) {
    if (value is String) {
      return TextSpan(text: value);
    }

    if (value is Map<String, dynamic>) {
      final text = value['text'] as String? ?? '';
      final style = _parseTextStyleFromMap(
        value['style'] as Map<String, dynamic>?,
      );
      final children = value['children'] as List?;

      List<TextSpan>? childSpans;
      if (children != null) {
        childSpans = children.map((child) => _parseTextSpan(child)).toList();
      }

      return TextSpan(text: text, style: style, children: childSpans);
    }

    return TextSpan(text: value.toString());
  }

  static TextStyle? _parseTextStyleFromMap(Map<String, dynamic>? styleMap) {
    if (styleMap == null) return null;

    return TextStyle(
      fontSize: styleMap['fontSize']?.toDouble(),
      //  fontWeight: PropertyParser.parseFontWeight(styleMap['fontWeight']),
      color: _parseColorFromValue(styleMap['color']),
      fontFamily: styleMap['fontFamily'] as String?,
      letterSpacing: styleMap['letterSpacing']?.toDouble(),
      wordSpacing: styleMap['wordSpacing']?.toDouble(),
      height: styleMap['height']?.toDouble(),
      decoration: _parseTextDecoration(styleMap['decoration']),
    );
  }

  static Color? _parseColorFromValue(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      String hexColor = value;
      if (hexColor.startsWith('#')) {
        hexColor = hexColor.substring(1);
      }

      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }

      if (hexColor.length == 8) {
        return Color(int.parse(hexColor, radix: 16));
      }
    }

    return null;
  }

  static TextDecoration? _parseTextDecoration(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      switch (value.toLowerCase()) {
        case 'none':
          return TextDecoration.none;
        case 'underline':
          return TextDecoration.underline;
        case 'overline':
          return TextDecoration.overline;
        case 'linethrough':
          return TextDecoration.lineThrough;
        default:
          return null;
      }
    }

    return null;
  }
}
