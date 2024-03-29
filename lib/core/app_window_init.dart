import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/widgets.dart';
import 'package:tiny_stream_player/core/preferences.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initAppWindow() async {
  const initialSize = Size(300, 200);

  appWindow.minSize = initialSize;
  appWindow.alignment = Alignment.center;
  appWindow.title = 'Tiny Stream Player';

  // production build does not work with [[appWindow.size]]
  windowManager.setSize((await Preferences().windowSize.load()) ?? initialSize);

  final windowPosition = await Preferences().windowPosition.load();
  if (windowPosition != null) {
    await windowManager.setPosition(windowPosition);
  }

  await windowManager
      .setAlwaysOnTop(await Preferences().windowAlwaysOnTop.load());

  appWindow.show();
}
