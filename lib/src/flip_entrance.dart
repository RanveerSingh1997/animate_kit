import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Axis of the 3D flip in [FlipEntrance].
enum FlipAxis {
  /// Flips around the horizontal axis (content tilts top-to-bottom).
  horizontal,

  /// Flips around the vertical axis (content tilts left-to-right).
  vertical,
}

/// Animates [child] into view with a fade + 3D flip entrance.
///
/// Flips from [initialTilt] (a fraction of a half turn) to flat while
/// simultaneously fading in. Respects [MediaQuery.disableAnimations].
///
/// ```dart
/// FlipEntrance(
///   axis: FlipAxis.horizontal,
///   child: MyCard(),
/// )
/// ```
class FlipEntrance extends StatelessWidget {
  const FlipEntrance({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.axis = FlipAxis.horizontal,
    this.initialTilt = -0.5,
    this.curve = Curves.easeOutCubic,
    super.key,
  }) : assert(initialTilt >= -1.0 && initialTilt <= 1.0);

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Axis the child flips around. Defaults to [FlipAxis.horizontal].
  final FlipAxis axis;

  /// Tilt at the start of the entrance, as a fraction of a half turn
  /// (`-0.5` = edge-on, 90° away). Defaults to `-0.5`.
  final double initialTilt;

  /// Easing of the flip (the fade always uses [Curves.easeOut]).
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final animated = child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut);
    return switch (axis) {
      FlipAxis.horizontal => animated.flipH(
        begin: initialTilt,
        end: 0,
        duration: duration,
        curve: curve,
      ),
      FlipAxis.vertical => animated.flipV(
        begin: initialTilt,
        end: 0,
        duration: duration,
        curve: curve,
      ),
    };
  }
}
