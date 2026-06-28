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
    this.ignorePointerWhenHidden = false,
    super.key,
  }) : assert(minOpacity >= 0.0 && minOpacity <= 1.0);

  final Widget child;
  final bool visible;
  final double minOpacity;
  final Duration duration;

  /// When `true` and [visible] is `false`, wraps the result in [IgnorePointer]
  /// to block hit-testing while the widget is at [minOpacity].
  final bool ignorePointerWhenHidden;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final opacity = visible ? 1.0 : minOpacity;

    final Widget result;
    if (reduceMotion) {
      result = Opacity(opacity: opacity, child: child);
    } else {
      result = AnimatedOpacity(
        opacity: opacity,
        duration: duration,
        curve: Curves.easeOut,
        child: child,
      );
    }

    if (ignorePointerWhenHidden && !visible) {
      return IgnorePointer(child: result);
    }
    return result;
  }
}
