import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/widgets.dart';
import 'package:tiny_stream_player/core/preferences.dart';

Future<void> initAppWindow() async {
  const initialSize = Size(600, 450);

  appWindow.minSize = initialSize;
  appWindow.size = (await Preferences().windowSize.load()) ?? initialSize;
  appWindow.alignment = Alignment.center;
  appWindow.title = 'Tiny Stream Player';

  final windowPosition = await Preferences().windowPosition.load();

  if (windowPosition != null) {
    appWindow.position = windowPosition;
  }

  appWindow.show();

}
