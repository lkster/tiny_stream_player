import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/colors.dart';

final class TspDrawerButton extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final bool selected;
  final VoidCallback? onPressed;

  const TspDrawerButton({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = ThemeColors.primary,
    this.selected = false,
    this.onPressed,
  });

  @override
  State<StatefulWidget> createState() => _TspDrawerButtonState();
}

final class _TspDrawerButtonState extends State<TspDrawerButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(0, 0),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          overlayColor:
              MaterialStateProperty.all(Colors.white.withOpacity(.01)),
          fixedSize: MaterialStateProperty.all(const Size(120, 120)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              side: BorderSide(
                color: Color.lerp(ThemeColors.gray[700], Colors.white, 0.05)!,
                width: 1,
              ),
            ),
          ),
          iconColor: MaterialStateProperty.all(Colors.white),
          iconSize: MaterialStateProperty.all(36),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed) || widget.selected) {
              return ThemeColors.gray[900];
            }

            if (states.contains(MaterialState.hovered)) {
              return Color.lerp(ThemeColors.gray[700], Colors.white, 0.05)!;
            }

            return ThemeColors.gray[700];
          }),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 60,
              child: Icon(
                widget.icon,
                color: widget.iconColor,
              ),
            ),
            Text(
              widget.text.toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
