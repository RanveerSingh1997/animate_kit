import 'package:flutter/material.dart';

/// State-driven slide animation — slides [child] between [hiddenOffset] and
/// [Offset.zero] based on [visible].
///
/// Wraps Flutter's [AnimatedSlide] with a reduce-motion guard.
/// [hiddenOffset] is in fractional units: `Offset(0, 1)` means one full
/// widget height below the natural position.
///
/// ```dart
/// SlideToggle(
///   visible: isExpanded,
///   hiddenOffset: const Offset(0, -1), // slides in from above
///   child: MyPanel(),
/// )
/// ```
class SlideToggle extends StatelessWidget {
  const SlideToggle({
    required this.child,
    required this.visible,
    this.hiddenOffset = const Offset(0, 1),
    this.duration = const Duration(milliseconds: 300),
    super.key,
  });

  final Widget child;

  /// When `true`, the widget is at its natural position. When `false`, slides
  /// to [hiddenOffset].
  final bool visible;

  /// Fractional offset used when [visible] is `false`. Defaults to
  /// `Offset(0, 1)` (one full height below).
  final Offset hiddenOffset;

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : duration;
    return AnimatedSlide(
      offset: visible ? Offset.zero : hiddenOffset,
      duration: resolvedDuration,
      curve: Curves.easeOut,
      child: child,
    );
  }
}
