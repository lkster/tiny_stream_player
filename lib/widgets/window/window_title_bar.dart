import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/colors.dart';
import 'package:tiny_stream_player/widgets/window/window_colors.dart';
import 'package:window_manager/window_manager.dart';

final class WindowTitleBar extends StatefulWidget {
  final List<WindowButton> buttons;

  const WindowTitleBar({super.key, this.buttons = const []});

  @override
  State<StatefulWidget> createState() => _WindowTitleBarState();
}

final class _WindowTitleBarState extends State<WindowTitleBar>
    with WindowListener {
  WindowButtonColors _buttonColors = windowButtonColors;
  WindowButtonColors _closeButtonColors = windowCloseButtonColors;
  Color _titleColor = titleColor;

  @override
  void initState() {
    super.initState();

    windowManager.addListener(this);
  }

  @override
  void dispose() {
    super.dispose();

    windowManager.removeListener(this);
  }

  @override
  void onWindowFocus() {
    super.onWindowFocus();

    setState(() {
      _buttonColors = windowButtonColors;
      _closeButtonColors = windowCloseButtonColors;
      _titleColor = titleColor;
    });
  }

  @override
  void onWindowBlur() {
    super.onWindowBlur();

    setState(() {
      _buttonColors = windowButtonBlurColors;
      _closeButtonColors = windowCloseButtonBlurColors;
      _titleColor = titleBlurColor;
    });
  }

  @override
  void onWindowMaximize() {
    super.onWindowMaximize();

    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    super.onWindowUnmaximize();

    setState(() {});
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
      padding: const EdgeInsets.only(left: 8),
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
    return Container(
      height: appWindow.titleBarHeight + 1,
      decoration: BoxDecoration(
        color: ThemeColors.gray[700],
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: ThemeColors.gray[900]!,
          ),
        ),
      ),
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
          ),
        ],
      ),
    );
  }
}
