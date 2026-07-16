import 'package:flutter/material.dart';

/// Animates a numeric [value] from its previous value (or `0` on first mount)
/// to the new target whenever [value] changes.
///
/// Respects [MediaQuery.disableAnimations] — snaps to [value] immediately when
/// reduce-motion is enabled, and the internal ticker never runs.
///
/// Screen readers announce only the final [value], not every animation frame.
///
/// ```dart
/// CountUpText(
///   value: totalScore.toDouble(),
///   duration: const Duration(milliseconds: 800),
///   formatter: (v) => v.toInt().toString(),
/// )
/// ```
class CountUpText extends StatefulWidget {
  const CountUpText({
    required this.value,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOut,
    this.style,
    this.formatter,
    super.key,
  });

  final double value;
  final Duration duration;

  /// Easing of the count-up.
  final Curve curve;

  final TextStyle? style;

  /// Custom number formatter. Defaults to rounded integer string.
  final String Function(double)? formatter;

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    // Started (or snapped) in didChangeDependencies, once reduce-motion is
    // known — MediaQuery is not available in initState.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      // Complete instantly so a later reduce-motion toggle never reveals a
      // stale mid-flight value.
      _controller.value = 1.0;
    } else if (!_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CountUpText old) {
    super.didUpdateWidget(old);
    if (old.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (old.value != widget.value) {
      final from = _animation.value;
      _animation = Tween<double>(
        begin: from,
        end: widget.value,
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

  String _format(double v) =>
      widget.formatter != null ? widget.formatter!(v) : v.round().toString();

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion) {
      return Text(_format(widget.value), style: widget.style);
    }
    // semanticsLabel stays fixed at the target value so screen readers
    // announce the result once instead of every animation frame.
    final semanticsLabel = _format(widget.value);
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Text(
        _format(_animation.value),
        style: widget.style,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}
