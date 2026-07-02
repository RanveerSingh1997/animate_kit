import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Direction of the slide component in [FadeEntrance].
enum FadeSlideDirection {
  /// Slides up from slightly below the final position (default).
  up,

  /// Slides down from slightly above the final position.
  down,

  /// Slides left from slightly to the right of the final position.
  left,

  /// Slides right from slightly to the left of the final position.
  right,

  /// No slide — fade only.
  none,
}

/// Animates [child] into view with a fade + optional slide entrance.
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
    this.direction = FadeSlideDirection.up,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Direction of the slide component. Defaults to [FadeSlideDirection.up].
  /// Use [FadeSlideDirection.none] for a fade-only entrance.
  final FadeSlideDirection direction;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final animated = child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut);
    return switch (direction) {
      FadeSlideDirection.up => animated.slideY(
        begin: 0.06,
        end: 0,
        duration: duration,
        curve: Curves.easeOutCubic,
      ),
      FadeSlideDirection.down => animated.slideY(
        begin: -0.06,
        end: 0,
        duration: duration,
        curve: Curves.easeOutCubic,
      ),
      FadeSlideDirection.left => animated.slideX(
        begin: 0.06,
        end: 0,
        duration: duration,
        curve: Curves.easeOutCubic,
      ),
      FadeSlideDirection.right => animated.slideX(
        begin: -0.06,
        end: 0,
        duration: duration,
        curve: Curves.easeOutCubic,
      ),
      FadeSlideDirection.none => animated,
    };
  }
}
