import 'dart:convert';
import 'dart:ui';

import 'package:tiny_stream_player/widgets/stream/stream_player_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class Preferences {
  static final _singleton = Preferences._new();

  late final SharedPreferences preferences;

  StreamsPreference get streams => StreamsPreference(preferences);

  WindowSizePreference get windowSize => WindowSizePreference(preferences);

  WindowPositionPreference get windowPosition =>
      WindowPositionPreference(preferences);

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
            .toList() ??
        [];

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

final class WindowSizePreference extends Preference<Size> {
  WindowSizePreference(super.preferences);

  @override
  Future<Size?> load() async {
    final width = preferences.getDouble('window_width');
    final height = preferences.getDouble('window_height');

    if (width == null || height == null) {
      return null;
    }

    return Size(width, height);
  }

  @override
  Future<void> save(Size data) async {
    await preferences.setDouble('window_width', data.width);
    await preferences.setDouble('window_height', data.height);
  }
}

final class WindowPositionPreference extends Preference<Offset> {
  WindowPositionPreference(super.preferences);

  @override
  Future<Offset?> load() async {
    final x = preferences.getDouble('window_pos_x');
    final y = preferences.getDouble('window_pos_y');

    if (x == null || y == null) {
      return null;
    }

    return Offset(x, y);
  }

  @override
  Future<void> save(Offset data) async {
    await preferences.setDouble('window_pos_x', data.dx);
    await preferences.setDouble('window_pos_y', data.dy);
  }
}
