import 'package:flutter/material.dart';

class DropTargetWidget extends StatelessWidget {
  final Map<String, dynamic> config;
  final Widget child;
  final void Function(String parentId, String widgetType)? onDrop;

  const DropTargetWidget({
    required this.config,
    required this.child,
    this.onDrop,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use config['id'] for the parentId
    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (data) {
        if (onDrop != null) {
          onDrop!(config['id'] ?? '', data.data['type'] as String);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isDraggingOver = candidateData.isNotEmpty;
        return Container(
          decoration: isDraggingOver
              ? BoxDecoration(border: Border.all(color: Colors.blue, width: 2))
              : null,
          child: child,
        );
      },
    );
  }
}
