import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tiny_stream_player/core/colors.dart';

final class TspModal extends StatefulWidget {
  final String? title;
  final Widget body;
  final Widget? footer;

  const TspModal({
    super.key,
    required this.body,
    this.title,
    this.footer,
  });

  @override
  State<StatefulWidget> createState() => TspModalState();
}

final class TspModalState extends State<TspModal> {
  bool _modalShown = false;

  void openModal() {
    setState(() {
      _modalShown = true;
    });
  }

  void closeModal() {
    setState(() {
      _modalShown = false;
    });
  }

  Widget _buildOverlay(Widget child) {
    return Stack(
      children: [
        ClipRect(
          child: GestureDetector(
            onTap: closeModal,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black.withOpacity(.75),
              ),
            ),
          ),
        ),
        Center(
          child: child,
        ),
      ],
    );
  }

  Widget _buildModal(Widget child) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: ThemeColors.gray700,
        border: Border.all(
          width: 1,
          color: ThemeColors.gray600,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModalHeader(),
          Padding(
            padding: EdgeInsets.all(10),
            child: child,
          ),
          _buildModalFooter(),
        ],
      ),
    );
  }

  Widget _buildModalHeader() {
    return widget.title != null
        ? Container(
            decoration: const BoxDecoration(
              color: ThemeColors.gray800,
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: ThemeColors.gray900,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      color: ThemeColors.gray100,
                      fontWeight: FontWeight.w500,
                      // fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: closeModal,
                    padding: EdgeInsets.zero,
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(20, 20)),
                      iconColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white;
                        }

                        if (states.contains(MaterialState.hovered)) {
                          return Colors.white.withOpacity(.75);
                        }

                        return Colors.white.withOpacity(.5);
                      }),
                    ),
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ))
        : Container();
  }

  Widget _buildModalFooter() {
    return widget.footer != null
        ? Container(
            decoration: const BoxDecoration(
              color: ThemeColors.gray800,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: ThemeColors.gray900,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: widget.footer,
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    if (!_modalShown) {
      return Container();
    }

    return _buildOverlay(
      _buildModal(widget.body),
    );
  }
}
