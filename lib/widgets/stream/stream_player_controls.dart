import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_stream_player/widgets/stream/stream_player_controller.dart';
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
      widget.controller.isBufferingChange,
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
  }) {
    return IconButton(
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
  }

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

  Widget _buildControlsLayer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildTopButtons(),
          Expanded(child: Container()),
          if (!widget.controller.isBuffering) _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildBufferingIndicator() {
    return Container(
      color: Colors.black.withOpacity(.8),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPauseIndicator() {
    return Container(
      color: Colors.black.withOpacity(.8),
      child: Center(
        child: Icon(
          Icons.pause,
          color: Colors.white.withOpacity(.65),
          size: 120,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!widget.controller.isPlaying) _buildPauseIndicator(),
        if (widget.controller.isBuffering) _buildBufferingIndicator(),
        _buildControlsLayer(),
      ],
    );
  }
}
