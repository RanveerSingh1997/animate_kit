/// State-driven Flutter animation primitives built on flutter_animate.
///
/// All widgets respect [MediaQuery.disableAnimations] (reduce-motion).
///
/// - [FadeEntrance]       — fade + slide-Y entrance animation
/// - [AnimatedVisibility] — state-driven opacity (visible / minOpacity)
/// - [AnimatedSurface]    — state-driven Decoration transition
/// - [SkeletonBox]        — repeating shimmer for loading placeholders
library animate_kit;

export 'src/animated_surface.dart';
export 'src/animated_visibility.dart';
export 'src/fade_entrance.dart';
export 'src/skeleton_box.dart';
