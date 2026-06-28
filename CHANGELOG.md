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
