import 'package:flutter/material.dart';

class ResizableWidget extends StatefulWidget {
  const ResizableWidget({
    super.key,
    required this.child,
    this.initialWidth = 300,
    this.minWidth = 200,
    this.maxWidth = 500,
  });

  final Widget child;
  final double initialWidth;
  final double minWidth;
  final double maxWidth;

  @override
  State<ResizableWidget> createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  late double _width;

  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
  }

  void _updateWidth(double delta) {
    setState(() {
      _width += delta;
      if (_width < widget.minWidth) _width = widget.minWidth;
      if (_width > widget.maxWidth) _width = widget.maxWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: _width, child: widget.child),
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) => _updateWidth(details.delta.dx),
            child: Container(
              width: 6,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
      ],
    );
  }
}
