import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_ui_builder/json_ui_builder.dart';

void main() {
  group('JsonUIBuilder', () {
    late JsonUIBuilder builder;

    setUp(() {
      builder = JsonUIBuilder();
    });

    test('should build simple text widget from JSON', () {
      final json = {
        'type': 'Text',
        'properties': {'text': 'Hello, World!'},
      };

      final widget = builder.buildFromJson(json);
      expect(widget, isA<Text>());
    });

    test('should build container with child from JSON', () {
      final json = {
        'type': 'Container',
        'properties': {'width': 100.0, 'height': 100.0, 'color': '#FF0000'},
        'child': {
          'type': 'Text',
          'properties': {'text': 'Child text'},
        },
      };

      final widget = builder.buildFromJson(json);
      expect(widget, isA<Container>());
    });

    test('should build column with multiple children', () {
      final json = {
        'type': 'Column',
        'children': [
          {
            'type': 'Text',
            'properties': {'text': 'First child'},
          },
          {
            'type': 'Text',
            'properties': {'text': 'Second child'},
          },
        ],
      };

      final widget = builder.buildFromJson(json);
      expect(widget, isA<Column>());
    });

    test('should validate JSON configuration', () {
      final validJson = {
        'type': 'Text',
        'properties': {'text': 'Valid text'},
      };

      final invalidJson = {
        'properties': {'text': 'Missing type'},
      };

      expect(builder.validateJson(validJson), isTrue);
      expect(builder.validateJson(invalidJson), isFalse);
    });

    test('should convert WidgetConfig to JSON', () {
      final config = WidgetConfig(
        type: 'Text',
        properties: {'text': 'Test text'},
      );

      final json = builder.configToJson(config);
      expect(json['type'], equals('Text'));
      expect(json['properties']['text'], equals('Test text'));
    });

    test('should find widget by ID', () {
      final config = WidgetConfig(
        type: 'Container',
        id: 'container_1',
        child: WidgetConfig(
          type: 'Text',
          id: 'text_1',
          properties: {'text': 'Hello'},
        ),
      );

      final foundWidget = builder.findWidgetById(config, 'text_1');
      expect(foundWidget, isNotNull);
      expect(foundWidget!.type, equals('Text'));
    });

    test('should update widget by ID', () {
      final config = WidgetConfig(
        type: 'Container',
        id: 'container_1',
        child: WidgetConfig(
          type: 'Text',
          id: 'text_1',
          properties: {'text': 'Hello'},
        ),
      );

      final newConfig = WidgetConfig(
        type: 'Text',
        id: 'text_1',
        properties: {'text': 'Updated'},
      );

      final updated = builder.updateWidgetById(config, 'text_1', newConfig);
      expect(updated, isTrue);
      expect(config.child!.properties['text'], equals('Updated'));
    });

    test('should remove widget by ID', () {
      final config = WidgetConfig(
        type: 'Column',
        id: 'column_1',
        children: [
          WidgetConfig(
            type: 'Text',
            id: 'text_1',
            properties: {'text': 'First'},
          ),
          WidgetConfig(
            type: 'Text',
            id: 'text_2',
            properties: {'text': 'Second'},
          ),
        ],
      );

      final removed = builder.removeWidgetById(config, 'text_1');
      expect(removed, isTrue);
      expect(config.children!.length, equals(1));
      expect(config.children!.first.id, equals('text_2'));
    });

    test('should get all widget IDs', () {
      final config = WidgetConfig(
        type: 'Container',
        id: 'container_1',
        child: WidgetConfig(
          type: 'Column',
          id: 'column_1',
          children: [
            WidgetConfig(
              type: 'Text',
              id: 'text_1',
              properties: {'text': 'First'},
            ),
            WidgetConfig(
              type: 'Text',
              id: 'text_2',
              properties: {'text': 'Second'},
            ),
          ],
        ),
      );

      final ids = builder.getAllWidgetIds(config);
      expect(ids, contains('container_1'));
      expect(ids, contains('column_1'));
      expect(ids, contains('text_1'));
      expect(ids, contains('text_2'));
      expect(ids.length, equals(4));
    });

    test('should handle custom widget registration', () {
      builder.registerCustomWidget(
        'CustomWidget',
        // ignore: avoid_unnecessary_containers
        (config) => Container(
          child: Text(config.getProperty<String>('customText') ?? ''),
        ),
        ['customText'],
      );

      expect(builder.isWidgetTypeSupported('CustomWidget'), isTrue);
      expect(
        builder.getSupportedProperties('CustomWidget'),
        contains('customText'),
      );

      final json = {
        'type': 'CustomWidget',
        'properties': {'customText': 'Custom content'},
      };

      final widget = builder.buildFromJson(json);
      expect(widget, isA<Container>());
    });

    test('should get package information', () {
      final info = builder.getPackageInfo();
      expect(info['version'], isNotNull);
      expect(info['initialized'], isTrue);
      expect(info['supported_widgets'], greaterThan(0));
    });
  });

  group('WidgetConfig', () {
    test('should create from JSON', () {
      final json = {
        'type': 'Text',
        'id': 'text_1',
        'properties': {'text': 'Hello'},
      };

      final config = WidgetConfig.fromJson(json);
      expect(config.type, equals('Text'));
      expect(config.id, equals('text_1'));
      expect(config.properties['text'], equals('Hello'));
    });

    test('should convert to JSON', () {
      final config = WidgetConfig(
        type: 'Text',
        id: 'text_1',
        properties: {'text': 'Hello'},
      );

      final json = config.toJson();
      expect(json['type'], equals('Text'));
      expect(json['id'], equals('text_1'));
      expect(json['properties']['text'], equals('Hello'));
    });

    test('should handle property operations', () {
      final config = WidgetConfig(
        type: 'Text',
        properties: {'text': 'Hello', 'fontSize': 16.0},
      );

      expect(config.getProperty<String>('text'), equals('Hello'));
      expect(config.getProperty<double>('fontSize'), equals(16.0));
      expect(config.hasProperty('text'), isTrue);
      expect(config.hasProperty('nonexistent'), isFalse);

      config.setProperty('text', 'Updated');
      expect(config.getProperty<String>('text'), equals('Updated'));

      config.removeProperty('fontSize');
      expect(config.hasProperty('fontSize'), isFalse);
    });

    test('should handle child operations', () {
      final config = WidgetConfig(type: 'Container', children: []);

      final childConfig = WidgetConfig(
        type: 'Text',
        id: 'text_1',
        properties: {'text': 'Child'},
      );

      config.addChild(childConfig);
      expect(config.childCount, equals(1));

      final removed = config.removeChild('text_1');
      expect(removed, isTrue);
      expect(config.childCount, equals(0));
    });

    test('should copy with modifications', () {
      final original = WidgetConfig(
        type: 'Text',
        id: 'original',
        properties: {'text': 'Original'},
      );

      final copied = original.copyWith(
        id: 'copied',
        properties: {'text': 'Copied'},
      );

      expect(copied.type, equals('Text'));
      expect(copied.id, equals('copied'));
      expect(copied.properties['text'], equals('Copied'));
      expect(original.id, equals('original'));
    });
  });

  group('Validation', () {
    test('should validate color values', () {
      expect(ValidationUtils.isValidColor('#FF0000'), isTrue);
      expect(ValidationUtils.isValidColor('#FFFF0000'), isTrue);
      expect(ValidationUtils.isValidColor('FF0000'), isTrue);
      expect(ValidationUtils.isValidColor('invalid'), isFalse);
      expect(ValidationUtils.isValidColor(''), isFalse);
    });

    test('should validate dimensions', () {
      expect(ValidationUtils.isValidDimension(100), isTrue);
      expect(ValidationUtils.isValidDimension(100.0), isTrue);
      expect(ValidationUtils.isValidDimension('100'), isTrue);
      expect(ValidationUtils.isValidDimension('50%'), isTrue);
      expect(ValidationUtils.isValidDimension('auto'), isTrue);
      expect(ValidationUtils.isValidDimension(-10), isFalse);
    });

    test('should validate boolean values', () {
      expect(ValidationUtils.isValidBoolean(true), isTrue);
      expect(ValidationUtils.isValidBoolean(false), isTrue);
      expect(ValidationUtils.isValidBoolean('true'), isTrue);
      expect(ValidationUtils.isValidBoolean('false'), isTrue);
      expect(ValidationUtils.isValidBoolean('invalid'), isFalse);
    });

    test('should parse boolean values', () {
      expect(ValidationUtils.parseBool(true), isTrue);
      expect(ValidationUtils.parseBool('true'), isTrue);
      expect(ValidationUtils.parseBool('TRUE'), isTrue);
      expect(ValidationUtils.parseBool(false), isFalse);
      expect(ValidationUtils.parseBool('false'), isFalse);
      expect(ValidationUtils.parseBool('FALSE'), isFalse);
      expect(ValidationUtils.parseBool('invalid'), isNull);
    });
  });

  group('Widget Utils', () {
    test('should parse colors correctly', () {
      expect(
        WidgetUtils.parseColor('#FF0000'),
        equals(const Color(0xFFFF0000)),
      );
      expect(
        WidgetUtils.parseColor('#FFFF0000'),
        equals(const Color(0xFFFF0000)),
      );
      expect(WidgetUtils.parseColor('FF0000'), equals(const Color(0xFFFF0000)));
      expect(WidgetUtils.parseColor('invalid'), isNull);
    });

    test('should parse dimensions correctly', () {
      expect(WidgetUtils.parseDimension(100), equals(100.0));
      expect(WidgetUtils.parseDimension(100.5), equals(100.5));
      expect(WidgetUtils.parseDimension('100'), equals(100.0));
      expect(WidgetUtils.parseDimension('50%', parentSize: 200), equals(100.0));
      expect(WidgetUtils.parseDimension('auto'), isNull);
    });

    test('should parse EdgeInsets correctly', () {
      final padding1 = WidgetUtils.parseEdgeInsets(10);
      expect(padding1, equals(const EdgeInsets.all(10)));

      final padding2 = WidgetUtils.parseEdgeInsets([10, 20]);
      expect(
        padding2,
        equals(const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
      );

      final padding3 = WidgetUtils.parseEdgeInsets([10, 20, 30, 40]);
      expect(
        padding3,
        equals(const EdgeInsets.only(top: 10, right: 20, bottom: 30, left: 40)),
      );

      final padding4 = WidgetUtils.parseEdgeInsets({
        'top': 10,
        'right': 20,
        'bottom': 30,
        'left': 40,
      });
      expect(
        padding4,
        equals(const EdgeInsets.only(top: 10, right: 20, bottom: 30, left: 40)),
      );
    });

    test('should parse alignments correctly', () {
      expect(WidgetUtils.parseAlignment('center'), equals(Alignment.center));
      expect(WidgetUtils.parseAlignment('topLeft'), equals(Alignment.topLeft));
      expect(
        WidgetUtils.parseAlignment('bottomRight'),
        equals(Alignment.bottomRight),
      );
      expect(WidgetUtils.parseAlignment('invalid'), isNull);
    });
  });
}
