import 'package:flutter/material.dart';

/// Cross-fades (with a subtle scale) between children when [child] changes.
///
/// A thin wrapper over [AnimatedSwitcher] with production-ready defaults and
/// a reduce-motion guard. Give each distinct child a unique [Key] — as with
/// [AnimatedSwitcher], children of the same type need keys to be treated as
/// different.
///
/// ```dart
/// FadeSwitcher(
///   child: isLoading
///       ? const CircularProgressIndicator(key: ValueKey('loading'))
///       : content,
/// )
/// ```
class FadeSwitcher extends StatelessWidget {
  const FadeSwitcher({
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.initialScale = 0.95,
    this.curve = Curves.easeOut,
    super.key,
  }) : assert(initialScale > 0.0 && initialScale <= 1.0);

  /// Current child. Changing it (or its [Key]) animates the swap.
  final Widget child;

  final Duration duration;

  /// Scale the incoming child starts at. Set to `1.0` for a pure cross-fade.
  final double initialScale;

  /// Easing of the incoming child (the outgoing child uses [Curves.easeIn]).
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration;
    return AnimatedSwitcher(
      duration: resolvedDuration,
      switchInCurve: curve,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: initialScale.clamp(0.001, 1.0),
            end: 1.0,
          ).animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
