import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiny_stream_player/widgets/window/drawer_window_button.dart';
import 'package:tiny_stream_player/widgets/window/window_title_bar.dart';

final class WindowScene extends StatefulWidget {
  final Widget child;
  final List<WindowButton> buttons;

  const WindowScene({
    super.key,
    required this.child,
    this.buttons = const [],
  });

  factory WindowScene.withDrawerButton({
    Key? key,
    required Widget child,
    VoidCallback? onDrawerPressed,
  }) {
    return WindowScene(
      key: key,
      buttons: [
        DrawerWindowButton(
          onPressed: onDrawerPressed,
        ),
      ],
      child: child,
    );
  }

  @override
  State<StatefulWidget> createState() => _WindowSceneState();
}

final class _WindowSceneState extends State<WindowScene> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WindowTitleBar(
          buttons: widget.buttons,
        ),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }
}
