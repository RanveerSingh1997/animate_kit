import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animates [child] into view with a fade + scale entrance.
///
/// Scales from [initialScale] to `1.0` while simultaneously fading in.
/// Respects [MediaQuery.disableAnimations].
///
/// ```dart
/// ScaleEntrance(
///   delay: const Duration(milliseconds: 100),
///   child: MyCard(),
/// )
/// ```
class ScaleEntrance extends StatelessWidget {
  const ScaleEntrance({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.initialScale = 0.85,
    super.key,
  }) : assert(initialScale >= 0.0 && initialScale <= 1.0);

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Scale factor at the start of the entrance. Defaults to `0.85`.
  final double initialScale;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .scale(
          begin: Offset(initialScale, initialScale),
          end: const Offset(1, 1),
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }
}
