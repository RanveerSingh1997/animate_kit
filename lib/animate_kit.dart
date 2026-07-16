/// State-driven Flutter animation primitives.
///
/// All widgets respect [MediaQuery.disableAnimations] (reduce-motion).
///
/// Entrance animations:
/// - [FadeEntrance]         — fade + directional slide on mount
/// - [ScaleEntrance]        — fade + scale in on mount
/// - [RotateEntrance]       — fade + rotate in on mount
/// - [BlurEntrance]         — fade + blur-to-sharp on mount
/// - [FlipEntrance]         — fade + 3D flip in on mount
/// - [StaggeredList]        — column of children with staggered FadeEntrance
///
/// State-driven:
/// - [AnimatedVisibility]   — opacity between minOpacity and 1.0
/// - [AnimatedSurface]      — Decoration transition
/// - [ScaleToggle]          — scale between minScale and 1.0
/// - [SlideToggle]          — slides between an offset and Offset.zero
/// - [ExpandableSection]    — expands/collapses child height
/// - [AnimatedBlur]         — blur between 0 and sigma
/// - [FlipCard]             — 3D flip between a front and back face
/// - [FadeSwitcher]         — cross-fade + scale between changing children
///
/// Interaction:
/// - [TapScale]             — press-down scale feedback
///
/// Repeating / attention:
/// - [PulseAnimation]       — repeating scale pulse
/// - [ShakeAnimation]       — shake triggered by a key change
/// - [BounceAnimation]      — repeating vertical bounce
/// - [SpinAnimation]        — repeating continuous rotation
/// - [LoadingDots]          — staggered typing-indicator dots
/// - [SkeletonBox]          — repeating shimmer for loading placeholders
///
/// Text & values:
/// - [CountUpText]          — animates a number to its value
/// - [TypewriterText]       — reveals text character by character
/// - [RollingCounter]       — slot-machine digit roll on value change
/// - [Marquee]              — loops overflowing text horizontally
/// - [AnimatedProgressRing] — animates a circular progress ring to its value
/// - [AnimatedProgressBar]  — animates a linear progress bar to its value
/// - [AnimatedCheckmark]    — draws/un-draws a checkmark stroke
library;

export 'src/animated_blur.dart';
export 'src/animated_checkmark.dart';
export 'src/animated_progress_bar.dart';
export 'src/animated_progress_ring.dart';
export 'src/animated_surface.dart';
export 'src/animated_visibility.dart';
export 'src/blur_entrance.dart';
export 'src/bounce_animation.dart';
export 'src/count_up_text.dart';
export 'src/expandable_section.dart';
export 'src/fade_entrance.dart';
export 'src/fade_switcher.dart';
export 'src/flip_card.dart';
export 'src/flip_entrance.dart';
export 'src/loading_dots.dart';
export 'src/marquee.dart';
export 'src/pulse_animation.dart';
export 'src/rolling_counter.dart';
export 'src/rotate_entrance.dart';
export 'src/scale_entrance.dart';
export 'src/scale_toggle.dart';
export 'src/shake_animation.dart';
export 'src/skeleton_box.dart';
export 'src/slide_toggle.dart';
export 'src/spin_animation.dart';
export 'src/staggered_list.dart';
export 'src/tap_scale.dart';
export 'src/typewriter_text.dart';
