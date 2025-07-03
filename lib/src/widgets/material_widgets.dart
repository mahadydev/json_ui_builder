import 'package:flutter/material.dart';
import '../core/widget_registry.dart';
import '../models/widget_config.dart';
import '../parsers/property_parser.dart';
import '../parsers/widget_parser.dart';

/// Material Design widgets implementation for JSON UI Builder.
class MaterialWidgets {
  /// Registers all material widgets with the widget registry.
  static void register() {
    final registry = WidgetRegistry();

    registry.registerWidget('Scaffold', _buildScaffold, [
      'appBar',
      'body',
      'floatingActionButton',
      'drawer',
      'bottomNavigationBar',
    ]);

    registry.registerWidget('AppBar', _buildAppBar, [
      'title',
      'backgroundColor',
      'elevation',
      'centerTitle',
      'leading',
      'actions',
    ]);

    registry.registerWidget('Card', _buildCard, [
      'elevation',
      'margin',
      'color',
      'shadowColor',
    ]);

    registry.registerWidget('ListTile', _buildListTile, [
      'title',
      'subtitle',
      'leading',
      'trailing',
      'onTap',
    ]);

    registry.registerWidget('Drawer', _buildDrawer, []);

    registry.registerWidget('BottomNavigationBar', _buildBottomNavigationBar, [
      'items',
      'currentIndex',
      'type',
      'backgroundColor',
    ]);

    registry.registerWidget('TabBar', _buildTabBar, [
      'tabs',
      'labelColor',
      'unselectedLabelColor',
      'indicatorColor',
    ]);

    registry.registerWidget('Tab', _buildTab, ['text', 'icon']);
  }

  static Widget _buildScaffold(WidgetConfig config) {
    final appBar = _parseAppBar(config.getProperty('appBar'));
    final body = WidgetParser.parseChild(config);
    final floatingActionButton = _parseFloatingActionButton(
      config.getProperty('floatingActionButton'),
    );
    final drawer = _parseDrawer(config.getProperty('drawer'));
    final bottomNavigationBar = _parseBottomNavigationBar(
      config.getProperty('bottomNavigationBar'),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  static Widget _buildAppBar(WidgetConfig config) {
    final title = PropertyParser.parseString(config, 'title');
    final backgroundColor = PropertyParser.parseColor(
      config,
      'backgroundColor',
    );
    final elevation = PropertyParser.parseDouble(config, 'elevation');
    final centerTitle = PropertyParser.parseBool(config, 'centerTitle');

    return AppBar(
      title: title != null ? Text(title) : null,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
    );
  }

  static Widget _buildCard(WidgetConfig config) {
    final elevation = PropertyParser.parseDouble(config, 'elevation');
    final margin = PropertyParser.parseEdgeInsets(config, 'margin');
    final color = PropertyParser.parseColor(config, 'color');
    final shadowColor = PropertyParser.parseColor(config, 'shadowColor');
    final child = WidgetParser.parseChild(config);

    return Card(
      elevation: elevation,
      margin: margin,
      color: color,
      shadowColor: shadowColor,
      child: child,
    );
  }

  static Widget _buildListTile(WidgetConfig config) {
    final title = PropertyParser.parseString(config, 'title');
    final subtitle = PropertyParser.parseString(config, 'subtitle');
    // Note: leading and trailing would need more complex parsing for widgets

    return ListTile(
      title: title != null ? Text(title) : null,
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: () {
        debugPrint('ListTile tapped: ${config.id}');
      },
    );
  }

  static Widget _buildDrawer(WidgetConfig config) {
    final child = WidgetParser.parseChild(config);

    return Drawer(child: child);
  }

  static Widget _buildBottomNavigationBar(WidgetConfig config) {
    final items = _parseBottomNavigationBarItems(config.getProperty('items'));
    final currentIndex = PropertyParser.parseInt(config, 'currentIndex') ?? 0;
    final type = _parseBottomNavigationBarType(
      config.getProperty<String>('type'),
    );
    final backgroundColor = PropertyParser.parseColor(
      config,
      'backgroundColor',
    );

    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      type: type,
      backgroundColor: backgroundColor,
      onTap: (int index) {
        debugPrint('BottomNavigationBar tapped: ${config.id} index: $index');
      },
    );
  }

  static Widget _buildTabBar(WidgetConfig config) {
    final tabs = _parseTabs(config.getProperty('tabs'));
    final labelColor = PropertyParser.parseColor(config, 'labelColor');
    final unselectedLabelColor = PropertyParser.parseColor(
      config,
      'unselectedLabelColor',
    );
    final indicatorColor = PropertyParser.parseColor(config, 'indicatorColor');

    return TabBar(
      tabs: tabs,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      indicatorColor: indicatorColor,
    );
  }

  static Widget _buildTab(WidgetConfig config) {
    final text = PropertyParser.parseString(config, 'text');
    final iconName = PropertyParser.parseString(config, 'icon');

    IconData? icon;
    if (iconName != null) {
      icon = _parseIcon(iconName);
    }

    return Tab(text: text, icon: icon != null ? Icon(icon) : null);
  }

  // Helper methods for parsing complex widgets

  static AppBar? _parseAppBar(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      final config = WidgetConfig.fromJson({...value, 'type': 'AppBar'});
      return _buildAppBar(config) as AppBar;
    }

    return null;
  }

