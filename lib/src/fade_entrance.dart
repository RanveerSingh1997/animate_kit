import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animates [child] into view with a fade + upward slide entrance.
///
/// Respects [MediaQuery.disableAnimations] — returns [child] unchanged when
/// the system has reduce-motion enabled.
///
/// ```dart
/// FadeEntrance(
///   delay: 100.ms,
///   child: MyCard(),
/// )
/// ```
class FadeEntrance extends StatelessWidget {
  const FadeEntrance({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideY(
          begin: 0.06,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }
}
