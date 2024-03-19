import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/colors.dart';

final windowButtonColors = WindowButtonColors(
  normal: Colors.transparent,
  iconNormal: ThemeColors.gray100,
  mouseOver: ThemeColors.gray600,
  mouseDown: ThemeColors.gray900,
  iconMouseOver: ThemeColors.gray100,
  iconMouseDown: ThemeColors.gray200,
);

final windowButtonBlurColors = WindowButtonColors(
  normal: Colors.transparent,
  iconNormal: ThemeColors.gray100.withOpacity(.5),
  mouseOver: ThemeColors.gray600,
  mouseDown: ThemeColors.gray900,
  iconMouseOver: ThemeColors.gray100,
  iconMouseDown: ThemeColors.gray200,
);

final windowCloseButtonColors = WindowButtonColors(
  iconNormal: ThemeColors.gray100,
  mouseOver: ThemeColors.danger,
  mouseDown: Color.lerp(ThemeColors.danger, Colors.black, 0.2),
  iconMouseOver: ThemeColors.gray100,
);

final windowCloseButtonBlurColors = WindowButtonColors(
  iconNormal: ThemeColors.gray100.withOpacity(.5),
  mouseOver: ThemeColors.danger,
  mouseDown: Color.lerp(ThemeColors.danger, Colors.black, 0.2),
  iconMouseOver: ThemeColors.gray100,
);

final titleColor = ThemeColors.gray100;
final titleBlurColor = ThemeColors.gray100.withOpacity(.5);
