import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiny_stream_player/core/colors.dart';
import 'package:tiny_stream_player/widgets/window/drawer_window_button.dart';
import 'package:tiny_stream_player/widgets/window/window_title_bar.dart';
import 'package:window_manager/window_manager.dart';

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
  final borderColor = ThemeColors.gray[900]!;

  Widget _buildBorder(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 0,
        ),
        color: borderColor,
      ),
      child: Padding(
        /// Somehow top border is not drawn so little workaround with padding and container's background color\
        /// Tried with just all padding but that didn't work either
        padding: const EdgeInsets.only(top: 0),
        child: child,
      ),
    );
  }

  Widget _buildBody() {
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

  @override
  Widget build(BuildContext context) {
    return _buildBorder(_buildBody());
  }
}
