import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Repeating continuous rotation for loading spinners and sync indicators.
///
/// Loops indefinitely at one full turn per [duration]. Set [clockwise] to
/// `false` to reverse direction. Returns [child] unchanged when
/// [MediaQuery.disableAnimations] is true.
///
/// ```dart
/// SpinAnimation(
///   child: Icon(Icons.sync),
/// )
/// ```
class SpinAnimation extends StatelessWidget {
  const SpinAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.clockwise = true,
    super.key,
  });

  final Widget child;

  /// Duration of one full rotation. Defaults to 1200ms.
  final Duration duration;

  /// Rotation direction. Defaults to clockwise.
  final bool clockwise;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    // RepaintBoundary isolates the endlessly repainting spin from the
    // surrounding subtree.
    return RepaintBoundary(
      child: child
          .animate(onPlay: (c) => c.repeat())
          .rotate(
            begin: 0,
            end: clockwise ? 1 : -1,
            duration: duration,
            curve: Curves.linear,
          ),
    );
  }
}
