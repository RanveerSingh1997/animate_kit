import 'dart:math' as math;

import 'package:flutter/material.dart';

/// State-driven 3D card flip — shows [front] or [back] based on [showFront],
/// rotating through a perspective flip when the value changes.
///
/// Both faces are sized to the larger of the two. The back face is
/// pre-mirrored so its content reads correctly once the flip completes.
///
/// Respects [MediaQuery.disableAnimations] — swaps faces instantly when
/// reduce-motion is enabled.
///
/// ```dart
/// FlipCard(
///   showFront: !isRevealed,
///   front: CardBack(),
///   back: CardFace(),
/// )
/// ```
class FlipCard extends StatelessWidget {
  const FlipCard({
    required this.front,
    required this.back,
    required this.showFront,
    this.duration = const Duration(milliseconds: 400),
    this.axis = Axis.horizontal,
    super.key,
  });

  /// Face shown when [showFront] is `true`.
  final Widget front;

  /// Face shown when [showFront] is `false`.
  final Widget back;

  /// Which face is visible. Toggling animates a 3D flip.
  final bool showFront;

  final Duration duration;

  /// [Axis.horizontal] flips around the vertical axis (left-right turn);
  /// [Axis.vertical] flips around the horizontal axis (top-bottom turn).
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      return showFront ? front : back;
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(end: showFront ? 0.0 : 1.0),
      duration: duration,
      curve: Curves.easeInOutCubic,
      child: front,
      builder: (context, t, frontChild) {
        final angle = t * math.pi;
        final isFrontVisible = angle <= math.pi / 2;
        final transform = Matrix4.identity()..setEntry(3, 2, 0.001);
        if (axis == Axis.horizontal) {
          transform.rotateY(angle);
        } else {
          transform.rotateX(angle);
        }
        // Mirror the back face so it reads correctly after the half turn.
        final backTransform = Matrix4.identity();
        if (axis == Axis.horizontal) {
          backTransform.rotateY(math.pi);
        } else {
          backTransform.rotateX(math.pi);
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: isFrontVisible
              ? frontChild
              : Transform(
                  transform: backTransform,
                  alignment: Alignment.center,
                  child: back,
                ),
        );
      },
    );
  }
}
