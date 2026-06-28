import 'package:flutter/material.dart';

/// Reveals [text] one character at a time over [duration].
///
/// Use [delay] to postpone the start. When [text] changes, the reveal restarts
/// from the beginning. Respects [MediaQuery.disableAnimations] — shows the
/// full text immediately when reduce-motion is enabled.
///
/// ```dart
/// TypewriterText(
///   text: 'Hello, world!',
///   duration: const Duration(milliseconds: 1200),
/// )
/// ```
class TypewriterText extends StatefulWidget {
  const TypewriterText({
    required this.text,
    this.duration = const Duration(milliseconds: 1200),
    this.delay = Duration.zero,
    this.style,
    super.key,
  });

  final String text;
  final Duration duration;
  final Duration delay;
  final TextStyle? style;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _setupAnimation();
    _controller.forward();
  }

  void _setupAnimation() {
    final total = widget.delay + widget.duration;
    _controller.duration = total == Duration.zero
        ? const Duration(microseconds: 1)
        : total;
    final delayFraction = total == Duration.zero
        ? 0.0
        : widget.delay.inMicroseconds / total.inMicroseconds;
    _charCount = StepTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(delayFraction, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  void didUpdateWidget(TypewriterText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text ||
        old.duration != widget.duration ||
        old.delay != widget.delay) {
      _setupAnimation();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return Text(widget.text, style: widget.style);
    }
    return AnimatedBuilder(
      animation: _charCount,
      builder: (_, __) => Text(
        widget.text.substring(0, _charCount.value),
        style: widget.style,
      ),
    );
  }
}
