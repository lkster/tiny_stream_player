import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rtsp_player/widgets/window/drawer_window_button.dart';
import 'package:rtsp_player/widgets/window/window_colors.dart';

final class WindowTitleBar extends StatefulWidget {
  final List<WindowButton> buttons;

  const WindowTitleBar({super.key, this.buttons = const []});

  @override
  State<StatefulWidget> createState() => _WindowTitleBarState();
}

final class _WindowTitleBarState extends State<WindowTitleBar>
    with WidgetsBindingObserver {
  WindowButtonColors _buttonColors = windowButtonColors;
  WindowButtonColors _closeButtonColors = windowCloseButtonColors;
  Color _titleColor = titleColor;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.resumed) {
        _buttonColors = windowButtonColors;
        _closeButtonColors = windowCloseButtonColors;
        _titleColor = titleColor;
      } else {
        _buttonColors = windowButtonBlurColors;
        _closeButtonColors = windowCloseButtonBlurColors;
        _titleColor = titleBlurColor;
      }
    });

    super.didChangeAppLifecycleState(state);
  }

  Widget _buildMaximizeOrRestoreButton() {
    if (appWindow.isMaximized) {
      return RestoreWindowButton(
        colors: _buttonColors,
        onPressed: () {
          appWindow.maximizeOrRestore();
          setState(() {});
        },
      );
    }

    return MaximizeWindowButton(
      colors: _buttonColors,
      onPressed: () {
        appWindow.maximizeOrRestore();
        setState(() {});
      },
    );
  }

  Widget _buildAppTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Tiny Stream Player',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _titleColor,
          ),
        ),
      ),
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
            child: MoveWindow(
              child: _buildAppTitle(),
            ),
          ),
          Row(
            children: [
              MinimizeWindowButton(
                colors: _buttonColors,
              ),
              _buildMaximizeOrRestoreButton(),
              CloseWindowButton(
                colors: _closeButtonColors,
              ),
            ],
          )
        ],
      ),
    );
  }
}
