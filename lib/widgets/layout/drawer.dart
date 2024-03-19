import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/colors.dart';
import 'package:tiny_stream_player/widgets/layout/drawer_button.dart';

final class TspDrawer extends StatefulWidget {
  final List<TspDrawerButton> buttons;

  const TspDrawer({
    super.key,
    required this.buttons,
  });

  @override
  State<StatefulWidget> createState() => TspDrawerState();
}

final class TspDrawerState extends State<TspDrawer> {
  bool _drawerOpened = false;

  bool get drawerOpened => _drawerOpened;

  void openDrawer() {
    setState(() {
      _drawerOpened = true;
    });
  }

  void closeDrawer() {
    setState(() {
      _drawerOpened = false;
    });
  }

  Widget _buildOverlay(Widget child) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Container(
          color: Colors.black.withOpacity(.75),
          child: Column(
            children: [
              child,
              Expanded(
                child: GestureDetector(
                  onTap: closeDrawer,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _drawerOpened
        ? _buildOverlay(
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.gray[800],
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(.12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.buttons
                      .map((e) => [e, const SizedBox(width: 10)])
                      .expand<Widget>((e) => e)
                      .toList()
                    ..removeLast(),
                ),
              ),
            ),
          )
        : Container();
  }
}
