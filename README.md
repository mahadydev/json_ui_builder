# JSON UI Builder

A powerful Flutter package for building dynamic UIs from JSON configurations. This package enables bi-directional conversion between JSON and Flutter widgets, making it perfect for app builder tools, dynamic UI generation, and widget tree manipulation.

## Features

✨ **Dynamic Widget Creation**: Build Flutter widgets from JSON configurations  
🔄 **Bi-directional Conversion**: Convert between JSON and widget trees  
🎯 **Widget Identification**: Unique ID system for widget tree manipulation  
🏗️ **Comprehensive Widget Support**: Supports all essential Flutter widgets  
🛡️ **Type Safety**: Full type safety with validation  
🔧 **Extensible**: Easy custom widget registration  
📱 **Platform Support**: Works on all Flutter platforms (iOS, Android, Web, Desktop)

## Supported Widgets

### Layout Widgets
- Container, Column, Row, Stack, Positioned
- Expanded, Flexible, Wrap, Center, Align
- Padding, SizedBox

### Text Widgets
- Text, RichText, TextField, TextFormField

### Button Widgets
- ElevatedButton, TextButton, OutlinedButton
- IconButton, FloatingActionButton

### Input Widgets
- Checkbox, Radio, Switch, Slider, DropdownButton

### Material Design Widgets
- Scaffold, AppBar, Card, ListTile
- Drawer, BottomNavigationBar, TabBar, Tab

### Scrollable Widgets
- ListView, GridView, SingleChildScrollView, PageView

### Image Widgets
- Image, NetworkImage, AssetImage, CircleAvatar, Icon

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  json_ui_builder: ^0.0.1
```

Then run:
```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:json_ui_builder/json_ui_builder.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final builder = JsonUIBuilder();
    
    final json = {
      'type': 'Scaffold',
      'properties': {},
      'child': {
        'type': 'Center',
        'child': {
          'type': 'Column',
          'properties': {
            'mainAxisAlignment': 'center',
          },
          'children': [
            {
              'type': 'Text',
              'properties': {
                'text': 'Hello, JSON UI!',
                'style': {
                  'fontSize': 24.0,
                  'fontWeight': 'bold',
                  'color': '#2196F3'
                }
              }
            },
            {
              'type': 'ElevatedButton',
              'properties': {
                'text': 'Click Me!',
              }
            }
          ]
        }
      }
    };
    
    return MaterialApp(
      home: builder.buildFromJson(json),
    );
  }
}
```

### Building a Complex UI

```dart
final complexJson = {
  'type': 'Scaffold',
  'properties': {
    'appBar': {
      'type': 'AppBar',
      'properties': {
        'title': 'JSON UI Demo',
        'backgroundColor': '#2196F3',
      }
    }
  },
  'child': {
    'type': 'ListView',
    'properties': {
      'padding': {'top': 16, 'bottom': 16, 'left': 16, 'right': 16}
    },
    'children': [
      {
        'type': 'Card',
        'properties': {
          'elevation': 4,
          'margin': {'bottom': 16}
        },
        'child': {
          'type': 'ListTile',
          'properties': {
            'title': 'Profile Settings',
            'subtitle': 'Manage your account'
          }
        }
      },
      {
        'type': 'Container',
        'properties': {
          'padding': 16,
          'decoration': {
            'color': '#F5F5F5',
            'borderRadius': 8
          }
        },
        'child': {
          'type': 'Row',
          'properties': {
            'mainAxisAlignment': 'spaceBetween'
          },
          'children': [
            {
              'type': 'Text',
              'properties': {
                'text': 'Dark Mode'
              }
            },
            {
              'type': 'Switch',
              'properties': {
                'value': true
              }
            }
          ]
        }
      }
    ]
  }
};

final widget = JsonUIBuilder().buildFromJson(complexJson);
```

## Widget Identification and Manipulation

### Adding IDs to Widgets

```dart
final configWithIds = {
  'type': 'Column',
  'id': 'main_column',
  'children': [
    {
      'type': 'Text',
      'id': 'title_text',
      'properties': {
        'text': 'Original Title'
      }
    },
    {
      'type': 'ElevatedButton',
      'id': 'action_button',
      'properties': {
        'text': 'Click Me'
      }
    }
  ]
};
```

### Finding and Updating Widgets

```dart
final builder = JsonUIBuilder();
final config = builder.jsonToConfig(configWithIds);

// Find a widget by ID
final titleWidget = builder.findWidgetById(config, 'title_text');
print('Found widget: ${titleWidget?.type}');

// Update a widget
final newTitleConfig = WidgetConfig(
  type: 'Text',
  id: 'title_text',
  properties: {'text': 'Updated Title'}
);

builder.updateWidgetById(config, 'title_text', newTitleConfig);

// Remove a widget
builder.removeWidgetById(config, 'action_button');

// Get all widget IDs
final allIds = builder.getAllWidgetIds(config);
print('All widget IDs: $allIds');
```

## Custom Widget Registration

You can register your own custom widgets:

```dart
final builder = JsonUIBuilder();

