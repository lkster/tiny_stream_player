import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rtsp_player/widgets/stream/stream_player_controller.dart';
import 'package:rxdart/rxdart.dart';

final class StreamPlayerControls extends StatefulWidget {
  final StreamPlayerController controller;
  final VoidCallback? onClose;

  const StreamPlayerControls({
    super.key,
    required this.controller,
    this.onClose,
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

  IconButton _createIconButton({
    required VoidCallback onPressed,
    required IconData icon,
  }) =>
      IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 28,
          shadows: const [
            Shadow(color: Colors.black, blurRadius: 3),
            Shadow(color: Colors.black, blurRadius: 3),
          ],
        ),
      );

  Widget _buildTopButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _createIconButton(
          onPressed: widget.onClose ?? () {},
          icon: Icons.close,
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        _createIconButton(
          onPressed: () {
            widget.controller.playOrPause();
          },
          icon: widget.controller.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        _createIconButton(
          onPressed: () {
            widget.controller.muteOrUnmute();
          },
          icon: widget.controller.isMuted ? Icons.volume_off : Icons.volume_up,
        ),
        _createIconButton(
          onPressed: () {
            widget.controller.reload();
          },
          icon: Icons.refresh,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildTopButtons(),
          Expanded(child: Container()),
          _buildBottomButtons(),
        ],
      ),
    );
  }
}
