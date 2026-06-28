import 'package:flutter/material.dart';

/// Animates a numeric [value] from its previous value (or `0` on first mount)
/// to the new target whenever [value] changes.
///
/// Respects [MediaQuery.disableAnimations] — snaps to [value] immediately when
/// reduce-motion is enabled.
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
    this.style,
    this.formatter,
    super.key,
  });

  final double value;
  final Duration duration;
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
  void didUpdateWidget(CountUpText old) {
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

  String _format(double v) =>
      widget.formatter != null ? widget.formatter!(v) : v.round().toString();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return Text(_format(widget.value), style: widget.style);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Text(_format(_animation.value), style: widget.style),
    );
  }
}
