import 'dart:ui';

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

final class TspDrawerState extends State<TspDrawer>
    with SingleTickerProviderStateMixin {
  bool _drawerOpened = false;

  bool get drawerOpened => _drawerOpened;

  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final _easeAnimation =
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    _animationController.addListener(() {
      setState(() {});
    });
  }

  void openDrawer() {
    setState(() {
      _drawerOpened = true;
      _animationController.forward();
    });
  }

  void closeDrawer() {
    setState(() {
      _drawerOpened = false;
      _animationController.reverse();
    });
  }

  Widget _buildOverlay(Widget child) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: Tween<double>(begin: 0, end: 5).animate(_easeAnimation).value,
          sigmaY: Tween<double>(begin: 0, end: 5).animate(_easeAnimation).value,
        ),
        child: Container(
          color: Colors.black.withOpacity(
            Tween<double>(begin: 0, end: 0.75).animate(_easeAnimation).value,
          ),
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

  Widget _buildDrawer() {
    return FractionalTranslation(
      translation:
          Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(_easeAnimation)
              .value,
      child: Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return _animationController.value > 0
        ? _buildOverlay(
            _buildDrawer(),
          )
        : Container();
  }
}
