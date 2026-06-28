import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Repeating scale + fade pulse for drawing attention (e.g. notification
/// badges, live indicators).
///
/// Loops indefinitely, alternating between full size/opacity and
/// [minScale]/[minOpacity]. Returns [child] unchanged when
/// [MediaQuery.disableAnimations] is true.
///
/// ```dart
/// PulseAnimation(
///   child: NotificationBadge(),
/// )
/// ```
class PulseAnimation extends StatelessWidget {
  const PulseAnimation({
    required this.child,
    this.minScale = 0.9,
    this.minOpacity = 0.6,
    this.duration = const Duration(milliseconds: 900),
    super.key,
  })  : assert(minScale > 0.0 && minScale <= 1.0),
        assert(minOpacity >= 0.0 && minOpacity <= 1.0);

  final Widget child;

  /// Minimum scale factor at the trough of the pulse.
  final double minScale;

  /// Minimum opacity at the trough of the pulse.
  final double minOpacity;

  /// Duration of one full pulse cycle (peak → trough → peak).
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return child
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: Offset(minScale, minScale),
          duration: duration,
          curve: Curves.easeInOut,
        )
        .fade(
          begin: 1.0,
          end: minOpacity,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }
}
