import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:tiny_stream_player/widgets/window/window_colors.dart';

final class DrawerWindowButton extends WindowButton {
  DrawerWindowButton(
      {Key? key,
      WindowButtonColors? colors,
      VoidCallback? onPressed,
      bool? animate})
      : super(
            key: key,
            colors: colors ?? windowButtonColors,
            animate: animate ?? false,
            iconBuilder: (buttonContext) =>
                _DrawerWindowButtonIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () {});
}

final class _DrawerWindowButtonIcon extends StatelessWidget {
  final Color color;

  const _DrawerWindowButtonIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomPaint(
        size: const Size(10, 10),
        painter: _DrawerWindowButtonIconPainter(color),
      ),
    );
  }
}

final class _DrawerWindowButtonIconPainter extends CustomPainter {
  final Color color;

  _DrawerWindowButtonIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    final centerPoint = size.height / 2;
    const spacing = 4;

    canvas.drawLine(
      Offset(0, centerPoint - spacing),
      Offset(size.width, centerPoint - spacing),
      p,
    );

    canvas.drawLine(
      Offset(0, centerPoint),
      Offset(size.width, centerPoint),
      p,
    );

    canvas.drawLine(
      Offset(0, centerPoint + spacing),
      Offset(size.width, centerPoint + spacing),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
