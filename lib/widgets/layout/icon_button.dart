import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/colors.dart';

final class TspIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const TspIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  State<StatefulWidget> createState() => _TspIconButtonState();
}

final class _TspIconButtonState extends State<TspIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.icon,
      onPressed: widget.onPressed,
      iconSize: 28,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        iconColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return ThemeColors.gray[100];
          }

          if (states.contains(MaterialState.hovered)) {
            return Colors.white;
          }

          return Color(0xffd9d9d9);
        }),
      ),
    );
  }
}
