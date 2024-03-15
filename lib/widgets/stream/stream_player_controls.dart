import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rtsp_player/widgets/stream/stream_player_controller.dart';
import 'package:rxdart/rxdart.dart';

final class StreamPlayerControls extends StatefulWidget {
  final StreamPlayerController controller;

  const StreamPlayerControls({
    super.key,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _StreamPlayerControlsState();
}

final class _StreamPlayerControlsState extends State<StreamPlayerControls> {
  final List<StreamSubscription> _subscribers = [];

  @override
  void initState() {
    super.initState();

    _subscribers.add(MergeStream([
      widget.controller.isPlayingChange,
      widget.controller.isMutedChange,
    ]).listen((event) {
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

  Icon _createIcon(IconData iconData) => Icon(
        iconData,
        color: Colors.white,
        size: 28,
        shadows: const [
          Shadow(color: Colors.black, blurRadius: 3),
        ],
      );

  Widget _buildButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            widget.controller.playOrPause();
          },
          icon: _createIcon(widget.controller.isPlaying ? Icons.pause : Icons.play_arrow),
        ),
        IconButton(
          onPressed: () {
            widget.controller.muteOrUnmute();
          },
          icon: _createIcon(widget.controller.isMuted ? Icons.volume_off : Icons.volume_up),
        ),
        IconButton(
          onPressed: () {
            widget.controller.reload();
          },
          icon: _createIcon(Icons.refresh),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: _buildButtons(),
      ),
    );
  }
}
