import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animates [child] into view with a fade + blur entrance.
///
/// Starts blurred at [initialSigma] and sharpens to fully crisp while
/// simultaneously fading in. Respects [MediaQuery.disableAnimations].
///
/// ```dart
/// BlurEntrance(
///   delay: const Duration(milliseconds: 100),
///   child: MyHeroImage(),
/// )
/// ```
class BlurEntrance extends StatelessWidget {
  const BlurEntrance({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.initialSigma = 8.0,
    this.curve = Curves.easeOut,
    super.key,
  }) : assert(initialSigma > 0.0);

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Gaussian blur sigma at the start of the entrance. Defaults to `8`.
  final double initialSigma;

  /// Easing of the blur (the fade always uses [Curves.easeOut]).
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .blurXY(begin: initialSigma, end: 0, duration: duration, curve: curve);
  }
}
