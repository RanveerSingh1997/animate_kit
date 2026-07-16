import 'package:flutter/material.dart';

/// Horizontally scrolling text for content that overflows its container.
///
/// When [text] fits the available width it renders as plain static [Text].
/// When it overflows, it scrolls in a seamless loop at [velocity] logical
/// pixels per second, separated by [gap].
///
/// Respects [MediaQuery.disableAnimations] — renders static ellipsized text
/// (no ticker) when reduce-motion is enabled.
///
/// Screen readers announce the full [text] once.
///
/// ```dart
/// SizedBox(
///   width: 160,
///   child: Marquee(text: 'A track title far too long to fit'),
/// )
/// ```
class Marquee extends StatefulWidget {
  const Marquee({
    required this.text,
    this.style,
    this.velocity = 40.0,
    this.gap = 32.0,
    super.key,
  }) : assert(velocity > 0.0),
       assert(gap > 0.0);

  final String text;
  final TextStyle? style;

  /// Scroll speed in logical pixels per second. Defaults to `40`.
  final double velocity;

  /// Blank space between the end of the text and its looping copy.
  /// Defaults to `32`.
  final double gap;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _measureTextWidth(TextStyle? style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  void _syncController(double loopWidth) {
    final seconds = loopWidth / widget.velocity;
    final duration = Duration(milliseconds: (seconds * 1000).round());
    if (_controller.duration != duration) {
      _controller.duration = duration;
      _controller.repeat();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    return LayoutBuilder(
      builder: (context, constraints) {
        final textWidth = _measureTextWidth(style, constraints.maxWidth);
        final fits = textWidth <= constraints.maxWidth;
        if (fits || reduceMotion) {
          _controller.stop();
          return Text(
            widget.text,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }
        final loopWidth = textWidth + widget.gap;
        _syncController(loopWidth);
        // Two copies of the text scroll left by one loop width per cycle,
        // producing a seamless wrap. RepaintBoundary isolates the endless
        // repaints; Semantics announces the full text once.
        return Semantics(
          label: widget.text,
          child: ExcludeSemantics(
            child: ClipRect(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(-loopWidth * _controller.value, 0),
                    child: child,
                  ),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.text, style: style, maxLines: 1),
                          SizedBox(width: widget.gap),
                          Text(widget.text, style: style, maxLines: 1),
                          SizedBox(width: widget.gap),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