builder.registerCustomWidget(
  'GradientContainer',
  (config) {
    final colors = config.getProperty<List>('colors') ?? [];
    final child = WidgetParser.parseChild(config);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.map((c) => WidgetUtils.parseColor(c) ?? Colors.blue).toList(),
        ),
      ),
      child: child,
    );
  },
  ['colors', 'child'],
);

// Use the custom widget
final customJson = {
  'type': 'GradientContainer',
  'properties': {
    'colors': ['#FF0000', '#00FF00', '#0000FF']
  },
  'child': {
    'type': 'Text',
    'properties': {
      'text': 'Gradient Background!'
    }
  }
};

final customWidget = builder.buildFromJson(customJson);
```

## JSON Schema

The JSON schema follows this structure:

```json
{
  "type": "WidgetType",
  "id": "unique_widget_id",
  "properties": {
    "property1": "value1",
    "property2": "value2"
  },
  "child": {
    // Single child widget configuration
  },
  "children": [
    // Array of child widget configurations
  ]
}
```

### Property Types

- **Colors**: Hex strings (`"#FF0000"`, `"#FFFF0000"`)
- **Dimensions**: Numbers, strings, or percentages (`100`, `"100"`, `"50%"`, `"auto"`)
- **EdgeInsets**: Numbers, arrays, or objects
  ```json
  10                          // All sides
  [10, 20]                   // Vertical, horizontal
  [10, 20, 30, 40]          // Top, right, bottom, left
  {"top": 10, "right": 20}   // Individual sides
  ```
- **Alignment**: Strings (`"center"`, `"topLeft"`, `"bottomRight"`)
- **TextStyle**: Objects with nested properties
  ```json
  {
    "fontSize": 16,
    "fontWeight": "bold",
    "color": "#000000"
  }
  ```

## API Reference

### JsonUIBuilder

Main class for JSON UI operations.

#### Methods

- `buildFromJson(dynamic json)` → `Widget`: Build widget from JSON
- `buildFromConfig(WidgetConfig config)` → `Widget`: Build widget from config
- `jsonToConfig(dynamic json)` → `WidgetConfig`: Convert JSON to config
- `configToJson(WidgetConfig config)` → `Map<String, dynamic>`: Convert config to JSON
- `validateJson(dynamic json)` → `bool`: Validate JSON structure
- `findWidgetById(WidgetConfig root, String id)` → `WidgetConfig?`: Find widget by ID
- `updateWidgetById(WidgetConfig root, String id, WidgetConfig newConfig)` → `bool`: Update widget
- `removeWidgetById(WidgetConfig root, String id)` → `bool`: Remove widget
- `getAllWidgetIds(WidgetConfig root)` → `Set<String>`: Get all widget IDs
- `registerCustomWidget(String type, Function builder, List<String> properties)`: Register custom widget

### WidgetConfig

Configuration class for widgets.

#### Properties

- `type`: Widget type string
- `id`: Unique identifier
- `properties`: Widget properties map
- `child`: Single child configuration
- `children`: Multiple children configurations

#### Methods

- `fromJson(Map<String, dynamic> json)`: Create from JSON
- `toJson()`: Convert to JSON
- `getProperty<T>(String key)`: Get typed property
- `setProperty(String key, dynamic value)`: Set property
- `hasProperty(String key)`: Check property existence
- `addChild(WidgetConfig child)`: Add child
- `removeChild(String childId)`: Remove child by ID

## Error Handling

The package provides comprehensive error handling with specific exception types:

```dart
try {
  final widget = builder.buildFromJson(invalidJson);
} catch (e) {
  if (e is UnsupportedWidgetException) {
    print('Widget type not supported: ${e.message}');
  } else if (e is JsonParsingException) {
    print('JSON parsing failed: ${e.message}');
  } else if (e is PropertyValidationException) {
    print('Property validation failed: ${e.message}');
  }
}
```

## Performance Tips

1. **Use widget IDs strategically**: Only add IDs to widgets you need to manipulate
2. **Validate JSON early**: Use `validateJson()` before building widgets
3. **Cache configurations**: Reuse `WidgetConfig` objects when possible
4. **Lazy loading**: For large widget trees, consider implementing custom lazy loading

## Examples

See the `/example` folder for complete example applications demonstrating:

- Basic widget building
- Dynamic UI updates
- Custom widget registration
- Widget tree manipulation
- Form building from JSON
- Theme and styling

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and version history.

## Support

If you have any questions or issues, please:

1. Check the [API documentation](https://pub.dev/documentation/json_ui_builder)
2. Look at the [examples](example/)
3. Search [existing issues](https://github.com/mahadydev/json_ui_builder/issues)
4. Create a [new issue](https://github.com/mahadydev/json_ui_builder/issues/new) if needed

## Roadmap

- [ ] Animation support
- [ ] State management integration
- [ ] Visual UI builder tool
- [ ] Additional Material Design widgets
- [ ] Cupertino widgets support
- [ ] Custom painter support
- [ ] Performance optimizations
- [ ] Hot reload support
