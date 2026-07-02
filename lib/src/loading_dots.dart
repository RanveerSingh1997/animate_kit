import 'package:flutter/material.dart';

/// Repeating "typing indicator" — a row of dots that bob up and fade in a
/// staggered wave.
///
/// Respects [MediaQuery.disableAnimations] — renders static dots (no ticker)
/// when reduce-motion is enabled.
///
/// ```dart
/// LoadingDots(
///   color: Theme.of(context).colorScheme.primary,
/// )
/// ```
class LoadingDots extends StatefulWidget {
  const LoadingDots({
    this.dotCount = 3,
    this.dotSize = 8.0,
    this.spacing = 4.0,
    this.color,
    this.duration = const Duration(milliseconds: 900),
    super.key,
  }) : assert(dotCount > 0),
       assert(dotSize > 0.0),
       assert(spacing >= 0.0);

  /// Number of dots. Defaults to 3.
  final int dotCount;

  /// Diameter of each dot. Defaults to `8`.
  final double dotSize;

  /// Gap between dots. Defaults to `4`.
  final double spacing;

  /// Dot color. Defaults to [ColorScheme.onSurfaceVariant].
  final Color? color;

  /// Duration of one full wave cycle. Defaults to 900ms.
  final Duration duration;

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    // Started in didChangeDependencies, once reduce-motion is known —
    // MediaQuery is not available in initState.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _controller.stop();
      _controller.value = 0.0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LoadingDots old) {
    super.didUpdateWidget(old);
    if (old.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (!_reduceMotion) _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(Color color) => Container(
    width: widget.dotSize,
    height: widget.dotSize,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  @override
  Widget build(BuildContext context) {
    final color =
        widget.color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    if (_reduceMotion) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < widget.dotCount; i++) ...[
            if (i > 0) SizedBox(width: widget.spacing),
            _dot(color),
          ],
        ],
      );
    }
    // Single shared controller with staggered intervals — all dots stay in
    // phase (independent controllers per dot would drift apart).
    // RepaintBoundary isolates the endless repaints from the subtree.
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < widget.dotCount; i++) ...[
                if (i > 0) SizedBox(width: widget.spacing),
                _buildAnimatedDot(i, color),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedDot(int index, Color color) {
    // Each dot's bob occupies half the cycle, staggered so the wave travels
    // across all dots within the other half.
    final start = widget.dotCount == 1
        ? 0.0
        : 0.5 * index / (widget.dotCount - 1);
    final t = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, start + 0.5, curve: Curves.easeInOut),
    ).value;
    // 0 → 1 → 0 over the interval.
    final wave = t <= 0.5 ? t * 2 : (1 - t) * 2;
    return Opacity(
      opacity: 0.4 + 0.6 * wave,
      child: Transform.translate(
        offset: Offset(0, -0.5 * widget.dotSize * wave),
        child: _dot(color),
      ),
    );
  }
}
