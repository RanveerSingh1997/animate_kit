import 'package:flutter/material.dart';

/// Press-down scale feedback — shrinks [child] to [pressedScale] while a
/// pointer is down and springs back on release.
///
/// Wraps [child] in a [GestureDetector]; use [onTap] for the tap action.
/// With reduce-motion enabled the scale snaps instantly (the tap still
/// works).
///
/// ```dart
/// TapScale(
///   onTap: submit,
///   child: MyButton(),
/// )
/// ```
class TapScale extends StatefulWidget {
  const TapScale({
    required this.child,
    this.onTap,
    this.pressedScale = 0.95,
    this.duration = const Duration(milliseconds: 100),
    super.key,
  }) : assert(pressedScale > 0.0 && pressedScale <= 1.0);

  final Widget child;

  /// Called when the child is tapped.
  final VoidCallback? onTap;

  /// Scale while pressed. Defaults to `0.95`.
  final double pressedScale;

  /// Duration of the press/release transition. Defaults to 100ms.
  final Duration duration;

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : widget.duration;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        // Clamp defensively: the constructor assert is stripped in release
        // mode.
        scale: _pressed ? widget.pressedScale.clamp(0.001, 1.0) : 1.0,
        duration: resolvedDuration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
