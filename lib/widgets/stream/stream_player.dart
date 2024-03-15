import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rtsp_player/widgets/stream/stream_player_controller.dart';
import 'package:rtsp_player/widgets/stream/stream_player_controls.dart';

final class StreamPlayer extends StatefulWidget {
  final StreamPlayerController controller;

  const StreamPlayer({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _StreamPlayerState();
}

final class _StreamPlayerState extends State<StreamPlayer> {
  final List<StreamSubscription> _subscribers = [];
  double _aspectRatio = 1;

  @override
  void initState() {
    super.initState();

    _subscribers
      ..add(widget.controller.sizeChange.listen((e) {
        setState(() {
          _aspectRatio = e.width / e.height;
        });
      }))
      ..add(widget.controller.isBufferingChange.listen((e) {
        setState(() {});
      }))
      ..add(widget.controller.isPlayingChange.listen((e) {
        setState(() {});
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

      final bufferingIndicator = Container(
        color: Colors.black.withOpacity(.8),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );

      final pauseIndicator = Container(
        color: Colors.black.withOpacity(.8),
        child: Center(
          child: Icon(
            Icons.pause,
            color: Colors.white.withOpacity(.65),
            size: 120,
          ),
        ),
      );

      return Stack(
        children: [
          Center(
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
          if (widget.controller.isBuffering) bufferingIndicator,
          if (!widget.controller.isPlaying) pauseIndicator,
          if (!widget.controller.isBuffering)
            StreamPlayerControls(controller: widget.controller),
        ],
      );
    });
  }
}
