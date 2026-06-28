# animate_kit

State-driven Flutter animation primitives.
All widgets respect `MediaQuery.disableAnimations` (system reduce-motion) and
require no controllers or `initState`.

## Widgets

### Entrance animations

| Widget | What it does |
|---|---|
| [`FadeEntrance`](#fadeentrance) | Fade + configurable-direction slide on mount |
| [`ScaleEntrance`](#scaleentrance) | Fade + scale in on mount |
| [`StaggeredList`](#staggeredlist) | Column of children with cascading FadeEntrance delays |

### State-driven

| Widget | What it does |
|---|---|
| [`AnimatedVisibility`](#animatedvisibility) | Opacity between `minOpacity` and `1.0` |
| [`AnimatedSurface`](#animatedsurface) | `Decoration` transition |
| [`ScaleToggle`](#scaletoggle) | Scale between `minScale` and `1.0` |
| [`SlideToggle`](#slidetoggle) | Slide between an offset and `Offset.zero` |

### Repeating / attention

| Widget | What it does |
|---|---|
| [`PulseAnimation`](#pulseanimation) | Repeating scale + fade pulse |
| [`ShakeAnimation`](#shakeanimation) | Horizontal shake triggered by a key change |
| [`SkeletonBox`](#skeletonbox) | Repeating shimmer for loading placeholders |

### Text

| Widget | What it does |
|---|---|
| [`CountUpText`](#countuptext) | Animates a number from its previous value to a new one |
| [`TypewriterText`](#typewritertext) | Reveals text character by character |

## Installation

```yaml
dependencies:
  animate_kit: ^0.3.0
```

## Usage

### FadeEntrance

```dart
FadeEntrance(
  delay: const Duration(milliseconds: 100),
  direction: FadeSlideDirection.up, // default
  child: MyCard(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to animate |
| `delay` | `Duration` | `Duration.zero` | Wait before starting |
| `duration` | `Duration` | `500ms` | Fade + slide duration |
| `direction` | `FadeSlideDirection` | `up` | Slide direction; `none` for fade-only |

`FadeSlideDirection` values: `up`, `down`, `left`, `right`, `none`.

---

### ScaleEntrance

```dart
ScaleEntrance(
  delay: const Duration(milliseconds: 150),
  initialScale: 0.85, // default
  child: MyDialog(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to animate |
| `delay` | `Duration` | `Duration.zero` | Wait before starting |
| `duration` | `Duration` | `400ms` | Fade + scale duration |
| `initialScale` | `double` | `0.85` | Scale at animation start (`0.0`–`1.0`) |

---

### StaggeredList

```dart
StaggeredList(
  itemDelay: const Duration(milliseconds: 60),
  children: items.map((e) => ItemTile(e)).toList(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `children` | `List<Widget>` | required | Items to stagger |
| `itemDelay` | `Duration` | `80ms` | Extra delay added per item index |
| `duration` | `Duration` | `400ms` | Each item's FadeEntrance duration |
| `direction` | `FadeSlideDirection` | `up` | Slide direction for each item |
| `crossAxisAlignment` | `CrossAxisAlignment` | `start` | Column alignment |

---

### AnimatedVisibility

```dart
AnimatedVisibility(
  visible: isHovered,
  minOpacity: 0.35,
  ignorePointerWhenHidden: true,
  child: ActionButton(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to fade |
| `visible` | `bool` | required | `true` → full opacity, `false` → `minOpacity` |
| `minOpacity` | `double` | `0.35` | Opacity when `visible` is false |
| `duration` | `Duration` | `120ms` | Transition duration |
| `ignorePointerWhenHidden` | `bool` | `false` | Block hit-testing when `visible` is false |

---

### AnimatedSurface

```dart
AnimatedSurface(
  decoration: BoxDecoration(
    color: isSelected ? Colors.blue : Colors.grey,
    borderRadius: BorderRadius.circular(8),
  ),
  child: MyTile(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `decoration` | `Decoration` | required | Target decoration |
| `child` | `Widget` | required | Child widget |
| `duration` | `Duration` | `120ms` | Transition duration |

---

### ScaleToggle

```dart
ScaleToggle(
  scaled: isSelected,
  minScale: 0.9,
  child: MyCard(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to scale |
| `scaled` | `bool` | required | `true` → full size, `false` → `minScale` |
| `minScale` | `double` | `0.9` | Scale when `scaled` is false (`(0.0, 1.0]`) |
| `duration` | `Duration` | `150ms` | Transition duration |

---

### SlideToggle

```dart
SlideToggle(
  visible: isExpanded,
  hiddenOffset: const Offset(0, -1), // slides in from above
  child: MyPanel(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to slide |
| `visible` | `bool` | required | `true` → natural position, `false` → `hiddenOffset` |
| `hiddenOffset` | `Offset` | `Offset(0, 1)` | Fractional offset when hidden (one height below) |
| `duration` | `Duration` | `300ms` | Transition duration |

---

### PulseAnimation

```dart
PulseAnimation(
  minScale: 0.9,
  minOpacity: 0.6,
  child: NotificationBadge(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to pulse |
| `minScale` | `double` | `0.9` | Scale at trough of pulse |
| `minOpacity` | `double` | `0.6` | Opacity at trough of pulse |
| `duration` | `Duration` | `900ms` | One full pulse cycle |

---

### ShakeAnimation

```dart
ShakeAnimation(
  trigger: _errorCount, // increment to fire a shake
  child: MyTextField(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to shake |
| `trigger` | `Object` | required | Change this value to replay the shake |
| `duration` | `Duration` | `500ms` | Duration of one shake |
| `offset` | `double` | `6.0` | Max horizontal displacement (logical pixels) |

---

### SkeletonBox

```dart
SkeletonBox(
  child: Container(
    width: 200, height: 16,
    decoration: BoxDecoration(
      color: Colors.grey.shade800,
      borderRadius: BorderRadius.circular(4),
    ),
  ),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to shimmer |
| `color` | `Color?` | `surface@65%` | Shimmer highlight color |
| `duration` | `Duration` | `1500ms` | Duration of one shimmer cycle |

---

### CountUpText

```dart
CountUpText(
  value: totalScore.toDouble(),
  formatter: (v) => v.toInt().toString(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `double` | required | Target number to count to |
| `duration` | `Duration` | `800ms` | Count-up animation duration |
| `style` | `TextStyle?` | `null` | Text style |
| `formatter` | `String Function(double)?` | rounded int | Custom number formatter |

---

### TypewriterText

```dart
TypewriterText(
  text: 'Hello, world!',
  duration: const Duration(milliseconds: 1200),
  delay: const Duration(milliseconds: 300),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | required | Text to reveal |
| `duration` | `Duration` | `1200ms` | Total reveal duration |
| `delay` | `Duration` | `Duration.zero` | Wait before starting |
| `style` | `TextStyle?` | `null` | Text style |

---

## Reduce-motion behaviour

All widgets check `MediaQuery.of(context).disableAnimations`:

| Widget | Reduce-motion behaviour |
|---|---|
| `FadeEntrance` | Returns `child` unchanged |
| `ScaleEntrance` | Returns `child` unchanged |
| `StaggeredList` | Each `FadeEntrance` snaps (no animation) |
| `AnimatedVisibility` | Snaps to target opacity via `Opacity` |
| `AnimatedSurface` | Uses `Duration.zero` — snaps immediately |
| `ScaleToggle` | Uses `Duration.zero` — snaps immediately |
| `SlideToggle` | Uses `Duration.zero` — snaps immediately |
| `PulseAnimation` | Returns `child` unchanged |
| `ShakeAnimation` | Returns `child` unchanged |
| `SkeletonBox` | Returns `child` unchanged |
| `CountUpText` | Shows target value immediately |
| `TypewriterText` | Shows full text immediately |

## License

MIT — see [LICENSE](LICENSE).
