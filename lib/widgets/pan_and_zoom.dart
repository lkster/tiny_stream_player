import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final class PanAndZoom extends StatefulWidget {
  Widget child;
  final double minZoom = 1;
  final double maxZoom = 5;
  final double zoomFactor = 0.1;

  PanAndZoom({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _PanAndZoomWidgetState();
}

final class _PanAndZoomWidgetState extends State<PanAndZoom> with WidgetsBindingObserver {
  double scale = 1;
  Offset position = const Offset(0, 0);
  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _parentKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    _fixPosition();
  }

  void _onScrollWheel(PointerScrollEvent e) {
    final delta = e.scrollDelta.dy / 100;

    setState(() {
      scale *= 1 + widget.zoomFactor * -delta;
      scale = scale.clamp(widget.minZoom, widget.maxZoom);
      _fixPosition();
    });
  }

  void _onPan(DragUpdateDetails details) {
    final deltaOffset = details.delta / scale;
    final parentSize = _getParentSize();
    final childSize = _getChildSize();
    var (double posX, double posY) = (0, 0);

    if (childSize.width * scale > parentSize.width) {
      posX = position.dx + deltaOffset.dx;
    }

    if (childSize.height * scale > parentSize.height) {
      posY = position.dy + deltaOffset.dy;
    }

    setState(() {
      position = Offset(posX, posY);
      _fixPosition();
    });
  }

  void _fixPosition() {
    final parentSize = _getParentSize();
    final childSize = _getChildSize();

    final boundary = Offset(
      max(childSize.width * scale - parentSize.width, 0) / scale / 2,
      max(childSize.height * scale - parentSize.height, 0) / scale / 2,
    );

    position = Offset(
      position.dx.clamp(-boundary.dx, boundary.dx),
      position.dy.clamp(-boundary.dy, boundary.dy),
    );
  }

  Size _getChildSize() {
    final render = _childKey.currentContext?.findRenderObject();

    if (render == null) {
      return const Size(0, 0);
    }

    return (render as RenderBox).size;
  }

  Size _getParentSize() {
    final render = _parentKey.currentContext?.findRenderObject();

    if (render == null) {
      return const Size(double.infinity, double.infinity);
    }

    return (render as RenderBox).size;
  }

  Widget _buildInputListener(Widget child) {
    return Listener(
      onPointerSignal: (e) {
        if (e is PointerScrollEvent) {
          _onScrollWheel(e);
        }
      },
      child: GestureDetector(
        onPanUpdate: _onPan,
        child: child,
      ),
    );
  }

  Widget _buildTransform(Widget child) {
    return Transform.scale(
      scale: scale,
      child: Transform.translate(
        offset: position,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildInputListener(
      ClipRect(
        child: Container(
          key: _parentKey,
          color: Colors.black,
          child: _buildTransform(
            Center(
                child: Container(
              key: _childKey,
              child: widget.child,
            )),
          ),
        ),
      ),
    );
  }
}