  static FloatingActionButton? _parseFloatingActionButton(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      return FloatingActionButton(
        onPressed: () {
          debugPrint('FloatingActionButton pressed');
        },
        child: const Icon(Icons.add),
      );
    }

    return null;
  }

  static Drawer? _parseDrawer(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      final config = WidgetConfig.fromJson({...value, 'type': 'Drawer'});
      return _buildDrawer(config) as Drawer;
    }

    return null;
  }

  static BottomNavigationBar? _parseBottomNavigationBar(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      final config = WidgetConfig.fromJson({
        ...value,
        'type': 'BottomNavigationBar',
      });
      return _buildBottomNavigationBar(config) as BottomNavigationBar;
    }

    return null;
  }

  static List<BottomNavigationBarItem> _parseBottomNavigationBarItems(
    dynamic itemsValue,
  ) {
    if (itemsValue == null) return [];

    if (itemsValue is List) {
      return itemsValue.map((item) {
        if (item is Map<String, dynamic>) {
          final icon = _parseIcon(item['icon'] as String? ?? 'home');
          final label = item['label'] as String? ?? '';

          return BottomNavigationBarItem(icon: Icon(icon), label: label);
        }
        return const BottomNavigationBarItem(icon: Icon(Icons.home), label: '');
      }).toList();
    }

    return [];
  }

  static BottomNavigationBarType _parseBottomNavigationBarType(String? type) {
    if (type == null) return BottomNavigationBarType.fixed;

    switch (type.toLowerCase()) {
      case 'fixed':
        return BottomNavigationBarType.fixed;
      case 'shifting':
        return BottomNavigationBarType.shifting;
      default:
        return BottomNavigationBarType.fixed;
    }
  }

  static List<Tab> _parseTabs(dynamic tabsValue) {
    if (tabsValue == null) return [];

    if (tabsValue is List) {
      return tabsValue.map((tab) {
        if (tab is Map<String, dynamic>) {
          final config = WidgetConfig.fromJson({...tab, 'type': 'Tab'});
          return _buildTab(config) as Tab;
        }
        return Tab(text: tab.toString());
      }).toList();
    }

    return [];
  }

  static IconData _parseIcon(String iconName) {
    // Reuse the icon parsing logic from ButtonWidgets
    switch (iconName.toLowerCase()) {
      case 'add':
        return Icons.add;
      case 'home':
        return Icons.home;
      case 'search':
        return Icons.search;
      case 'person':
        return Icons.person;
      case 'settings':
        return Icons.settings;
      case 'favorite':
        return Icons.favorite;
      case 'menu':
        return Icons.menu;
      default:
        return Icons.help_outline;
    }
  }
}
