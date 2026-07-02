import 'package:flutter/material.dart';

/// State-driven expand/collapse container — animates [child]'s effective
/// height between `0` and its natural height based on [expanded].
///
/// [child] stays mounted (and keeps its state) at all times; only its
/// rendered height animates. Useful for accordions, FAQ lists, and
/// collapsible panels.
///
/// Respects [MediaQuery.disableAnimations] — snaps immediately when reduce-
/// motion is enabled.
///
/// ```dart
/// ExpandableSection(
///   expanded: _isOpen,
///   child: FaqAnswer(),
/// )
/// ```
class ExpandableSection extends StatelessWidget {
  const ExpandableSection({
    required this.child,
    required this.expanded,
    this.duration = const Duration(milliseconds: 250),
    super.key,
  });

  final Widget child;

  /// When `true`, [child] is shown at its natural height. When `false`,
  /// collapses to zero height.
  final bool expanded;

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration;
    return AnimatedSize(
      duration: resolvedDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: expanded ? 1.0 : 0.0,
          child: child,
        ),
      ),
    );
  }
}
