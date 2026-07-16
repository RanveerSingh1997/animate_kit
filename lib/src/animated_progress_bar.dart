import 'package:flutter/material.dart';

/// Animates a linear progress bar from its previous [value] (or `0` on
/// first mount) to the new target whenever [value] changes.
///
/// The linear counterpart of [AnimatedProgressRing].
///
/// Respects [MediaQuery.disableAnimations] — snaps to [value] immediately
/// when reduce-motion is enabled, and the internal ticker never runs.
///
/// Screen readers announce a single progress value (e.g. "70%") instead of
/// per-frame values.
///
/// ```dart
/// AnimatedProgressBar(
///   value: downloaded / total,
/// )
/// ```
class AnimatedProgressBar extends StatefulWidget {
  const AnimatedProgressBar({
    required this.value,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.height = 8.0,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.semanticsLabel,
    super.key,
  }) : assert(value >= 0.0 && value <= 1.0),
       assert(height > 0.0);

  /// Target progress, from `0.0` to `1.0`.
  final double value;

  final Duration duration;

  /// Easing of the progress animation.
  final Curve curve;

  /// Bar height. Defaults to `8`.
  final double height;

  /// Fill color. Defaults to [ColorScheme.primary].
  final Color? color;

  /// Track color. Defaults to [ColorScheme.surfaceContainerHighest].
  final Color? backgroundColor;

  /// Corner radius. Defaults to a stadium shape (`height / 2`).
  final BorderRadiusGeometry? borderRadius;

  /// Label announced by screen readers alongside the progress value
  /// (e.g. "Download progress").
  final String? semanticsLabel;

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _reduceMotion = false;

  // Clamp defensively: the constructor assert is stripped in release mode.
  double get _targetValue => widget.value.clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(
      begin: 0,
      end: _targetValue,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    // Started (or snapped) in didChangeDependencies, once reduce-motion is
    // known — MediaQuery is not available in initState.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _controller.value = 1.0;
    } else if (!_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedProgressBar old) {
    super.didUpdateWidget(old);
    if (old.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (old.value != widget.value) {
      final from = _animation.value;
      _animation = Tween<double>(
        begin: from,
        end: _targetValue,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
      if (_reduceMotion) {
        _controller.value = 1.0;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bar(BuildContext context, double value) {
    final cs = Theme.of(context).colorScheme;
    final radius =
        widget.borderRadius ?? BorderRadius.circular(widget.height / 2);
    return Semantics(
      label: widget.semanticsLabel,
      value: '${(_targetValue * 100).round()}%',
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          height: widget.height,
          color: widget.backgroundColor ?? cs.surfaceContainerHighest,
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
            widthFactor: value,
            heightFactor: 1.0,
            child: ColoredBox(color: widget.color ?? cs.primary),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion) {
      return _bar(context, _targetValue);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => _bar(context, _animation.value),
    );
  }
}
