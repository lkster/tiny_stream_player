import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rtsp_player/widgets/stream/stream_player_controller.dart';

final class StreamPlayer extends StatefulWidget {
  final StreamPlayerController controller;

  const StreamPlayer({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _StreamPlayerState();
}

final class _StreamPlayerState extends State<StreamPlayer> {
  double _aspectRatio = 1;

  @override
  void initState() {
    super.initState();

    widget.controller.sizeChange.listen((e) {
      setState(() {
        _aspectRatio = e.width / e.height;
      });
    });
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

      return Center(
        child: SizedBox(
          width: videoSize.width,
          height: videoSize.height,
          child: Video(
            controller: widget.controller.videoController,
            controls: null,
            fit: BoxFit.fill,
          ),
        ),
      );
    });
  }
}
