import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rtsp_player/widgets/window/drawer_window_button.dart';

final class WindowTitleBar extends StatefulWidget {
  final List<WindowButton> buttons;

  const WindowTitleBar({super.key, this.buttons = const []});

  @override
  State<StatefulWidget> createState() => _WindowTitleBarState();
}

final class _WindowTitleBarState extends State<WindowTitleBar> {
  Widget _buildMaximizeOrRestoreButton() {
    if (appWindow.isMaximized) {
      return RestoreWindowButton(
        onPressed: () {
          appWindow.maximizeOrRestore();
          setState(() {});
        },
      );
    }

    return MaximizeWindowButton(
      onPressed: () {
        appWindow.maximizeOrRestore();
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [
          Row(
            children: widget.buttons,
          ),
          Expanded(
            child: MoveWindow(),
          ),
          Row(
            children: [
              MinimizeWindowButton(),
              _buildMaximizeOrRestoreButton(),
              CloseWindowButton(),
            ],
          )
        ],
      ),
    );
  }
}

