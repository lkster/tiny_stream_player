import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ListExt<T> on List<T> {
  List<List<T>> chunk(int chunkSize) {
    return [
      for (var i = 0; i < length; i += chunkSize)
        sublist(i, min(length, i + chunkSize))
    ];
  }

  List<T> addBetweenElements(T element) {
    return [
      for (var e in map((e) => [e, element])) ...e
    ]..removeLast();
  }
}

final class MultiStreamViewer extends StatelessWidget {
  final List<Widget> children;

  const MultiStreamViewer({super.key, required this.children});

  Widget _buildGrid(double width, double height) {
    final chunkSize = sqrt(children.length).ceil();
    final List<List<Widget>> chunks = children.chunk(chunkSize);

    List<Widget> grid = chunks
        .map<Widget>((x) => Row(
              children: x
                  .map<Widget>((y) => SizedBox(
                        width: (width + 2 - x.length * 2) / x.length,
                        height:
                            (height + 2 - chunks.length * 2) / chunks.length,
                        child: y,
                      ))
                  .toList()
                  .addBetweenElements(Container(width: 2)),
            ))
        .toList()
        .addBetweenElements(Container(height: 2));

    return Column(
      children: grid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.constrainWidth();
      final height = constraints.constrainHeight();

      return Container(
        color: const Color(0xff111111),
        child: _buildGrid(width, height),
      );
    });
  }
}
