import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rtsp_player/widgets/pan_and_zoom.dart';
import 'package:rtsp_player/widgets/stream/stream_player_controller.dart';
import 'package:rtsp_player/widgets/stream/stream_player_controls.dart';

final class StreamPlayer extends StatefulWidget {
  final StreamPlayerController controller;
  final VoidCallback? onClose;

  const StreamPlayer({
    super.key,
    required this.controller,
    this.onClose,
  });

  @override
  State<StatefulWidget> createState() => _StreamPlayerState();
}

final class _StreamPlayerState extends State<StreamPlayer> {
  final List<StreamSubscription> _subscribers = [];
  double _aspectRatio = 1;

  @override
  void initState() {
    super.initState();

    _subscribers.add(widget.controller.sizeChange.listen((e) {
      setState(() {
        _aspectRatio = e.width / e.height;
      });
    }));
  }

  @override
  void dispose() async {
    super.dispose();

    for (var element in _subscribers) {
      await element.cancel();
    }
  }

  Size _aspectRatioSize(Size size) {
    if (size.width / size.height > _aspectRatio) {
      return Size(size.height * _aspectRatio, size.height);
    }

    return Size(size.width, size.width / _aspectRatio);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final Size videoSize = _aspectRatioSize(Size(
        constraints.constrainWidth(),
        constraints.constrainHeight(),
      ));

      return Stack(
        children: [
          Center(
            child: PanAndZoom(
              child: SizedBox(
                width: videoSize.width,
                height: videoSize.height,
                child: Video(
                  controller: widget.controller.videoController,
                  controls: null,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          StreamPlayerControls(
            controller: widget.controller,
            onClose: widget.onClose,
          ),
        ],
      );
    });
  }
}
