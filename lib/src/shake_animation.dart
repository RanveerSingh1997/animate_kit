import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Plays a horizontal shake on [child] each time [trigger] changes.
///
/// Pass a new value for [trigger] (e.g. an error counter or form key) whenever
/// a shake should fire. Returns [child] unchanged when
/// [MediaQuery.disableAnimations] is true.
///
/// ```dart
/// ShakeAnimation(
///   trigger: _errorCount,
///   child: MyTextField(),
/// )
/// ```
class ShakeAnimation extends StatelessWidget {
  const ShakeAnimation({
    required this.child,
    required this.trigger,
    this.duration = const Duration(milliseconds: 500),
    this.offset = 6.0,
    super.key,
  });

  final Widget child;

  /// Change this value to fire a new shake (e.g. increment an error counter).
  final Object trigger;

  /// Total duration of one shake. Defaults to 500ms.
  final Duration duration;

  /// Maximum horizontal displacement in logical pixels. Defaults to 6.
  final double offset;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return child
        .animate(key: ValueKey(trigger))
        .shake(duration: duration, hz: 4, offset: Offset(offset, 0));
  }
}
