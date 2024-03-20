import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:window_manager/window_manager.dart';

final class PanAndZoom extends StatefulWidget {
  Widget child;
  final double minZoom = 1;
  final double maxZoom = 15;
  final double zoomFactor = 0.1;

  PanAndZoom({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _PanAndZoomWidgetState();
}

final class _PanAndZoomWidgetState extends State<PanAndZoom>
    with WindowListener {
  double scale = 1;
  Offset position = const Offset(0, 0);
  Offset _cachedPosition = const Offset(0, 0);
  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _parentKey = GlobalKey();
  late Size _previousChildSize;
  bool _listenForSizeChangeOnce = false;

  @override
  void initState() {
    super.initState();

    _previousChildSize = _getChildSize();

    windowManager.addListener(this);
  }

  @override
  void dispose() {
    super.dispose();

    windowManager.removeListener(this);
  }

  @override
  void onWindowResize() {
    super.onWindowResize();

    _recalculatePositionAfterChildSizeChange();
  }

  @override
  void onWindowMaximize() {
    _listenForSizeChangeOnce = true;

    super.onWindowMaximize();
  }

  @override
  void onWindowUnmaximize() {
    _listenForSizeChangeOnce = true;

    super.onWindowUnmaximize();
  }

  void moveCanvasBy(Offset offset) {
    setState(() {
      position += offset;
      _cachedPosition = position;
      _fixPosition();
    });
  }

  void scaleCanvasBy(double factor) {
    setState(() {
      scale = (scale * factor).clamp(widget.minZoom, widget.maxZoom);
      _fixPosition();
    });
  }

  void _recalculatePositionAfterChildSizeChange() {
    final currentChildSize = _getChildSize();
    final Offset delta = Offset(
      currentChildSize.width / _previousChildSize.width,
      currentChildSize.height / _previousChildSize.height,
    );

    setState(() {
      _cachedPosition = _cachedPosition.scale(delta.dx, delta.dy);
      _previousChildSize = currentChildSize;
      position = _cachedPosition;
      _fixPosition();
    });
  }

  void _onScrollWheel(PointerScrollEvent e) {
    final delta = e.scrollDelta.dy / 100;
    final oldScale = scale;

    scaleCanvasBy(1 + widget.zoomFactor * -delta);

    final scalePoint = e.localPosition - _getParentSize().center(Offset.zero);
    final oldScaleScalePoint = scalePoint / oldScale;
    final newScaleScalePoint = scalePoint / scale;

    _previousChildSize = _getChildSize();

    moveCanvasBy((newScaleScalePoint - oldScaleScalePoint));
  }

  void _onPan(DragUpdateDetails details) {
    final deltaOffset = details.delta / scale;

    _previousChildSize = _getChildSize();

    moveCanvasBy(deltaOffset);
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
    return Transform(
      transform: Matrix4.identity()
        ..scale(scale)
        ..translate(position.dx, position.dy),
      alignment: FractionalOffset.center,
      child: child,
    );
  }

  /// [onWindowMaximize] and [onWindowUnmaximize] is fired before render actually happens hence there's a need
  /// to somehow listen for one change and update child's size once it's been changed
  Widget _buildSizeChangeListener(Widget child) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        if (!_listenForSizeChangeOnce) {
          return false;
        }

        _listenForSizeChangeOnce = false;

        Future.microtask(() => _recalculatePositionAfterChildSizeChange());

        return false;
      },
      child: SizeChangedLayoutNotifier(
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
                child: _buildSizeChangeListener(widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
