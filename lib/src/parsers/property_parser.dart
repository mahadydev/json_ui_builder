import 'package:flutter/material.dart';
import '../models/widget_config.dart';
import '../utils/widget_utils.dart';
import '../utils/validation_utils.dart';
import '../exceptions/json_ui_exceptions.dart';

/// Utility class for parsing widget properties from WidgetConfig.
class PropertyParser {
  /// Parses a color property.
  static Color? parseColor(
    WidgetConfig config,
    String propertyName, [
    Color? defaultValue,
  ]) {
    final value = config.getProperty(propertyName);
    return WidgetUtils.parseColor(value) ?? defaultValue;
  }

  /// Parses a dimension property (width, height, etc.).
  static double? parseDimension(
    WidgetConfig config,
    String propertyName, [
    double? defaultValue,
  ]) {
    final value = config.getProperty(propertyName);
    return WidgetUtils.parseDimension(value) ?? defaultValue;
  }

  /// Parses EdgeInsets property (padding, margin, etc.).
  static EdgeInsets? parseEdgeInsets(
    WidgetConfig config,
    String propertyName, [
    EdgeInsets? defaultValue,
  ]) {
    final value = config.getProperty(propertyName);
    return WidgetUtils.parseEdgeInsets(value) ?? defaultValue;
  }

  /// Parses Alignment property.
  static Alignment? parseAlignment(
    WidgetConfig config,
    String propertyName, [
    Alignment? defaultValue,
  ]) {
    final value = config.getProperty<String>(propertyName);
    return WidgetUtils.parseAlignment(value) ?? defaultValue;
  }

  /// Parses MainAxisAlignment property.
  static MainAxisAlignment parseMainAxisAlignment(
    WidgetConfig config,
    String propertyName, [
    MainAxisAlignment? defaultValue,
  ]) {
    final value = config.getProperty<String>(propertyName);
    return WidgetUtils.parseMainAxisAlignment(value) ??
        defaultValue ??
        MainAxisAlignment.start;
  }

  /// Parses CrossAxisAlignment property.
  static CrossAxisAlignment parseCrossAxisAlignment(
    WidgetConfig config,
    String propertyName, [
    CrossAxisAlignment? defaultValue,
  ]) {
    final value = config.getProperty<String>(propertyName);
    return WidgetUtils.parseCrossAxisAlignment(value) ??
        defaultValue ??
        CrossAxisAlignment.center;
  }

  /// Parses a string property.
  static String? parseString(
    WidgetConfig config,
    String propertyName, [
    String? defaultValue,
  ]) {
    final value = config.getProperty(propertyName);
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// Parses a required string property.
  static String parseRequiredString(WidgetConfig config, String propertyName) {
    final value = parseString(config, propertyName);
    if (value == null || value.isEmpty) {
      throw MissingPropertyException(propertyName, config.type);
    }
    return value;
  }

  /// Parses a boolean property.
  static bool parseBool(
    WidgetConfig config,
    String propertyName, [
    bool defaultValue = false,
  ]) {
    final value = config.getProperty(propertyName);
    return ValidationUtils.parseBool(value) ?? defaultValue;
  }

  /// Parses an integer property.
  static int? parseInt(
    WidgetConfig config,
    String propertyName, [
    int? defaultValue,
  ]) {
    final value = config.getProperty(propertyName);
    if (value == null) return defaultValue;

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);

    return defaultValue;
  }

  /// Parses a double property.
  static double? parseDouble(
    WidgetConfig config,
    String propertyName, [
    double? defaultValue,
  ]) {
    final value = config.getProperty(propertyName);
    if (value == null) return defaultValue;

    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);

