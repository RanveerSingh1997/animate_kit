import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wraps [child] in a repeating shimmer for loading placeholder states.
///
/// Returns [child] unchanged when [MediaQuery.disableAnimations] is true.
///
/// [color] defaults to [ColorScheme.surface] at 65% opacity. Provide an
/// explicit value when the child's background differs from the surface color.
///
/// ```dart
/// SkeletonBox(
///   child: Container(
///     width: 200,
///     height: 16,
///     decoration: BoxDecoration(
///       color: Colors.grey.shade800,
///       borderRadius: BorderRadius.circular(4),
///     ),
///   ),
/// )
/// ```
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    required this.child,
    this.color,
    this.duration = const Duration(milliseconds: 1500),
    super.key,
  });

  final Widget child;

  /// Shimmer highlight color. Defaults to [ColorScheme.surface] at 65% opacity.
  final Color? color;

  /// Duration of one shimmer cycle. Defaults to 1500ms.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final shimmerColor =
        color ?? Theme.of(context).colorScheme.surface.withValues(alpha: 0.65);
    // RepaintBoundary isolates the endlessly repainting shimmer from the
    // surrounding subtree.
    return RepaintBoundary(
      child: child
          .animate(onPlay: (c) => c.repeat())
          .shimmer(duration: duration, color: shimmerColor),
    );
  }
}
