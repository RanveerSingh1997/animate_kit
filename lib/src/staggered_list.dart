import 'package:flutter/material.dart';

import 'fade_entrance.dart';

/// Renders [children] in a [Column] with each item wrapped in [FadeEntrance],
/// offset by [itemDelay] * index so they cascade in one after another.
///
/// Respects [MediaQuery.disableAnimations] — all children appear immediately
/// when reduce-motion is on (FadeEntrance snaps).
///
/// ```dart
/// StaggeredList(
///   itemDelay: const Duration(milliseconds: 60),
///   children: items.map((e) => ItemTile(e)).toList(),
/// )
/// ```
class StaggeredList extends StatelessWidget {
  const StaggeredList({
    required this.children,
    this.itemDelay = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 400),
    this.direction = FadeSlideDirection.up,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    super.key,
  });

  final List<Widget> children;

  /// Delay added per item. Item at index i gets delay `itemDelay * i`.
  final Duration itemDelay;

  /// Duration of each item's FadeEntrance. Defaults to 400ms.
  final Duration duration;

  /// Slide direction passed to each [FadeEntrance]. Defaults to [FadeSlideDirection.up].
  final FadeSlideDirection direction;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (int i = 0; i < children.length; i++)
          FadeEntrance(
            delay: itemDelay * i,
            duration: duration,
            direction: direction,
            child: children[i],
          ),
      ],
    );
  }
}
