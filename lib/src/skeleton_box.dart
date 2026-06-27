import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wraps [child] in a repeating shimmer for loading placeholder states.
///
/// Returns [child] unchanged when [MediaQuery.disableAnimations] is true.
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
  const SkeletonBox({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    final shimmerColor = Theme.of(context)
        .colorScheme
        .surface
        .withValues(alpha: 0.65);
    return child
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1500.ms, color: shimmerColor);
  }
}