    return defaultValue;
  }

  /// Parses a required double property.
  static double parseRequiredDouble(WidgetConfig config, String propertyName) {
    final value = parseDouble(config, propertyName);
    if (value == null) {
      throw MissingPropertyException(propertyName, config.type);
    }
    return value;
  }

  /// Parses TextStyle property.
  static TextStyle? parseTextStyle(
    WidgetConfig config,
    String propertyName, [
    TextStyle? defaultValue,
  ]) {
    final value = config.getProperty<Map<String, dynamic>>(propertyName);
    if (value == null) return defaultValue;

    return TextStyle(
      fontSize: parseDoubleFromMap(value, 'fontSize'),
      fontWeight: parseFontWeight(value['fontWeight']),
      color: WidgetUtils.parseColor(value['color']),
      fontFamily: value['fontFamily'] as String?,
      letterSpacing: parseDoubleFromMap(value, 'letterSpacing'),
      wordSpacing: parseDoubleFromMap(value, 'wordSpacing'),
      height: parseDoubleFromMap(value, 'height'),
    );
  }

  /// Parses FontWeight from string or number.
  static FontWeight? parseFontWeight(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      switch (value.toLowerCase()) {
        case 'normal':
          return FontWeight.normal;
        case 'bold':
          return FontWeight.bold;
        case 'w100':
          return FontWeight.w100;
        case 'w200':
          return FontWeight.w200;
        case 'w300':
          return FontWeight.w300;
        case 'w400':
          return FontWeight.w400;
        case 'w500':
          return FontWeight.w500;
        case 'w600':
          return FontWeight.w600;
        case 'w700':
          return FontWeight.w700;
        case 'w800':
          return FontWeight.w800;
        case 'w900':
          return FontWeight.w900;
      }
    }

    if (value is int) {
      switch (value) {
        case 100:
          return FontWeight.w100;
        case 200:
          return FontWeight.w200;
        case 300:
          return FontWeight.w300;
        case 400:
          return FontWeight.w400;
        case 500:
          return FontWeight.w500;
        case 600:
          return FontWeight.w600;
        case 700:
          return FontWeight.w700;
        case 800:
          return FontWeight.w800;
        case 900:
          return FontWeight.w900;
      }
    }

    return null;
  }

  /// Parses BoxDecoration property.
  static BoxDecoration? parseBoxDecoration(
    WidgetConfig config,
    String propertyName, [
    BoxDecoration? defaultValue,
  ]) {
    final value = config.getProperty<Map<String, dynamic>>(propertyName);
    if (value == null) return defaultValue;

    return BoxDecoration(
      color: WidgetUtils.parseColor(value['color']),
      border: parseBorder(value['border']),
      borderRadius: parseBorderRadius(value['borderRadius']),
    );
  }

  /// Parses Border from map.
  static Border? parseBorder(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      final color = WidgetUtils.parseColor(value['color']) ?? Colors.black;
      final width = parseDoubleFromMap(value, 'width') ?? 1.0;

      return Border.all(color: color, width: width);
    }

    return null;
  }

  /// Parses BorderRadius from map or number.
  static BorderRadius? parseBorderRadius(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return BorderRadius.circular(value.toDouble());
    }

    if (value is Map<String, dynamic>) {
      final topLeft = parseDoubleFromMap(value, 'topLeft') ?? 0.0;
      final topRight = parseDoubleFromMap(value, 'topRight') ?? 0.0;
      final bottomLeft = parseDoubleFromMap(value, 'bottomLeft') ?? 0.0;
      final bottomRight = parseDoubleFromMap(value, 'bottomRight') ?? 0.0;

      return BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      );
    }

    return null;
  }

  /// Helper method to parse double from map.
  static double? parseDoubleFromMap(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value == null) return null;

    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);

    return null;
  }

  /// Parses MainAxisSize from string.
  static MainAxisSize parseMainAxisSize(
    WidgetConfig config,
    String propertyName, [
    MainAxisSize? defaultValue,
  ]) {
    final value = config.getProperty<String>(propertyName);
    if (value == null) return defaultValue ?? MainAxisSize.max;

    switch (value.toLowerCase()) {
      case 'min':
        return MainAxisSize.min;
      case 'max':
        return MainAxisSize.max;
      default:
        return defaultValue ?? MainAxisSize.max;
    }
  }

  /// Parses TextAlign from string.
  static TextAlign? parseTextAlign(
    WidgetConfig config,
    String propertyName, [
    TextAlign? defaultValue,
  ]) {
    final value = config.getProperty<String>(propertyName);
    if (value == null) return defaultValue;

    switch (value.toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return defaultValue;
    }
  }
}
