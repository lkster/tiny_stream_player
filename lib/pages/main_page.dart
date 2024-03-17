import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rtsp_player/widgets/add_stream_modal.dart';
import 'package:rtsp_player/widgets/player/player.dart';
import 'package:rtsp_player/widgets/stream/multi_stream_viewer.dart';
import 'package:rtsp_player/widgets/stream/stream_player.dart';
import 'package:rtsp_player/widgets/stream/stream_player_controller.dart';

import 'package:rtsp_player/widgets/window/window_scene.dart';

final class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

final class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _addStreamModalShown = false;
  List<StreamPlayerController> streams = [];

  @override
  void dispose() async {
    super.dispose();

    for (var element in streams) {
      await element.dispose();
    }
  }

  void _addNewStream(String resource) {
    streams.add(StreamPlayerController()..open(resource));
  }

  void _removeStream(int index) {
    if (index.clamp(0, streams.length - 1) != index) {
      return;
    }

    setState(() {
      final controller = streams[index];

      controller.dispose();
      streams.removeAt(index);
    });
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
          TextButton(
            onPressed: () {
              setState(() {
                _addStreamModalShown = true;
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text('Add Stream'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    late final Widget streamsView;

    if (streams.isNotEmpty) {
      final streamPlayers = streams.asMap().entries.map(
            (entry) => StreamPlayer(
              controller: entry.value,
              onClose: () {
                _removeStream(entry.key);
              },
            ),
          ).toList();

      streamsView = MultiStreamViewer(
        children: streamPlayers,
      );
    } else {
      streamsView = _buildNoStreamsView();
    }

    return Stack(
      children: [
        streamsView,
        if (_addStreamModalShown)
          AddStreamModal(
            onSubmit: (String resource) {
              setState(() {
                _addNewStream(resource);
                _addStreamModalShown = false;
              });
            },
            onCancel: () {
              setState(() {
                _addStreamModalShown = false;
              });
            },
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
          _scaffoldKey.currentState!.openDrawer();
        },
        child: Container(
          color: Colors.black,
          child: _buildBody(),
        ),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Add stream'),
              onTap: () {
                setState(() {
                  _addStreamModalShown = true;
                  _scaffoldKey.currentState!.closeDrawer();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
