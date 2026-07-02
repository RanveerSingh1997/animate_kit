/// State-driven Flutter animation primitives.
///
/// All widgets respect [MediaQuery.disableAnimations] (reduce-motion).
///
/// Entrance animations:
/// - [FadeEntrance]         — fade + directional slide on mount
/// - [ScaleEntrance]        — fade + scale in on mount
/// - [RotateEntrance]       — fade + rotate in on mount
/// - [StaggeredList]        — column of children with staggered FadeEntrance
///
/// State-driven:
/// - [AnimatedVisibility]   — opacity between minOpacity and 1.0
/// - [AnimatedSurface]      — Decoration transition
/// - [ScaleToggle]          — scale between minScale and 1.0
/// - [SlideToggle]          — slides between an offset and Offset.zero
/// - [ExpandableSection]    — expands/collapses child height
///
/// Repeating / attention:
/// - [PulseAnimation]       — repeating scale pulse
/// - [ShakeAnimation]       — shake triggered by a key change
/// - [BounceAnimation]      — repeating vertical bounce
/// - [SkeletonBox]          — repeating shimmer for loading placeholders
///
/// Text & values:
/// - [CountUpText]          — animates a number to its value
/// - [TypewriterText]       — reveals text character by character
/// - [AnimatedProgressRing] — animates a circular progress ring to its value
library animate_kit;

export 'src/animated_progress_ring.dart';
export 'src/animated_surface.dart';
export 'src/animated_visibility.dart';
export 'src/bounce_animation.dart';
export 'src/count_up_text.dart';
export 'src/expandable_section.dart';
export 'src/fade_entrance.dart';
export 'src/pulse_animation.dart';
export 'src/rotate_entrance.dart';
export 'src/scale_entrance.dart';
export 'src/scale_toggle.dart';
export 'src/shake_animation.dart';
export 'src/skeleton_box.dart';
export 'src/slide_toggle.dart';
export 'src/staggered_list.dart';
export 'src/typewriter_text.dart';
