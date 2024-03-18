import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tiny_stream_player/core/app_window_init.dart';
import 'package:tiny_stream_player/core/preferences.dart';
import 'package:tiny_stream_player/pages/main_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Preferences.ensureInitialized();
  await windowManager.ensureInitialized();

  runApp(MyApp());

  doWhenWindowReady(() {
    initAppWindow();
  });
}

class MyApp extends StatelessWidget with WindowListener {
  MyApp({super.key}) {
    windowManager.addListener(this);
  }

  @override
  void onWindowResized() {
    super.onWindowResized();

    if (!appWindow.isMaximized) {
      Preferences().windowSize.save(appWindow.size);
      Preferences().windowPosition.save(appWindow.position);
    }
  }

  @override
  void onWindowMoved() {
    super.onWindowMoved();

    if (!appWindow.isMaximized) {
      Preferences().windowPosition.save(appWindow.position);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiny Stream Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}
