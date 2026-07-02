import 'package:flutter/material.dart';

/// State-driven decoration animation — transitions [decoration] over [duration]
/// using a smooth curve.
///
/// Accepts any [Decoration] subtype, including [BoxDecoration] and
/// [ShapeDecoration]. Respects [MediaQuery.disableAnimations].
///
/// ```dart
/// AnimatedSurface(
///   decoration: BoxDecoration(
///     color: isSelected ? Colors.blue : Colors.grey,
///     borderRadius: BorderRadius.circular(8),
///   ),
///   child: MyTile(),
/// )
/// ```
class AnimatedSurface extends StatelessWidget {
  const AnimatedSurface({
    required this.decoration,
    required this.child,
    this.duration = const Duration(milliseconds: 120),
    super.key,
  });

  final Decoration decoration;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration;
    return AnimatedContainer(
      duration: resolvedDuration,
      curve: Curves.easeOut,
      decoration: decoration,
      child: child,
    );
  }
}
