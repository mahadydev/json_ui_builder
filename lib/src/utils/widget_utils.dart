import 'package:flutter/material.dart';

import '../models/widget_config.dart';
import '../utils/validation_utils.dart';

/// Utility functions for working with widgets and widget configurations.
class WidgetUtils {
  /// Extracts all widget IDs from a widget configuration tree.
  static Set<String> extractAllIds(WidgetConfig config) {
    final ids = <String>{};
    _extractIdsRecursive(config, ids);
    return ids;
  }

  static void _extractIdsRecursive(WidgetConfig config, Set<String> ids) {
    if (config.id.isNotEmpty) {
      ids.add(config.id);
    }

    // Check child
    if (config.child != null) {
      _extractIdsRecursive(config.child!, ids);
    }

    // Check children
    if (config.children != null) {
      for (final child in config.children!) {
        _extractIdsRecursive(child, ids);
      }
    }
  }

  /// Finds a widget configuration by ID in the widget tree.
  static WidgetConfig? findWidgetById(WidgetConfig root, String id) {
    if (root.id == id) return root;

    // Check child
    if (root.child != null) {
      final found = findWidgetById(root.child!, id);
      if (found != null) return found;
    }

    // Check children
    if (root.children != null) {
      for (final child in root.children!) {
        final found = findWidgetById(child, id);
        if (found != null) return found;
      }
    }

    return null;
  }

  /// Updates a widget configuration by ID in the widget tree.
  static bool updateWidgetById(
    WidgetConfig root,
    String id,
    WidgetConfig newConfig,
  ) {
    // Check child
    if (root.child?.id == id) {
      root.child = newConfig;
      return true;
    }

    if (root.child != null) {
      if (updateWidgetById(root.child!, id, newConfig)) return true;
    }

    // Check children
    if (root.children != null) {
      for (int i = 0; i < root.children!.length; i++) {
        if (root.children![i].id == id) {
          root.children![i] = newConfig;
          return true;
        }

        if (updateWidgetById(root.children![i], id, newConfig)) return true;
      }
    }

    return false;
  }

  /// Removes a widget configuration by ID from the widget tree.
  static bool removeWidgetById(WidgetConfig root, String id) {
    // Check child
    if (root.child?.id == id) {
      root.child = null;
      return true;
    }

    if (root.child != null) {
      if (removeWidgetById(root.child!, id)) return true;
    }

    // Check children
    if (root.children != null) {
      for (int i = 0; i < root.children!.length; i++) {
        if (root.children![i].id == id) {
          root.children!.removeAt(i);
          return true;
        }

        if (removeWidgetById(root.children![i], id)) return true;
      }
    }

    return false;
  }

  /// Parses a color from string representation.
  static Color? parseColor(dynamic colorValue) {
    if (colorValue == null) return null;

    if (colorValue is String) {
      if (!ValidationUtils.isValidColor(colorValue)) return null;

      String hexColor = colorValue;
      if (hexColor.startsWith('#')) {
        hexColor = hexColor.substring(1);
      }

      // Handle 6-digit hex (RGB)
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor'; // Add full opacity
      }

      // Handle 8-digit hex (ARGB)
      if (hexColor.length == 8) {
        return Color(int.parse(hexColor, radix: 16));
      }
    }

    return null;
  }

  /// Parses dimension values (supports numbers, percentages, and 'auto').
  static double? parseDimension(dynamic value, {double? parentSize}) {
    if (value == null || value == 'auto') return null;

    if (value is num) return value.toDouble();

    if (value is String) {
      if (value.endsWith('%') && parentSize != null) {
        final percentage = double.tryParse(
          value.substring(0, value.length - 1),
        );
        if (percentage != null) {
          return (percentage / 100) * parentSize;
        }
      }
      return double.tryParse(value);
    }

    return null;
  }

  /// Parses EdgeInsets from various formats.
  static EdgeInsets? parseEdgeInsets(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return EdgeInsets.all(value.toDouble());
    }

    if (value is Map<String, dynamic>) {
      final top = value['top']?.toDouble() ?? 0.0;
      final right = value['right']?.toDouble() ?? 0.0;
      final bottom = value['bottom']?.toDouble() ?? 0.0;
      final left = value['left']?.toDouble() ?? 0.0;

      return EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      );
    }

    if (value is List && value.length >= 2) {
      if (value.length == 2) {
        // vertical, horizontal
        return EdgeInsets.symmetric(
          vertical: value[0]?.toDouble() ?? 0.0,
          horizontal: value[1]?.toDouble() ?? 0.0,
        );
      } else if (value.length >= 4) {
        // top, right, bottom, left
        return EdgeInsets.only(
          top: value[0]?.toDouble() ?? 0.0,
          right: value[1]?.toDouble() ?? 0.0,
          bottom: value[2]?.toDouble() ?? 0.0,
          left: value[3]?.toDouble() ?? 0.0,
        );
      }
    }

    return null;
  }

  /// Parses Alignment from string.
  static Alignment? parseAlignment(String? alignment) {
    if (alignment == null) return null;

    switch (alignment) {
      case 'topLeft':
        return Alignment.topLeft;
      case 'topCenter':
        return Alignment.topCenter;
      case 'topRight':
        return Alignment.topRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'center':
        return Alignment.center;
      case 'centerRight':
        return Alignment.centerRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bottomRight':
        return Alignment.bottomRight;
      default:
        return null;
    }
  }

  /// Parses MainAxisAlignment from string.
  static MainAxisAlignment? parseMainAxisAlignment(String? alignment) {
    if (alignment == null) return null;

    switch (alignment) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return null;
    }
  }

  /// Parses CrossAxisAlignment from string.
  static CrossAxisAlignment? parseCrossAxisAlignment(String? alignment) {
    if (alignment == null) return null;

    switch (alignment) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      default:
        return null;
    }
  }
}
