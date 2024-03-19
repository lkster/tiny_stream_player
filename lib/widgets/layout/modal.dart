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

final class TspModalState extends State<TspModal>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final _easeAnimation =
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    _animationController.addListener(() {
      setState(() {});
    });
  }

  void openModal() {
    setState(() {
      _animationController.forward();
    });
  }

  void closeModal() {
    setState(() {
      _animationController.reverse();
    });
  }

  Widget _buildOverlay(Widget child) {
    return Stack(
      key: const ValueKey(1),
      children: [
        ClipRect(
          child: GestureDetector(
            onTap: closeModal,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: Tween<double>(begin: 0, end: 5)
                    .animate(_easeAnimation)
                    .value,
                sigmaY: Tween<double>(begin: 0, end: 5)
                    .animate(_easeAnimation)
                    .value,
              ),
              child: Container(
                color: Colors.black.withOpacity(
                  Tween<double>(begin: 0, end: 0.75)
                      .animate(_easeAnimation)
                      .value,
                ),
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
    return Opacity(
      opacity: _animationController.value,
      child: ClipRect(
        child: Stack(
          children: [
            Transform.scale(
              scale:
              Tween<double>(begin: .9, end: 1).animate(_easeAnimation).value,
              child: Center(
                child: Container(
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: ThemeColors.gray[700],
                    border: Border.all(
                      width: 1,
                      color: ThemeColors.gray[600]!,
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
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: Tween<double>(begin: 5, end: 0)
                    .animate(_easeAnimation)
                    .value,
                sigmaY: Tween<double>(begin: 5, end: 0)
                    .animate(_easeAnimation)
                    .value,
              ),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalHeader() {
    return widget.title != null
        ? Container(
            decoration: BoxDecoration(
              color: ThemeColors.gray[800],
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: ThemeColors.gray[900]!,
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
                    style: TextStyle(
                      color: ThemeColors.gray[100],
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
            decoration: BoxDecoration(
              color: ThemeColors.gray[800],
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: ThemeColors.gray[900]!,
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
    return _animationController.value > 0
        ? _buildOverlay(
            _buildModal(widget.body),
          )
        : Container();
  }
}
