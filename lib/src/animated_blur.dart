import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// State-driven blur — animates a Gaussian blur over [child] between `0`
/// and [sigma] based on [blurred].
///
/// Useful for spoiler covers, disabled backgrounds, and focus effects.
/// [child] stays interactive unless you block input yourself.
///
/// Respects [MediaQuery.disableAnimations] — snaps immediately when reduce-
/// motion is enabled.
///
/// ```dart
/// AnimatedBlur(
///   blurred: !isRevealed,
///   child: SpoilerImage(),
/// )
/// ```
class AnimatedBlur extends StatelessWidget {
  const AnimatedBlur({
    required this.child,
    required this.blurred,
    this.sigma = 8.0,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOut,
    super.key,
  }) : assert(sigma > 0.0);

  final Widget child;

  /// When `true`, [child] is blurred at [sigma]. When `false`, fully crisp.
  final bool blurred;

  /// Gaussian blur sigma when [blurred] is `true`. Defaults to `8`.
  final double sigma;

  final Duration duration;

  /// Easing of the blur transition.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration;
    return TweenAnimationBuilder<double>(
      tween: Tween(end: blurred ? sigma : 0.0),
      duration: resolvedDuration,
      curve: curve,
      child: child,
      builder: (context, value, staticChild) {
        // ImageFilter.blur with sigma 0 still costs a saveLayer — skip the
        // filter entirely when crisp.
        if (value == 0.0) return staticChild!;
        return ImageFiltered(
          imageFilter: ui.ImageFilter.blur(
            sigmaX: value,
            sigmaY: value,
            tileMode: ui.TileMode.decal,
          ),
          child: staticChild,
        );
      },
    );
  }
}
