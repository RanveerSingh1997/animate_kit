import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animates [child] into view with a fade + rotate entrance.
///
/// Rotates from [initialTurns] (a fraction of a full turn) to `0.0` while
/// simultaneously fading in. Respects [MediaQuery.disableAnimations].
///
/// ```dart
/// RotateEntrance(
///   delay: const Duration(milliseconds: 100),
///   child: MyIcon(),
/// )
/// ```
class RotateEntrance extends StatelessWidget {
  const RotateEntrance({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.initialTurns = -0.25,
    this.curve = Curves.easeOutCubic,
    super.key,
  }) : assert(initialTurns >= -1.0 && initialTurns <= 1.0);

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Rotation at the start of the entrance, in turns (`1.0` = 360°).
  /// Defaults to `-0.25` (a quarter turn counter-clockwise).
  final double initialTurns;

  /// Easing of the rotation (the fade always uses [Curves.easeOut]).
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .rotate(begin: initialTurns, end: 0, duration: duration, curve: curve);
  }
}
