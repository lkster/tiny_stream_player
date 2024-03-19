import 'dart:ui';

import 'package:flutter/widgets.dart';


abstract final class ThemeColors {
  static const gray = ColorSwatch(0xff505e77, {
    100: Color(0xffdae2f2),
    200: Color(0xffb8c6e5),
    300: Color(0xff99aacc),
    400: Color(0xff7d8eb2),
    500: Color(0xff505e77),
    600: Color(0xff3e485c),
    700: Color(0xff313948),
    800: Color(0xff2d3442),
    900: Color(0xff282e3a),
    1000: Color(0xff1d222b),
  });

  static const primary = Color(0xff4891fe);
  static const secondary = Color(0xff7d8eb2);
  static const success = Color(0xff439d07);
  static const info = Color(0xff1bc0ee);
  static const warning = Color(0xfff48f01);
  static const danger = Color(0xffec5e4d);
}


