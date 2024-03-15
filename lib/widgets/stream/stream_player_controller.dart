import 'dart:ui';
import 'dart:async';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rxdart/rxdart.dart';

final class StreamPlayerController {
  final player = Player();
  late final videoController = VideoController(player);

  Size _size = const Size(1, 1);

  Size get size => _size;

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

  void open(String resource) async {
    await player.open(Media(resource));
  }

  void dispose() {
    player.dispose();
  }
}
