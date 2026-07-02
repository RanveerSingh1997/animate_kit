import 'package:flutter/material.dart';

/// Reveals [text] one character at a time over [duration].
///
/// Characters are revealed by grapheme cluster, so emoji, combining marks,
/// and other multi-code-unit characters are never split mid-glyph.
///
/// Use [delay] to postpone the start. When [text] changes, the reveal restarts
/// from the beginning. Respects [MediaQuery.disableAnimations] — shows the
/// full text immediately when reduce-motion is enabled, and the internal
/// ticker never runs.
///
/// Screen readers announce the full [text] once, not each partial reveal.
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
  late List<String> _graphemes;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _setupAnimation();
    // Started (or snapped) in didChangeDependencies, once reduce-motion is
    // known — MediaQuery is not available in initState.
  }

  void _setupAnimation() {
    // Split by grapheme cluster so surrogate pairs (emoji, etc.) are never
    // broken mid-character.
    _graphemes = widget.text.characters.toList();
    final total = widget.delay + widget.duration;
    _controller.duration = total == Duration.zero
        ? const Duration(microseconds: 1)
        : total;
    final delayFraction = total == Duration.zero
        ? 0.0
        : widget.delay.inMicroseconds / total.inMicroseconds;
    _charCount = StepTween(begin: 0, end: _graphemes.length).animate(
      CurvedAnimation(parent: _controller, curve: Interval(delayFraction, 1.0)),
    );
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
  void didUpdateWidget(TypewriterText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text ||
        old.duration != widget.duration ||
        old.delay != widget.delay) {
      _setupAnimation();
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

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion) {
      return Text(widget.text, style: widget.style);
    }
    return AnimatedBuilder(
      animation: _charCount,
      builder: (_, __) => Text(
        _graphemes.take(_charCount.value).join(),
        style: widget.style,
        // Fixed at the full text so screen readers announce it once instead
        // of re-announcing every partial reveal.
        semanticsLabel: widget.text,
      ),
    );
  }
}
