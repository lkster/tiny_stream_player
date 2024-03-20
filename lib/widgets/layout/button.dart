import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/colors.dart';

final class TspButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonColorSet colorSet;

  const TspButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.colorSet,
  });

  TspButton.primary({
    super.key,
    required this.onPressed,
    required this.child,
  }) : colorSet = primaryButtonColorSet;

  TspButton.secondary({
    super.key,
    required this.onPressed,
    required this.child,
  }) : colorSet = secondaryButtonColorSet;

  @override
  State<StatefulWidget> createState() => _TspButtonState();
}

final class _TspButtonState extends State<TspButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.05)),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return widget.colorSet.backgroundPressed;
          }

          if (states.contains(MaterialState.hovered)) {
            return widget.colorSet.backgroundHover;
          }

          return widget.colorSet.backgroundNormal;
        }),
        foregroundColor: MaterialStateProperty.all(widget.colorSet.text),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        textStyle: MaterialStateProperty.all(const TextStyle(
          fontWeight: FontWeight.w400,
        )),
      ),
      child: widget.child,
    );
  }
}

class ButtonColorSet {
  final Color backgroundNormal;
  final Color backgroundHover;
  final Color backgroundPressed;
  final Color text;

  ButtonColorSet({
    required this.backgroundNormal,
    required this.backgroundHover,
    required this.backgroundPressed,
    required this.text,
  });
}

final primaryButtonColorSet = ButtonColorSet(
  backgroundNormal: ThemeColors.primary,
  backgroundHover: Color.lerp(ThemeColors.primary, Colors.white, 0.1)!,
  backgroundPressed: Color.lerp(ThemeColors.primary, Colors.black, 0.1)!,
  text: Colors.white,
);

final secondaryButtonColorSet = ButtonColorSet(
  backgroundNormal: ThemeColors.secondary,
  backgroundHover: Color.lerp(ThemeColors.secondary, Colors.white, 0.1)!,
  backgroundPressed: Color.lerp(ThemeColors.secondary, Colors.black, 0.1)!,
  text: Colors.white,
);
