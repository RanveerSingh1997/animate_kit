import 'package:flutter/material.dart';

/// Slot-machine style counter — when [value] changes, each character column
/// rolls vertically to its new digit (up for increases, down for decreases).
///
/// Digits render with tabular figures so columns don't shift as they change.
/// Respects [MediaQuery.disableAnimations] — swaps digits instantly when
/// reduce-motion is enabled.
///
/// Screen readers announce the whole number once, not per-digit changes.
///
/// ```dart
/// RollingCounter(
///   value: cartItemCount,
/// )
/// ```
class RollingCounter extends StatefulWidget {
  const RollingCounter({
    required this.value,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    this.style,
    this.formatter,
    super.key,
  });

  /// Current value. Changing it rolls each changed digit column.
  final int value;

  final Duration duration;

  /// Easing of the roll.
  final Curve curve;

  final TextStyle? style;

  /// Custom formatter (e.g. add thousands separators). Defaults to
  /// `value.toString()`.
  final String Function(int)? formatter;

  @override
  State<RollingCounter> createState() => _RollingCounterState();
}

class _RollingCounterState extends State<RollingCounter> {
  late int _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(RollingCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _previousValue = old.value;
    }
  }

  String _format(int v) =>
      widget.formatter != null ? widget.formatter!(v) : v.toString();

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final text = _format(widget.value);
    final increased = widget.value >= _previousValue;
    final style = (widget.style ?? DefaultTextStyle.of(context).style).copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    if (reduceMotion) {
      return Text(text, style: style);
    }

    // Each character column is an AnimatedSwitcher keyed by
    // position + character, so only changed columns roll.
    return Semantics(
      label: text,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < text.length; i++)
              ClipRect(
                child: AnimatedSwitcher(
                  duration: widget.duration,
                  switchInCurve: widget.curve,
                  switchOutCurve: widget.curve.flipped,
                  transitionBuilder: (child, animation) {
                    final incoming = child.key == ValueKey('$i-${text[i]}');
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(
                            0,
                            incoming
                                ? (increased ? 1 : -1)
                                : (increased ? -1 : 1),
                          ),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    text[i],
                    key: ValueKey('$i-${text[i]}'),
                    style: style,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
