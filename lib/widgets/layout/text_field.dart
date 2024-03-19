import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/colors.dart';

final class TspTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;

  const TspTextField({
    super.key,
    this.controller,
    this.hintText,
  });

  @override
  State<StatefulWidget> createState() => _TspTextFieldState();
}

final class _TspTextFieldState extends State<TspTextField> {
  final _focusNode = FocusNode();
  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: BorderSide(
      width: 1,
      color: Color.lerp(ThemeColors.gray[900], Colors.black, 0.1)!,
      style: BorderStyle.solid,
    ),
  );

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      maxLines: 1,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        hintText: widget.hintText,
        isDense: true,
        hintStyle: TextStyle(
          color: ThemeColors.gray[400],
          fontWeight: FontWeight.w400,
        ),
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
        filled: true,
        fillColor: _focusNode.hasFocus
            ? Color.lerp(ThemeColors.gray[900], Colors.white, 0.02)
            : ThemeColors.gray[900],
        hoverColor: ThemeColors.gray[900],
      ),
      style: TextStyle(
        color: _focusNode.hasFocus ? Colors.white : ThemeColors.gray[200],
        fontSize: 16,
      ),
      cursorColor: Colors.white,
    );
  }
}
