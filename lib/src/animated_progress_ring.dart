import 'package:flutter/material.dart';

/// Animates a circular progress ring from its previous [value] (or `0` on
/// first mount) to the new target whenever [value] changes.
///
/// Respects [MediaQuery.disableAnimations] — snaps to [value] immediately
/// when reduce-motion is enabled.
///
/// ```dart
/// AnimatedProgressRing(
///   value: completedTasks / totalTasks,
///   child: Text('${(progress * 100).round()}%'),
/// )
/// ```
class AnimatedProgressRing extends StatefulWidget {
  const AnimatedProgressRing({
    required this.value,
    this.duration = const Duration(milliseconds: 600),
    this.size = 48.0,
    this.strokeWidth = 4.0,
    this.color,
    this.backgroundColor,
    this.child,
    super.key,
  }) : assert(value >= 0.0 && value <= 1.0);

  /// Target progress, from `0.0` to `1.0`.
  final double value;

  final Duration duration;

  /// Diameter of the ring. Defaults to `48`.
  final double size;

  /// Ring stroke width. Defaults to `4`.
  final double strokeWidth;

  /// Color of the progress arc. Defaults to [ColorScheme.primary].
  final Color? color;

  /// Color of the track behind the progress arc. Defaults to
  /// [ColorScheme.surfaceContainerHighest].
  final Color? backgroundColor;

  /// Optional widget centered inside the ring (e.g. a percentage label).
  ///
  /// Rendered as-is — it does not track the ring's in-progress animated
  /// value. For a label that animates in sync with the ring, compose a
  /// [CountUpText] as the [child].
  final Widget? child;

  @override
  State<AnimatedProgressRing> createState() => _AnimatedProgressRingState();
}

class _AnimatedProgressRingState extends State<AnimatedProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressRing old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      final from = _animation.value;
      _controller.duration = widget.duration;
      _animation = Tween<double>(begin: from, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _ring(BuildContext context, double value) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: widget.strokeWidth,
            color: widget.backgroundColor ?? cs.surfaceContainerHighest,
          ),
          CircularProgressIndicator(
            value: value,
            strokeWidth: widget.strokeWidth,
            color: widget.color ?? cs.primary,
            backgroundColor: Colors.transparent,
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return _ring(context, widget.value);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => _ring(context, _animation.value),
    );
  }
}
