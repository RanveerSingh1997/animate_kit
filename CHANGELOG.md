## 0.6.0

New widgets (all respect `MediaQuery.disableAnimations`, follow the
package's semantics and repaint-isolation standards):

- `BlurEntrance`: fade + blur-to-sharp on mount.
- `FlipEntrance`: fade + 3D flip in on mount (`FlipAxis` horizontal/vertical).
- `FlipCard`: state-driven 3D flip between a front and back face.
- `AnimatedBlur`: state-driven Gaussian blur toggle (spoilers, focus
  effects); skips the filter entirely when crisp.
- `FadeSwitcher`: cross-fade + subtle scale between changing children —
  an `AnimatedSwitcher` with production defaults and reduce-motion guard.
- `TapScale`: press-down scale feedback wrapping a `GestureDetector`.
- `SpinAnimation`: repeating continuous rotation for loading/sync
  indicators, repaint-isolated.
- `LoadingDots`: staggered "typing indicator" dots driven by a single
  shared controller (dots can't drift out of phase), repaint-isolated,
  no ticker under reduce-motion.
- `AnimatedProgressBar`: linear counterpart to `AnimatedProgressRing`,
  with the same single-announcement semantics and `semanticsLabel`.

## 0.5.0

Production hardening — performance, robustness, and accessibility.

Performance:

- All widgets now use aspect-scoped `MediaQuery.disableAnimationsOf` instead
  of `MediaQuery.of`, so they no longer rebuild on unrelated MediaQuery
  changes (keyboard, resize, padding).
- `PulseAnimation`, `BounceAnimation`, and `SkeletonBox` wrap their endlessly
  repeating animations in a `RepaintBoundary`, isolating per-frame repaints
  from the surrounding subtree.
- `CountUpText`, `TypewriterText`, and `AnimatedProgressRing` no longer run
  their internal ticker when reduce-motion is enabled, and snap correctly if
  reduce-motion toggles mid-animation.

Robustness:

- `TypewriterText` now reveals text by grapheme cluster — emoji, combining
  marks, and other multi-code-unit characters are never split mid-glyph.
- Range-checked parameters (`minOpacity`, `minScale`, progress `value`) are
  defensively clamped at render time, since constructor asserts are stripped
  in release builds.
- `CountUpText` / `AnimatedProgressRing` now pick up `duration` changes that
  arrive without a simultaneous value change.

Accessibility:

- `CountUpText` and `TypewriterText` announce only the final value / full
  text to screen readers instead of every animation frame.
- `AnimatedProgressRing` exposes a single semantic progress value (e.g.
  "70%") — the background track no longer leaks a "100%" announcement. Added
  optional `semanticsLabel` parameter.

Tooling:

- Added `analysis_options.yaml` (flutter_lints was previously inactive).
- Added GitHub Actions CI: format check, analyze (fatal-infos), tests, and
  `pub publish --dry-run` validation.
- Codebase is now `dart format` clean.

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
