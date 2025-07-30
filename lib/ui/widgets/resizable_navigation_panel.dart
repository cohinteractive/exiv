import 'package:flutter/material.dart';

class ResizableNavigationPanel extends StatefulWidget {
  const ResizableNavigationPanel({
    super.key,
    required this.navigation,
    required this.content,
  });

  final Widget navigation;
  final Widget content;

  @override
  State<ResizableNavigationPanel> createState() => _ResizableNavigationPanelState();
}

class _ResizableNavigationPanelState extends State<ResizableNavigationPanel> {
  double _width = 300;
  bool _hovering = false;

  void _updateWidth(double delta) {
    setState(() {
      _width += delta;
      if (_width < 200) _width = 200;
      if (_width > 500) _width = 500;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: _width, child: widget.navigation),
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) => _updateWidth(details.delta.dx),
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: _hovering
                    ? Colors.grey.withOpacity(0.3)
                    : Colors.transparent,
              ),
            ),
          ),
        ),
        Expanded(child: widget.content),
      ],
    );
  }
}
