import 'dart:convert';

import 'package:tiny_stream_player/widgets/stream/stream_player_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class Preferences {
  static final _singleton = Preferences._new();

  late final SharedPreferences preferences;

  StreamsPreference get streams => StreamsPreference(preferences);

  factory Preferences() => _singleton;

  Preferences._new();

  static Future<void> ensureInitialized() async {
    Preferences().preferences = await SharedPreferences.getInstance();
  }
}

abstract class Preference<T> {
  final SharedPreferences preferences;

  Preference(this.preferences);

  Future<void> save(T data);

  Future<T?> load();
}

final class StreamsPreference extends Preference<List<StreamPlayerController>> {
  StreamsPreference(super.preferences);

  @override
  Future<List<StreamPlayerController>> load() async {
    final packedStreams = preferences
            .getStringList('streams')
            ?.map((e) => jsonDecode(e))
            .toList() ?? [];

    if (packedStreams.isNotEmpty) {
      packedStreams.removeAt(0);
    }

    final List<StreamPlayerController> streams = [];

    for (var packedStream in packedStreams) {
      streams.add(await StreamPlayerController.fromJson(packedStream));
    }

    return streams;
  }

  @override
  Future<void> save(List<StreamPlayerController> data) async {
    final packedStreams = data.map((e) => jsonEncode(e.toJson())).toList();

    await preferences.setStringList('streams', ['1', ...packedStreams]);
  }
}
