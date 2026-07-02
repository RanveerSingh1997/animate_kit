import 'package:flutter/material.dart';

/// State-driven scale animation — scales [child] between [minScale] and `1.0`
/// based on [scaled].
///
/// Mirrors [AnimatedVisibility] but for size. Useful for selection feedback,
/// press states, and expand/collapse indicators.
///
/// Respects [MediaQuery.disableAnimations] — snaps instantly when reduce-motion
/// is enabled.
///
/// ```dart
/// ScaleToggle(
///   scaled: isSelected,
///   minScale: 0.9,
///   child: MyCard(),
/// )
/// ```
class ScaleToggle extends StatelessWidget {
  const ScaleToggle({
    required this.child,
    required this.scaled,
    this.minScale = 0.9,
    this.duration = const Duration(milliseconds: 150),
    super.key,
  }) : assert(minScale > 0.0 && minScale <= 1.0);

  final Widget child;

  /// When `true`, the widget is at full size. When `false`, scales to [minScale].
  final bool scaled;

  /// Scale factor when [scaled] is `false`. Must be in `(0.0, 1.0]`.
  final double minScale;

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration;
    return AnimatedScale(
      // Clamp defensively: the constructor assert is stripped in release mode.
      scale: scaled ? 1.0 : minScale.clamp(0.001, 1.0),
      duration: resolvedDuration,
      curve: Curves.easeOut,
      child: child,
    );
  }
}
