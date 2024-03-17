import 'dart:ui';
import 'dart:async';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rxdart/rxdart.dart';

final class StreamPlayerController {
  final player = Player();
  late final videoController = VideoController(player);

  Size _size = const Size(1, 1);
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isBuffering = false;
  String? _currentResource;

  Size get size => _size;
  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  bool get isBuffering => _isBuffering;

  late final Stream<Size> sizeChange = ZipStream.list(
    [
      player.stream.width,
      player.stream.height,
    ],
  ).map(
    (List<int?> values) => Size(
      values[0]?.toDouble() ?? 1,
      values[1]?.toDouble() ?? 1,
    ),
  ).doOnData((event) {
    _size = event;
  }).asBroadcastStream();

  late final Stream<bool> isPlayingChange = player.stream.playing.doOnData(
    (event) {
      _isPlaying = event;
    },
  ).asBroadcastStream();

  late final Stream<bool> isMutedChange = player.stream.volume.map(
    (event) => event > 0 ? false : true,
  ).doOnData((event) {
    _isMuted = event;
  }).asBroadcastStream();

  late final Stream<bool> isBufferingChange = player.stream.buffering.doOnData(
    (event) {
      _isBuffering = event;
    }
  ).asBroadcastStream();

  Future<void> open(String resource) async {
    _currentResource = resource;
    await player.open(Media(resource));
  }

  Future<void> playOrPause() async {
    await player.playOrPause();
  }

  Future<void> muteOrUnmute() async {
    await player.setVolume(player.state.volume > 0 ? 0 : 100);
  }

  Future<void> reload() async {
    if (_currentResource == null) {
      return;
    }

    await player.remove(0);
    await open(_currentResource!);
  }

  Future<void> dispose() async {
    await player.dispose();
  }
}
