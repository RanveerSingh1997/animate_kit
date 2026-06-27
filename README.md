# animate_kit

State-driven Flutter animation primitives built on
[`flutter_animate`](https://pub.dev/packages/flutter_animate).

Every widget in this package:
- Is a plain `StatelessWidget` — no controllers, no `initState`
- Respects `MediaQuery.disableAnimations` (system reduce-motion)
- Snaps instantly when reduce-motion is on — no need to handle it yourself

## Widgets

| Widget | What it does |
|---|---|
| [`FadeEntrance`](#fadeentrance) | Fade + upward-slide entrance animation |
| [`AnimatedVisibility`](#animatedvisibility) | State-driven opacity between `minOpacity` and `1.0` |
| [`AnimatedSurface`](#animatedsurface) | State-driven `BoxDecoration` transition |
| [`SkeletonBox`](#skeletonbox) | Repeating shimmer for loading placeholders |

## Installation

```yaml
dependencies:
  animate_kit: ^0.1.0
```

## Usage

### FadeEntrance

Animates a widget into view with a fade combined with a subtle upward slide.
Use it for page-level reveals and section entrances.

```dart
import 'package:animate_kit/animate_kit.dart';

FadeEntrance(
  delay: const Duration(milliseconds: 100),
  duration: const Duration(milliseconds: 500), // default
  child: MyCard(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to animate |
| `delay` | `Duration` | `Duration.zero` | Wait before starting |
| `duration` | `Duration` | `500ms` | Fade + slide duration |

---

### AnimatedVisibility

Smoothly fades a widget between a `minOpacity` (semi-transparent) and full
opacity based on a `visible` boolean. Useful for hover effects and
contextual controls that should remain partially visible when inactive.

```dart
AnimatedVisibility(
  visible: isHovered,
  minOpacity: 0.35,           // default
  duration: const Duration(milliseconds: 120), // default
  child: ActionButton(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to fade |
| `visible` | `bool` | required | `true` → full opacity, `false` → `minOpacity` |
| `minOpacity` | `double` | `0.35` | Opacity when `visible` is false |
| `duration` | `Duration` | `120ms` | Transition duration |

---

### AnimatedSurface

Transitions a `BoxDecoration` smoothly when state changes. Drop-in
replacement for `AnimatedContainer` when only the decoration needs to animate.

```dart
AnimatedSurface(
  duration: const Duration(milliseconds: 120), // default
  decoration: BoxDecoration(
    color: isSelected
        ? Theme.of(context).colorScheme.primaryContainer
        : Colors.transparent,
    borderRadius: BorderRadius.circular(8),
  ),
  child: MyTile(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `decoration` | `BoxDecoration` | required | Target decoration |
| `child` | `Widget` | required | Child widget |
| `duration` | `Duration` | `120ms` | Transition duration |

---

### SkeletonBox

Wraps any widget in a repeating shimmer for loading placeholder states.
Pair it with sized, rounded containers that match the shape of real content.

```dart
SkeletonBox(
  child: Container(
    width: 200,
    height: 16,
    decoration: BoxDecoration(
      color: Colors.grey.shade800,
      borderRadius: BorderRadius.circular(4),
    ),
  ),
)

// Multiple lines
Column(
  children: [
    SkeletonBox(child: Container(width: double.infinity, height: 16)),
    const SizedBox(height: 8),
    SkeletonBox(child: Container(width: 140, height: 16)),
  ],
)
```

---

## Reduce-motion behaviour

All widgets check `MediaQuery.of(context).disableAnimations`:

| Widget | Reduce-motion behaviour |
|---|---|
| `FadeEntrance` | Returns `child` unchanged — no animation applied |
| `AnimatedVisibility` | Snaps to target opacity instantly via `Opacity` |
| `AnimatedSurface` | Uses `Duration.zero` — `AnimatedContainer` snaps |
| `SkeletonBox` | Returns `child` unchanged — no shimmer applied |

## License

MIT — see [LICENSE](LICENSE).
