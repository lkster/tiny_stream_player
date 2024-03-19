import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/preferences.dart';
import 'package:tiny_stream_player/widgets/add_stream_modal.dart';
import 'package:tiny_stream_player/widgets/layout/button.dart';
import 'package:tiny_stream_player/widgets/layout/drawer.dart';
import 'package:tiny_stream_player/widgets/layout/drawer_button.dart';
import 'package:tiny_stream_player/widgets/stream/multi_stream_viewer.dart';
import 'package:tiny_stream_player/widgets/stream/stream_player.dart';
import 'package:tiny_stream_player/widgets/stream/stream_player_controller.dart';

import 'package:tiny_stream_player/widgets/window/window_scene.dart';
import 'package:window_manager/window_manager.dart';

import '../core/colors.dart';

final class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

final class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<AddStreamModalState> _addStreamModalKey = GlobalKey();
  final GlobalKey<TspDrawerState> _drawerKey = GlobalKey();
  bool _areStreamsLoadedFromPreferences = false;
  List<StreamPlayerController> streams = [];
  final List<StreamSubscription> _subscribers = [];
  bool _isAlwaysOnTop = false;

  @override
  void initState() {
    super.initState();

    _initStreams();

    windowManager.isAlwaysOnTop().then((value) => _isAlwaysOnTop = value);
  }

  @override
  void dispose() async {
    super.dispose();

    for (var element in streams) {
      await element.dispose();
    }

    for (var element in _subscribers) {
      element.cancel();
    }
  }

  void _initStreams() async {
    streams = await Preferences().streams.load();

    for (var stream in streams) {
      _subscribers.add(stream.isMutedChange.listen((event) async {
        await Preferences().streams.save(streams);
      }));
    }

    setState(() {
      _areStreamsLoadedFromPreferences = true;
    });
  }

  void _addNewStream(String resource) async {
    streams.add(StreamPlayerController()..open(resource));
    await Preferences().streams.save(streams);
  }

  void _removeStream(int index) async {
    if (index.clamp(0, streams.length - 1) != index) {
      return;
    }

    final controller = streams[index];

    controller.dispose();
    streams.removeAt(index);

    await Preferences().streams.save(streams);

    setState(() {});
  }

  Widget _buildNoStreamsView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No streams yet :(',
            style: TextStyle(color: Colors.white54),
          ),
          Container(height: 15),
          TspButton.primary(
            onPressed: () {
              _addStreamModalKey.currentState!.openModal();
            },
            child: const Text('Add Stream'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    late final Widget streamsView;

    if (streams.isNotEmpty) {
      final streamPlayers = streams
          .asMap()
          .entries
          .map(
            (entry) => StreamPlayer(
              controller: entry.value,
              onClose: () {
                _removeStream(entry.key);
              },
            ),
          )
          .toList();

      streamsView = MultiStreamViewer(
        children: streamPlayers,
      );
    } else {
      streamsView = _buildNoStreamsView();
    }

    if (!_areStreamsLoadedFromPreferences) {
      return Container();
    }

    return Stack(
      children: [
        streamsView,
        AddStreamModal(
          key: _addStreamModalKey,
          onSubmit: (String resource) {
            setState(() {
              _addNewStream(resource);
            });
          },
        ),
        TspDrawer(
          key: _drawerKey,
          buttons: [
            TspDrawerButton(
              icon: Icons.video_camera_back,
              text: 'Add Stream',
              onPressed: () {
                _addStreamModalKey.currentState!.openModal();
                _drawerKey.currentState!.closeDrawer();
              },
            ),
            TspDrawerButton(
              icon: Icons.copy_outlined,
              text: 'Always on Top',
              iconColor: ThemeColors.warning,
              selected: _isAlwaysOnTop,
              onPressed: () {
                windowManager.setAlwaysOnTop(!_isAlwaysOnTop).then((value) {
                  setState(() {
                    _isAlwaysOnTop = !_isAlwaysOnTop;
                    Preferences().windowAlwaysOnTop.save(_isAlwaysOnTop);
                  });
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: WindowScene.withDrawerButton(
        onDrawerPressed: () {
          if (_drawerKey.currentState!.drawerOpened) {
            _drawerKey.currentState!.closeDrawer();
          } else {
            _drawerKey.currentState!.openDrawer();
          }
        },
        child: Container(
          color: ThemeColors.gray[1000],
          child: _buildBody(),
        ),
      ),
    );
  }
}
