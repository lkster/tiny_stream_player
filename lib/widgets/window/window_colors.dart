import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

final windowButtonColors = WindowButtonColors(
  normal: Colors.transparent,
  iconNormal: const Color(0xFF805306),
  mouseOver: const Color(0xFF404040),
  mouseDown: const Color(0xFF202020),
  iconMouseOver: const Color(0xFFFFFFFF),
  iconMouseDown: const Color(0xFFF0F0F0),
);

final windowButtonBlurColors = WindowButtonColors(
  normal: Colors.transparent,
  iconNormal: const Color(0xff805306).withOpacity(.5),
  mouseOver: const Color(0xFF404040),
  mouseDown: const Color(0xFF202020),
  iconMouseOver: const Color(0xFFFFFFFF),
  iconMouseDown: const Color(0xFFF0F0F0),
);

final windowCloseButtonColors = WindowButtonColors(
  iconNormal: const Color(0xFF805306),
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconMouseOver: const Color(0xFFFFFFFF),
);

final windowCloseButtonBlurColors = WindowButtonColors(
  iconNormal: const Color(0xFF805306).withOpacity(.5),
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconMouseOver: const Color(0xFFFFFFFF),
);

final titleColor = Colors.black;
final titleBlurColor = Colors.black.withOpacity(.5);
