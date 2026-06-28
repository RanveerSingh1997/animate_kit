import 'package:flutter/material.dart';

/// State-driven opacity animation — fades [child] between [minOpacity] and
/// full opacity based on [visible].
///
/// Respects [MediaQuery.disableAnimations] — snaps immediately when reduce-
/// motion is enabled.
///
/// ```dart
/// AnimatedVisibility(
///   visible: isHovered,
///   minOpacity: 0.35,
///   child: ActionButton(),
/// )
/// ```
class AnimatedVisibility extends StatelessWidget {
  const AnimatedVisibility({
    required this.child,
    required this.visible,
    this.minOpacity = 0.35,
    this.duration = const Duration(milliseconds: 120),
    super.key,
  }) : assert(minOpacity >= 0.0 && minOpacity <= 1.0);

  final Widget child;
  final bool visible;
  final double minOpacity;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final opacity = visible ? 1.0 : minOpacity;
    if (reduceMotion) return Opacity(opacity: opacity, child: child);
    return AnimatedOpacity(
      opacity: opacity,
      duration: duration,
      curve: Curves.easeOut,
      child: child,
    );
  }
}
