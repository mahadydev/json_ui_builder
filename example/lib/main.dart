import 'package:flutter/material.dart';
import 'package:json_ui_builder/json_ui_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON UI Builder Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const JsonUIDemo(),
    );
  }
}

class JsonUIDemo extends StatefulWidget {
  const JsonUIDemo({super.key});

  @override
  State<JsonUIDemo> createState() => _JsonUIDemoState();
}

class _JsonUIDemoState extends State<JsonUIDemo> {
  final JsonUIBuilder _builder = JsonUIBuilder();
  int _selectedExample = 0;

  final List<Map<String, dynamic>> _examples = [
    {
      'name': 'Basic Layout',
      'json': {
        'type': 'Column',
        'id': 'main_column',
        'properties': {
          'mainAxisAlignment': 'center',
          'padding': {'all': 16},
        },
        'children': [
          {
            'type': 'Text',
            'id': 'title',
            'properties': {
              'text': 'Welcome to JSON UI Builder!',
              'style': {
                'fontSize': 24,
                'fontWeight': 'bold',
                'color': '#2196F3',
              },
            },
          },
          {
            'type': 'SizedBox',
            'properties': {'height': 20},
          },
          {
            'type': 'Text',
            'properties': {
              'text': 'Build Flutter UIs from JSON configurations',
              'style': {'fontSize': 16, 'color': '#666666'},
            },
          },
          {
            'type': 'SizedBox',
            'properties': {'height': 30},
          },
          {
            'type': 'ElevatedButton',
            'id': 'demo_button',
            'properties': {'text': 'Get Started'},
          },
        ],
      },
    },
    {
      'name': 'Card Layout',
      'json': {
        'type': 'Padding',
        'properties': {
          'padding': {'all': 16},
        },
        'child': {
          'type': 'Card',
          'properties': {
            'elevation': 8,
            'margin': {'all': 0},
          },
          'child': {
            'type': 'Padding',
            'properties': {
              'padding': {'all': 20},
            },
            'child': {
              'type': 'Column',
              'properties': {
                'crossAxisAlignment': 'start',
                'mainAxisSize': 'min',
              },
              'children': [
                {
                  'type': 'Row',
                  'children': [
                    {
                      'type': 'CircleAvatar',
                      'properties': {
                        'radius': 25,
                        'backgroundColor': '#2196F3',
                      },
                    },
                    {
                      'type': 'SizedBox',
                      'properties': {'width': 16},
                    },
                    {
                      'type': 'Expanded',
                      'child': {
                        'type': 'Column',
                        'properties': {
                          'crossAxisAlignment': 'start',
                          'mainAxisSize': 'min',
                        },
                        'children': [
                          {
                            'type': 'Text',
                            'properties': {
                              'text': 'John Doe',
                              'style': {'fontSize': 18, 'fontWeight': 'bold'},
                            },
                          },
                          {
                            'type': 'Text',
                            'properties': {
                              'text': 'Flutter Developer',
                              'style': {'fontSize': 14, 'color': '#666666'},
                            },
                          },
                        ],
                      },
                    },
                  ],
                },
                {
                  'type': 'SizedBox',
                  'properties': {'height': 16},
                },
                {
                  'type': 'Text',
                  'properties': {
                    'text':
                        'Building amazing mobile applications with Flutter and creating dynamic UIs with JSON configurations.',
                    'style': {'fontSize': 14, 'height': 1.5},
                  },
                },
                {
                  'type': 'SizedBox',
                  'properties': {'height': 20},
                },
                {
                  'type': 'Row',
                  'properties': {'mainAxisAlignment': 'end'},
                  'children': [
                    {
                      'type': 'TextButton',
                      'properties': {'text': 'Contact'},
                    },
                    {
                      'type': 'SizedBox',
                      'properties': {'width': 8},
                    },
                    {
                      'type': 'ElevatedButton',
                      'properties': {'text': 'View Profile'},
                    },
                  ],
                },
              ],
            },
          },
        },
      },
    },
    {
      'name': 'Form Example',
      'json': {
        'type': 'Padding',
        'properties': {
          'padding': {'all': 20},
        },
        'child': {
          'type': 'Column',
          'properties': {'crossAxisAlignment': 'stretch'},
          'children': [
            {
              'type': 'Text',
              'properties': {
                'text': 'User Registration',
                'style': {'fontSize': 24, 'fontWeight': 'bold'},
              },
            },
            {
              'type': 'SizedBox',
              'properties': {'height': 20},
            },
            {
              'type': 'TextField',
              'properties': {
                'hintText': 'Enter your name',
                'labelText': 'Full Name',
              },
            },
            {
              'type': 'SizedBox',
              'properties': {'height': 16},
            },
            {
              'type': 'TextField',
              'properties': {
                'hintText': 'Enter your email',
                'labelText': 'Email Address',
              },
            },
            {
              'type': 'SizedBox',
              'properties': {'height': 16},
            },
            {
              'type': 'TextField',
              'properties': {
                'hintText': 'Enter your password',
                'labelText': 'Password',
                'obscureText': true,
              },
            },
            {
              'type': 'SizedBox',
              'properties': {'height': 20},
            },
            {
              'type': 'Row',
              'children': [
                {
                  'type': 'Checkbox',
                  'properties': {'value': false},
                },
                {
                  'type': 'Expanded',
                  'child': {
                    'type': 'Text',
                    'properties': {
                      'text': 'I agree to the terms and conditions',
                    },
                  },
                },
              ],
            },
            {
              'type': 'SizedBox',
              'properties': {'height': 30},
            },
            {
              'type': 'ElevatedButton',
              'properties': {'text': 'Register'},
            },
          ],
        },
      },
    },
    {
      'name': 'Grid Layout',
      'json': {
        'type': 'SizedBox',
        'properties': {'height': 800},
        'child': {
          'type': 'Padding',
          'properties': {
            'padding': {'all': 16},
          },
          'child': {
            'type': 'GridView',
            'properties': {
              'crossAxisCount': 2,
              'crossAxisSpacing': 16,
              'mainAxisSpacing': 16,
              'childAspectRatio': 1.2,
            },
            'children': [
              {
                'type': 'Card',
                'child': {
                  'type': 'Padding',
                  'properties': {
                    'padding': {'all': 16},
                  },
                  'child': {
                    'type': 'Column',
                    'properties': {'mainAxisAlignment': 'center'},
                    'children': [
                      {
                        'type': 'Icon',
                        'properties': {
                          'icon': 'home',
                          'size': 48,
                          'color': '#2196F3',
                        },
                      },
                      {
                        'type': 'SizedBox',
                        'properties': {'height': 8},
                      },
                      {
                        'type': 'Text',
                        'properties': {
                          'text': 'Home',
                          'style': {'fontWeight': 'bold'},
                        },
                      },
                    ],
                  },
                },
              },
              {
                'type': 'Card',
                'child': {
                  'type': 'Padding',
                  'properties': {
                    'padding': {'all': 16},
                  },
                  'child': {
                    'type': 'Column',
                    'properties': {'mainAxisAlignment': 'center'},
                    'children': [
                      {
                        'type': 'Icon',
                        'properties': {
                          'icon': 'person',
                          'size': 48,
                          'color': '#4CAF50',
                        },
                      },
                      {
                        'type': 'SizedBox',
                        'properties': {'height': 8},
                      },
                      {
                        'type': 'Text',
                        'properties': {
                          'text': 'Profile',
                          'style': {'fontWeight': 'bold'},
                        },
                      },
                    ],
                  },
                },
              },
              {
                'type': 'Card',
                'child': {
                  'type': 'Padding',
                  'properties': {
                    'padding': {'all': 16},
                  },
                  'child': {
                    'type': 'Column',
                    'properties': {'mainAxisAlignment': 'center'},
                    'children': [
                      {
                        'type': 'Icon',
                        'properties': {
                          'icon': 'settings',
                          'size': 48,
                          'color': '#FF9800',
                        },
                      },
                      {
                        'type': 'SizedBox',
                        'properties': {'height': 8},
                      },
                      {
                        'type': 'Text',
                        'properties': {
                          'text': 'Settings',
                          'style': {'fontWeight': 'bold'},
                        },
                      },
                    ],
                  },
                },
              },
              {
                'type': 'Card',
                'child': {
                  'type': 'Padding',
                  'properties': {
                    'padding': {'all': 16},
                  },
                  'child': {
                    'type': 'Column',
                    'properties': {'mainAxisAlignment': 'center'},
                    'children': [
                      {
                        'type': 'Icon',
                        'properties': {
                          'icon': 'help',
                          'size': 48,
                          'color': '#F44336',
                        },
                      },
                      {
                        'type': 'SizedBox',
                        'properties': {'height': 8},
                      },
                      {
                        'type': 'Text',
                        'properties': {
                          'text': 'Help',
                          'style': {'fontWeight': 'bold'},
                        },
                      },
                    ],
                  },
                },
              },
            ],
          },
        },
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON UI Builder Demo'), elevation: 0),
      body: Column(
        children: [
          // Example selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _examples.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedExample;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(_examples[index]['name']),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedExample = index;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // JSON UI Content
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: _builder.buildFromJson(
                  _examples[_selectedExample]['json'],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showJsonDialog(context);
        },
        tooltip: 'View JSON',
        child: const Icon(Icons.code),
      ),
    );
  }

  void _showJsonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'JSON Configuration - ${_examples[_selectedExample]['name']}',
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              _prettyPrintJson(_examples[_selectedExample]['json']),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _prettyPrintJson(Map<String, dynamic> json) {
    // Simple JSON pretty printer
    return json
        .toString()
        .replaceAllMapped(
          RegExp(r'(\{|\[|,)'),
          (match) => '${match.group(0)}\n',
        )
        .replaceAllMapped(RegExp(r'(\}|\])'), (match) => '\n${match.group(0)}');
  }
}
