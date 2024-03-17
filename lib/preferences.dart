import 'dart:convert';

import 'package:tiny_stream_player/widgets/stream/stream_player_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class Preferences {
  static final _singleton = Preferences._new();

  factory Preferences() => _singleton;

  Preferences._new();

  Future<void> saveStreams(List<StreamPlayerController> streams) async {
    final pref = await SharedPreferences.getInstance();
    final packedStreams = streams.map((e) => jsonEncode(e.toJson())).toList();

    await pref.setStringList('streams', ['1', ...packedStreams]);
  }

  Future<List<StreamPlayerController>> loadStreams() async {
    final pref = await SharedPreferences.getInstance();
    final packedStreams =
        pref.getStringList('streams')?.map((e) => jsonDecode(e)).toList() ?? [];

    if (packedStreams.isNotEmpty) {
      packedStreams.removeAt(0);
    }

    final List<StreamPlayerController> streams = [];

    for (var packedStream in packedStreams) {
      streams.add(await StreamPlayerController.fromJson(packedStream));
    }

    return streams;
  }
}
