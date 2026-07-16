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
| [`RotateEntrance`](#rotateentrance) | Fade + rotate in on mount |
| [`BlurEntrance`](#blurentrance) | Fade + blur-to-sharp on mount |
| [`FlipEntrance`](#flipentrance) | Fade + 3D flip in on mount |
| [`StaggeredList`](#staggeredlist) | Column of children with cascading FadeEntrance delays |

### State-driven

| Widget | What it does |
|---|---|
| [`AnimatedVisibility`](#animatedvisibility) | Opacity between `minOpacity` and `1.0` |
| [`AnimatedSurface`](#animatedsurface) | `Decoration` transition |
| [`ScaleToggle`](#scaletoggle) | Scale between `minScale` and `1.0` |
| [`SlideToggle`](#slidetoggle) | Slide between an offset and `Offset.zero` |
| [`ExpandableSection`](#expandablesection) | Expand/collapse a child's height |
| [`AnimatedBlur`](#animatedblur) | Blur between `0` and `sigma` |
| [`FlipCard`](#flipcard) | 3D flip between a front and back face |
| [`FadeSwitcher`](#fadeswitcher) | Cross-fade + scale between changing children |

### Interaction

| Widget | What it does |
|---|---|
| [`TapScale`](#tapscale) | Press-down scale feedback |

### Repeating / attention

| Widget | What it does |
|---|---|
| [`PulseAnimation`](#pulseanimation) | Repeating scale + fade pulse |
| [`ShakeAnimation`](#shakeanimation) | Horizontal shake triggered by a key change |
| [`BounceAnimation`](#bounceanimation) | Repeating vertical bounce |
| [`SpinAnimation`](#spinanimation) | Repeating continuous rotation |
| [`LoadingDots`](#loadingdots) | Staggered typing-indicator dots |
| [`SkeletonBox`](#skeletonbox) | Repeating shimmer for loading placeholders |

### Text & values

| Widget | What it does |
|---|---|
| [`CountUpText`](#countuptext) | Animates a number from its previous value to a new one |
| [`TypewriterText`](#typewritertext) | Reveals text character by character |
| [`RollingCounter`](#rollingcounter) | Slot-machine digit roll when a value changes |
| [`Marquee`](#marquee) | Loops overflowing text horizontally |
| [`AnimatedProgressRing`](#animatedprogressring) | Animates a circular progress ring to its value |
| [`AnimatedProgressBar`](#animatedprogressbar) | Animates a linear progress bar to its value |
| [`AnimatedCheckmark`](#animatedcheckmark) | Draws/un-draws a checkmark stroke |

## Custom easing

Every widget with a meaningful transition accepts a `curve` parameter
(defaults match each widget's built-in feel). For entrances, `curve` shapes
the motion component — the fade always uses `Curves.easeOut`.

```dart
ScaleEntrance(curve: Curves.elasticOut, child: MyBadge())
```

## Installation

```yaml
dependencies:
  animate_kit: ^0.7.0
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

### RotateEntrance

```dart
RotateEntrance(
  delay: const Duration(milliseconds: 100),
  initialTurns: -0.25, // default
  child: MyIcon(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to animate |
| `delay` | `Duration` | `Duration.zero` | Wait before starting |
| `duration` | `Duration` | `400ms` | Fade + rotate duration |
| `initialTurns` | `double` | `-0.25` | Rotation at start, in turns (`1.0` = 360°) |

---

### BlurEntrance

```dart
BlurEntrance(
  initialSigma: 8.0, // default
  child: MyHeroImage(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to animate |
| `delay` | `Duration` | `Duration.zero` | Wait before starting |
| `duration` | `Duration` | `500ms` | Fade + blur duration |
| `initialSigma` | `double` | `8.0` | Gaussian blur sigma at animation start |

---

### FlipEntrance

```dart
FlipEntrance(
  axis: FlipAxis.horizontal, // default
  child: MyCard(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to animate |
| `delay` | `Duration` | `Duration.zero` | Wait before starting |
| `duration` | `Duration` | `500ms` | Fade + flip duration |
| `axis` | `FlipAxis` | `horizontal` | Axis the child flips around |
| `initialTilt` | `double` | `-0.5` | Start tilt, fraction of a half turn |

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

### ExpandableSection

```dart
ExpandableSection(
  expanded: isOpen,
  child: FaqAnswer(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to expand/collapse (stays mounted) |
| `expanded` | `bool` | required | `true` → natural height, `false` → zero height |
| `duration` | `Duration` | `250ms` | Transition duration |

---

### AnimatedBlur

```dart
AnimatedBlur(
  blurred: !isRevealed,
  sigma: 8.0, // default
  child: SpoilerImage(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to blur |
| `blurred` | `bool` | required | `true` → blurred at `sigma`, `false` → crisp |
| `sigma` | `double` | `8.0` | Gaussian blur sigma when blurred |
| `duration` | `Duration` | `250ms` | Transition duration |

---

### FlipCard

```dart
FlipCard(
  showFront: !isRevealed,
  front: CardBack(),
  back: CardFace(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `front` | `Widget` | required | Face shown when `showFront` is true |
| `back` | `Widget` | required | Face shown when `showFront` is false |
| `showFront` | `bool` | required | Which face is visible; toggling animates a flip |
| `duration` | `Duration` | `400ms` | Flip duration |
| `axis` | `Axis` | `horizontal` | `horizontal` = left-right turn, `vertical` = top-bottom |

---

### FadeSwitcher

```dart
FadeSwitcher(
  child: isLoading
      ? const Spinner(key: ValueKey('loading'))
      : Content(key: const ValueKey('content')),
)
```

Give each distinct child a unique `Key` (same rule as `AnimatedSwitcher`).

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Current child; changing it animates the swap |
| `duration` | `Duration` | `250ms` | Cross-fade duration |
| `initialScale` | `double` | `0.95` | Incoming child's start scale; `1.0` for pure fade |

---

### TapScale

```dart
TapScale(
  onTap: submit,
  child: MyButton(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to wrap |
| `onTap` | `VoidCallback?` | `null` | Tap handler |
| `pressedScale` | `double` | `0.95` | Scale while a pointer is down |
| `duration` | `Duration` | `100ms` | Press/release transition duration |

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

### BounceAnimation

```dart
BounceAnimation(
  height: 8.0,
  child: Icon(Icons.keyboard_arrow_down),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to bounce |
| `height` | `double` | `8.0` | Peak vertical displacement (logical pixels) |
| `duration` | `Duration` | `600ms` | One full bounce cycle |

---

### SpinAnimation

```dart
SpinAnimation(
  child: Icon(Icons.sync),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget to rotate |
| `duration` | `Duration` | `1200ms` | One full rotation |
| `clockwise` | `bool` | `true` | Rotation direction |

---

### LoadingDots

```dart
LoadingDots(
  color: Theme.of(context).colorScheme.primary,
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `dotCount` | `int` | `3` | Number of dots |
| `dotSize` | `double` | `8.0` | Diameter of each dot |
| `spacing` | `double` | `4.0` | Gap between dots |
| `color` | `Color?` | `onSurfaceVariant` | Dot color |
| `duration` | `Duration` | `900ms` | One full wave cycle |

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

### AnimatedProgressRing

```dart
AnimatedProgressRing(
  value: completedTasks / totalTasks,
  // CountUpText syncs its own animation to the ring's duration, so the
  // label and the arc animate together. A plain Text child is also valid
  // but won't track the ring's in-progress value.
  child: CountUpText(
    value: completedTasks / totalTasks * 100,
    formatter: (v) => '${v.round()}%',
  ),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `double` | required | Target progress, `0.0`–`1.0` |
| `duration` | `Duration` | `600ms` | Animation duration to the new value |
| `size` | `double` | `48.0` | Ring diameter |
| `strokeWidth` | `double` | `4.0` | Ring stroke width |
| `color` | `Color?` | `ColorScheme.primary` | Progress arc color |
| `backgroundColor` | `Color?` | `ColorScheme.surfaceContainerHighest` | Track color |
| `child` | `Widget?` | `null` | Optional widget centered inside the ring |

---

### AnimatedProgressBar

```dart
AnimatedProgressBar(
  value: downloaded / total,
  semanticsLabel: 'Download progress',
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `double` | required | Target progress, `0.0`–`1.0` |
| `duration` | `Duration` | `600ms` | Animation duration to the new value |
| `height` | `double` | `8.0` | Bar height |
| `color` | `Color?` | `ColorScheme.primary` | Fill color |
| `backgroundColor` | `Color?` | `ColorScheme.surfaceContainerHighest` | Track color |
| `borderRadius` | `BorderRadiusGeometry?` | stadium (`height / 2`) | Corner radius |
| `semanticsLabel` | `String?` | `null` | Screen-reader label for the progress value |

---

### RollingCounter

```dart
RollingCounter(
  value: cartItemCount,
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `int` | required | Current value; changing it rolls each digit |
| `duration` | `Duration` | `300ms` | Roll duration |
| `curve` | `Curve` | `easeOutCubic` | Easing of the roll |
| `style` | `TextStyle?` | `null` | Text style (tabular figures applied) |
| `formatter` | `String Function(int)?` | `toString` | Custom formatter |

---

### Marquee

```dart
SizedBox(
  width: 160,
  child: Marquee(text: 'A track title far too long to fit'),
)
```

Renders as plain static text when it fits; scrolls in a seamless loop only
when it overflows.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | required | Text to display |
| `style` | `TextStyle?` | `null` | Text style |
| `velocity` | `double` | `40.0` | Scroll speed, logical px/second |
| `gap` | `double` | `32.0` | Space between the text and its looping copy |

---

### AnimatedCheckmark

```dart
AnimatedCheckmark(
  checked: isDone,
  color: Colors.green,
)
```

Purely visual — wrap it in your own tappable/semantic control.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `checked` | `bool` | required | Whether the mark is drawn |
| `size` | `double` | `24.0` | Bounding box width/height |
| `color` | `Color?` | `ColorScheme.primary` | Stroke color |
| `strokeWidth` | `double` | `3.0` | Stroke width |
| `duration` | `Duration` | `300ms` | Draw/un-draw duration |
| `curve` | `Curve` | `easeOutCubic` | Easing of the stroke draw |

---

## Accessibility & performance

- **Screen readers**: `CountUpText` and `TypewriterText` announce only the
  final value / full text — never each animation frame. `AnimatedProgressRing`
  exposes a single progress value (e.g. "70%") plus an optional
  `semanticsLabel`.
- **Grapheme-safe**: `TypewriterText` reveals by grapheme cluster, so emoji
  and combining characters are never split mid-glyph.
- **Repaint isolation**: repeating animations (`PulseAnimation`,
  `BounceAnimation`, `SkeletonBox`) are wrapped in a `RepaintBoundary` so
  their per-frame repaints don't spill into the surrounding subtree.
- **Efficient rebuilds**: widgets subscribe only to the `disableAnimations`
  MediaQuery aspect — keyboard, resize, and padding changes don't trigger
  rebuilds.
- **No idle tickers**: when reduce-motion is enabled, internal animation
  controllers never run.

## Reduce-motion behaviour

All widgets check `MediaQuery.of(context).disableAnimations`:

| Widget | Reduce-motion behaviour |
|---|---|
| `FadeEntrance` | Returns `child` unchanged |
| `ScaleEntrance` | Returns `child` unchanged |
| `RotateEntrance` | Returns `child` unchanged |
| `BlurEntrance` | Returns `child` unchanged |
| `FlipEntrance` | Returns `child` unchanged |
| `StaggeredList` | Each `FadeEntrance` snaps (no animation) |
| `AnimatedVisibility` | Snaps to target opacity via `Opacity` |
| `AnimatedSurface` | Uses `Duration.zero` — snaps immediately |
| `ScaleToggle` | Uses `Duration.zero` — snaps immediately |
| `SlideToggle` | Uses `Duration.zero` — snaps immediately |
| `ExpandableSection` | Uses `Duration.zero` — snaps immediately |
| `AnimatedBlur` | Uses `Duration.zero` — snaps immediately |
| `FlipCard` | Swaps faces instantly |
| `FadeSwitcher` | Uses `Duration.zero` — swaps instantly |
| `TapScale` | Uses `Duration.zero` — snaps immediately |
| `PulseAnimation` | Returns `child` unchanged |
| `ShakeAnimation` | Returns `child` unchanged |
| `BounceAnimation` | Returns `child` unchanged |
| `SpinAnimation` | Returns `child` unchanged |
| `LoadingDots` | Renders static dots (no ticker) |
| `SkeletonBox` | Returns `child` unchanged |
| `CountUpText` | Shows target value immediately |
| `TypewriterText` | Shows full text immediately |
| `RollingCounter` | Swaps digits instantly |
| `Marquee` | Static ellipsized text (no ticker) |
| `AnimatedProgressRing` | Shows target value immediately |
| `AnimatedProgressBar` | Shows target value immediately |
| `AnimatedCheckmark` | Snaps to final state |

## License

MIT — see [LICENSE](LICENSE).
