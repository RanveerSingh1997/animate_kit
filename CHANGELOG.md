## 0.4.0

New widgets (all respect `MediaQuery.disableAnimations`):

- `RotateEntrance`: fade + rotate in on mount.
- `ExpandableSection`: state-driven expand/collapse of a child's height,
  keeping the child mounted (and its state preserved) while collapsed.
- `BounceAnimation`: repeating vertical bounce for attention effects.
- `AnimatedProgressRing`: animates a circular progress ring to its value;
  reruns on change, with an optional centered child (e.g. a percentage label).

## 0.3.0

New widgets (all respect `MediaQuery.disableAnimations`):

- `ScaleEntrance`: fade + scale in on mount.
- `StaggeredList`: column of children with cascading `FadeEntrance` delays.
- `ScaleToggle`: state-driven scale between `minScale` and `1.0`.
- `SlideToggle`: state-driven slide between `hiddenOffset` and `Offset.zero`.
- `PulseAnimation`: repeating scale + fade pulse for attention effects.
- `ShakeAnimation`: horizontal shake replayed whenever `trigger` changes.
- `CountUpText`: animates a number to its value; reruns on change.
- `TypewriterText`: reveals text character by character with optional delay.

## 0.2.0

- `FadeEntrance`: added `direction` parameter (`FadeSlideDirection` enum —
  `up`, `down`, `left`, `right`, `none`). Defaults to `up` (backward-compatible).
- `AnimatedVisibility`: added `ignorePointerWhenHidden` parameter — wraps with
  `IgnorePointer` when `visible` is false so hidden content can't receive taps.
- `AnimatedSurface`: widened `decoration` type from `BoxDecoration` to
  `Decoration` — `ShapeDecoration` and custom subclasses now animate correctly.
- `SkeletonBox`: added `color` and `duration` parameters with sensible defaults.
- Added `topics:` to `pubspec.yaml` for pub.dev discoverability.
- Added `example/` with a runnable demo app showing all four widgets.

## 0.1.1

- `AnimatedVisibility`: fixed first-mount opacity flash by switching from
  `flutter_animate` target-based animation to `AnimatedOpacity`.
- `AnimatedVisibility`: fixed asymmetric easing on hide — `Curves.easeOut` now
  applies identically in both directions.
- `AnimatedVisibility`: added `assert` to clamp `minOpacity` to `[0.0, 1.0]`.
- Hardened tests: scoped widget finders, non-vacuous shimmer check, fixed
  `FadeEntrance` delay assertion.

## 0.1.0

- Initial extraction from sdraw monorepo.
- `FadeEntrance`: fade + slide-Y entrance animation.
- `AnimatedVisibility`: state-driven opacity with configurable `minOpacity`.
- `AnimatedSurface`: state-driven `BoxDecoration` transition.
- `SkeletonBox`: repeating shimmer for loading placeholder states.
- All widgets respect `MediaQuery.disableAnimations`.
