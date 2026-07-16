import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Repeating vertical bounce for drawing attention (e.g. "scroll for more"
/// hints, call-to-action icons).
///
/// Loops indefinitely, translating [child] up by [height] logical pixels and
/// back. Returns [child] unchanged when [MediaQuery.disableAnimations] is
/// true.
///
/// ```dart
/// BounceAnimation(
///   child: Icon(Icons.keyboard_arrow_down),
/// )
/// ```
class BounceAnimation extends StatelessWidget {
  const BounceAnimation({
    required this.child,
    this.height = 8.0,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
    super.key,
  }) : assert(height > 0.0);

  final Widget child;

  /// Peak vertical displacement in logical pixels. Defaults to `8`.
  final double height;

  /// Duration of one bounce cycle (up → down → up).
  final Duration duration;

  /// Easing of the bounce.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    // RepaintBoundary isolates the endlessly repainting bounce from the
    // surrounding subtree.
    return RepaintBoundary(
      child: child
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: 0, end: -height, duration: duration, curve: curve),
    );
  }
}
