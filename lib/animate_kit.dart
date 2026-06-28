/// State-driven Flutter animation primitives.
///
/// All widgets respect [MediaQuery.disableAnimations] (reduce-motion).
///
/// Entrance animations:
/// - [FadeEntrance]       — fade + directional slide on mount
/// - [ScaleEntrance]      — fade + scale in on mount
/// - [StaggeredList]      — column of children with staggered FadeEntrance
///
/// State-driven:
/// - [AnimatedVisibility] — opacity between minOpacity and 1.0
/// - [AnimatedSurface]    — Decoration transition
/// - [ScaleToggle]        — scale between minScale and 1.0
/// - [SlideToggle]        — slides between an offset and Offset.zero
///
/// Repeating / attention:
/// - [PulseAnimation]     — repeating scale pulse
/// - [ShakeAnimation]     — shake triggered by a key change
/// - [SkeletonBox]        — repeating shimmer for loading placeholders
///
/// Text:
/// - [CountUpText]        — animates a number to its value
/// - [TypewriterText]     — reveals text character by character
library animate_kit;

export 'src/animated_surface.dart';
export 'src/animated_visibility.dart';
export 'src/count_up_text.dart';
export 'src/fade_entrance.dart';
export 'src/pulse_animation.dart';
export 'src/scale_entrance.dart';
export 'src/scale_toggle.dart';
export 'src/shake_animation.dart';
export 'src/skeleton_box.dart';
export 'src/slide_toggle.dart';
export 'src/staggered_list.dart';
export 'src/typewriter_text.dart';
