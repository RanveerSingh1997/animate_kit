import 'package:flutter/material.dart';

/// State-driven checkmark that draws itself with an animated stroke when
/// [checked] becomes `true`, and un-draws when it becomes `false`.
///
/// Purely visual — wrap it in your own tappable/semantic control (e.g.
/// inside a custom checkbox). Respects [MediaQuery.disableAnimations] —
/// snaps to the final state when reduce-motion is enabled.
///
/// ```dart
/// AnimatedCheckmark(
///   checked: isDone,
///   color: Colors.green,
/// )
/// ```
class AnimatedCheckmark extends StatelessWidget {
  const AnimatedCheckmark({
    required this.checked,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 3.0,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    super.key,
  }) : assert(size > 0.0),
       assert(strokeWidth > 0.0);

  /// Whether the checkmark is drawn.
  final bool checked;

  /// Width and height of the mark's bounding box. Defaults to `24`.
  final double size;

  /// Stroke color. Defaults to [ColorScheme.primary].
  final Color? color;

  /// Stroke width. Defaults to `3`.
  final double strokeWidth;

  final Duration duration;

  /// Easing of the stroke draw.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration;
    final strokeColor = color ?? Theme.of(context).colorScheme.primary;
    return TweenAnimationBuilder<double>(
      tween: Tween(end: checked ? 1.0 : 0.0),
      duration: resolvedDuration,
      curve: curve,
      builder: (context, progress, _) => CustomPaint(
        size: Size.square(size),
        painter: _CheckmarkPainter(
          progress: progress,
          color: strokeColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  const _CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.53)
      ..lineTo(size.width * 0.42, size.height * 0.75)
      ..lineTo(size.width * 0.82, size.height * 0.28);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (progress >= 1.0) {
      canvas.drawPath(path, paint);
      return;
    }
    // Draw only the leading fraction of the stroke.
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(_CheckmarkPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
