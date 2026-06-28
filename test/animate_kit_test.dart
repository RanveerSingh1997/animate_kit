import 'package:animate_kit/animate_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {bool disableAnimations = false}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('FadeEntrance', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(
        const FadeEntrance(child: Text('hello')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('returns child directly when reduce-motion enabled',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const FadeEntrance(child: Text('hello')),
        disableAnimations: true,
      ));
      // No animation timer — no pumpAndSettle needed.
      expect(find.text('hello'), findsOneWidget);
    });

    // Fix 6: verify delay is honoured by checking FadeTransition opacity
    // is still 0 when pumped to halfway through the delay.
    testWidgets('delay postpones animation start', (tester) async {
      const delay = Duration(milliseconds: 100);
      await tester.pumpWidget(_wrap(
        const FadeEntrance(
          delay: delay,
          duration: Duration(milliseconds: 200),
          child: Text('hello'),
        ),
      ));
      // Advance to halfway through the delay — fadeIn hasn't started yet.
      await tester.pump(const Duration(milliseconds: 50));
      final fade = tester.widget<FadeTransition>(
        find.descendant(
          of: find.byType(FadeEntrance),
          matching: find.byType(FadeTransition),
        ),
      );
      expect(fade.opacity.value, closeTo(0.0, 0.01));
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('direction: none produces no SlideTransition', (tester) async {
      await tester.pumpWidget(_wrap(
        const FadeEntrance(
          direction: FadeSlideDirection.none,
          child: Text('hello'),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FadeEntrance),
          matching: find.byType(SlideTransition),
        ),
        findsNothing,
      );
    });

    testWidgets('direction: up produces a SlideTransition', (tester) async {
      await tester.pumpWidget(_wrap(
        const FadeEntrance(child: Text('hello')),
      ));
      // Before settling the slide is in progress.
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(FadeEntrance),
          matching: find.byType(SlideTransition),
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
    });
  });

  group('ScaleEntrance', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(const ScaleEntrance(child: Text('hi'))));
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('returns child directly when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
          _wrap(const ScaleEntrance(child: Text('hi')), disableAnimations: true));
      expect(find.text('hi'), findsOneWidget);
      // No Animate wrapper when reduce-motion is on.
      expect(
        find.descendant(
            of: find.byType(ScaleEntrance), matching: find.byType(Animate)),
        findsNothing,
      );
    });

    testWidgets('applies fade and scale effects via Animate wrapper',
        (tester) async {
      await tester.pumpWidget(_wrap(const ScaleEntrance(child: Text('hi'))));
      await tester.pump();
      // flutter_animate's scale() uses Transform.scale (not ScaleTransition).
      // Verify the Animate wrapper and FadeTransition (from fadeIn) are present.
      expect(
        find.descendant(
            of: find.byType(ScaleEntrance), matching: find.byType(Animate)),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: find.byType(ScaleEntrance), matching: find.byType(FadeTransition)),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
    });

    testWidgets('asserts when initialScale is out of range', (tester) async {
      expect(
        () => ScaleEntrance(initialScale: -0.1, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => ScaleEntrance(initialScale: 1.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('StaggeredList', () {
    testWidgets('renders all children', (tester) async {
      await tester.pumpWidget(_wrap(
        const StaggeredList(children: [Text('a'), Text('b'), Text('c')]),
      ));
      await tester.pumpAndSettle();
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
    });

    testWidgets('wraps each child in FadeEntrance', (tester) async {
      await tester.pumpWidget(_wrap(
        const StaggeredList(children: [Text('a'), Text('b'), Text('c')]),
      ));
      expect(find.byType(FadeEntrance), findsNWidgets(3));
      await tester.pumpAndSettle();
    });

    testWidgets('renders empty list without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const StaggeredList(children: []),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StaggeredList), findsOneWidget);
    });
  });

  group('ScaleToggle', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(
        const ScaleToggle(scaled: true, child: Text('hi')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('target scale is 1.0 when scaled=true', (tester) async {
      await tester.pumpWidget(_wrap(
        const ScaleToggle(scaled: true, child: Text('hi')),
      ));
      final widget = tester.widget<AnimatedScale>(
        find.descendant(
            of: find.byType(ScaleToggle), matching: find.byType(AnimatedScale)),
      );
      expect(widget.scale, closeTo(1.0, 0.001));
    });

    testWidgets('target scale is minScale when scaled=false', (tester) async {
      await tester.pumpWidget(_wrap(
        const ScaleToggle(scaled: false, minScale: 0.8, child: Text('hi')),
      ));
      final widget = tester.widget<AnimatedScale>(
        find.descendant(
            of: find.byType(ScaleToggle), matching: find.byType(AnimatedScale)),
      );
      expect(widget.scale, closeTo(0.8, 0.001));
    });

    testWidgets('uses Duration.zero when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const ScaleToggle(scaled: false, child: Text('hi')),
        disableAnimations: true,
      ));
      final widget = tester.widget<AnimatedScale>(
        find.descendant(
            of: find.byType(ScaleToggle), matching: find.byType(AnimatedScale)),
      );
      expect(widget.duration, Duration.zero);
    });

    testWidgets('asserts when minScale is out of range', (tester) async {
      expect(
        () => ScaleToggle(scaled: true, minScale: 0.0, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => ScaleToggle(scaled: true, minScale: 1.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('SlideToggle', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(
        const SlideToggle(visible: true, child: Text('hi')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('offset is Offset.zero when visible=true', (tester) async {
      await tester.pumpWidget(_wrap(
        const SlideToggle(visible: true, child: Text('hi')),
      ));
      final widget = tester.widget<AnimatedSlide>(
        find.descendant(
            of: find.byType(SlideToggle), matching: find.byType(AnimatedSlide)),
      );
      expect(widget.offset, Offset.zero);
    });

    testWidgets('offset is hiddenOffset when visible=false', (tester) async {
      const hidden = Offset(1, 0);
      await tester.pumpWidget(_wrap(
        const SlideToggle(
            visible: false, hiddenOffset: hidden, child: Text('hi')),
      ));
      final widget = tester.widget<AnimatedSlide>(
        find.descendant(
            of: find.byType(SlideToggle), matching: find.byType(AnimatedSlide)),
      );
      expect(widget.offset, hidden);
    });

    testWidgets('uses Duration.zero when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const SlideToggle(visible: false, child: Text('hi')),
        disableAnimations: true,
      ));
      final widget = tester.widget<AnimatedSlide>(
        find.descendant(
            of: find.byType(SlideToggle), matching: find.byType(AnimatedSlide)),
      );
      expect(widget.duration, Duration.zero);
    });
  });

  group('AnimatedVisibility', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedVisibility(visible: true, child: Text('hello')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    // Fix 1+2: AnimatedOpacity starts at the target immediately — no
    // first-frame flash from minOpacity and no easing asymmetry on hide.
    testWidgets('visible=true starts at full opacity on first frame', (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedVisibility(visible: true, child: Text('hello')),
      ));
      await tester.pump(); // single frame — before any animation could complete
      final fade = tester.widget<FadeTransition>(
        find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(FadeTransition),
        ),
      );
      expect(fade.opacity.value, closeTo(1.0, 0.001));
    });

    // Fix 4: scope the Opacity finder to AnimatedVisibility descendants so
    // a future Flutter internal Opacity doesn't cause StateError.
    testWidgets('snaps to minOpacity via Opacity when reduce-motion on and not visible',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedVisibility(
          visible: false,
          minOpacity: 0.35,
          child: Text('hello'),
        ),
        disableAnimations: true,
      ));
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, closeTo(0.35, 0.001));
    });

    testWidgets('snaps to full opacity via Opacity when reduce-motion on and visible',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedVisibility(visible: true, child: Text('hello')),
        disableAnimations: true,
      ));
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, closeTo(1.0, 0.001));
    });

    testWidgets('accepts custom minOpacity', (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedVisibility(
          visible: false,
          minOpacity: 0.1,
          child: Text('hello'),
        ),
        disableAnimations: true,
      ));
      final opacity = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, closeTo(0.1, 0.001));
    });

    // Fix 3: assert on out-of-range minOpacity.
    test('asserts when minOpacity is out of range', () {
      expect(
        () => AnimatedVisibility(
            visible: true, minOpacity: 1.5, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => AnimatedVisibility(
            visible: true, minOpacity: -0.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });

    testWidgets('toggles opacity target on visible change', (tester) async {
      bool visible = true;
      late StateSetter setState;
      await tester.pumpWidget(StatefulBuilder(builder: (context, s) {
        setState = s;
        return _wrap(AnimatedVisibility(visible: visible, child: const Text('hi')));
      }));
      await tester.pump();
      expect(
        tester.widget<AnimatedOpacity>(find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(AnimatedOpacity),
        )).opacity,
        closeTo(1.0, 0.001),
      );
      setState(() => visible = false);
      await tester.pumpAndSettle();
      expect(
        tester.widget<AnimatedOpacity>(find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(AnimatedOpacity),
        )).opacity,
        closeTo(0.35, 0.001),
      );
      setState(() => visible = true);
      await tester.pumpAndSettle();
      expect(
        tester.widget<AnimatedOpacity>(find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(AnimatedOpacity),
        )).opacity,
        closeTo(1.0, 0.001),
      );
    });

    testWidgets('wraps in IgnorePointer when ignorePointerWhenHidden and not visible',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedVisibility(
          visible: false,
          ignorePointerWhenHidden: true,
          child: Text('hello'),
        ),
      ));
      expect(
        find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(IgnorePointer),
        ),
        findsOneWidget,
      );
    });

    testWidgets('no IgnorePointer when visible is true', (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedVisibility(
          visible: true,
          ignorePointerWhenHidden: true,
          child: Text('hello'),
        ),
      ));
      expect(
        find.descendant(
          of: find.byType(AnimatedVisibility),
          matching: find.byType(IgnorePointer),
        ),
        findsNothing,
      );
    });
  });

  group('PulseAnimation', () {
    testWidgets('applies Animate wrapper when animations enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const PulseAnimation(child: SizedBox(width: 20, height: 20)),
      ));
      expect(
        find.descendant(
            of: find.byType(PulseAnimation), matching: find.byType(Animate)),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 1000));
    });

    testWidgets('returns child directly when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const PulseAnimation(child: Text('live')),
        disableAnimations: true,
      ));
      expect(find.text('live'), findsOneWidget);
      expect(
        find.descendant(
            of: find.byType(PulseAnimation), matching: find.byType(Animate)),
        findsNothing,
      );
    });

    testWidgets('asserts when minScale and minOpacity are out of range', (tester) async {
      expect(
        () => PulseAnimation(minScale: 0.0, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => PulseAnimation(minOpacity: -0.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('ShakeAnimation', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(
        const ShakeAnimation(trigger: 0, child: Text('field')),
      ));
      await tester.pumpAndSettle();
      expect(find.text('field'), findsOneWidget);
    });

    testWidgets('returns child directly when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const ShakeAnimation(trigger: 0, child: Text('field')),
        disableAnimations: true,
      ));
      expect(find.text('field'), findsOneWidget);
      expect(
        find.descendant(
            of: find.byType(ShakeAnimation), matching: find.byType(Animate)),
        findsNothing,
      );
    });

    testWidgets('changing trigger replays animation', (tester) async {
      int trigger = 0;
      late StateSetter setState;
      await tester.pumpWidget(StatefulBuilder(builder: (context, s) {
        setState = s;
        return _wrap(ShakeAnimation(trigger: trigger, child: const Text('field')));
      }));
      await tester.pumpAndSettle();
      // Change trigger to fire a new shake.
      setState(() => trigger = 1);
      await tester.pump();
      // Animation is running — FadeTransition or Animate is active.
      expect(
        find.descendant(
            of: find.byType(ShakeAnimation), matching: find.byType(Animate)),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
    });
  });

  group('AnimatedSurface', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedSurface(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('hello'),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('uses Duration.zero when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedSurface(
          decoration: BoxDecoration(color: Colors.red),
          child: SizedBox(),
        ),
        disableAnimations: true,
      ));
      final container =
          tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(container.duration, Duration.zero);
    });

    testWidgets('uses provided duration when animations enabled', (tester) async {
      const dur = Duration(milliseconds: 250);
      await tester.pumpWidget(_wrap(
        const AnimatedSurface(
          decoration: BoxDecoration(color: Colors.red),
          duration: dur,
          child: SizedBox(),
        ),
      ));
      final container =
          tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(container.duration, dur);
    });

    testWidgets('decoration color transitions mid-tween', (tester) async {
      bool selected = false;
      late StateSetter setState;
      await tester.pumpWidget(StatefulBuilder(builder: (context, s) {
        setState = s;
        return _wrap(AnimatedSurface(
          duration: const Duration(milliseconds: 200),
          decoration:
              BoxDecoration(color: selected ? Colors.blue : Colors.red),
          child: const SizedBox(width: 100, height: 100),
        ));
      }));
      setState(() => selected = true);
      await tester.pump(); // start animation
      await tester.pump(const Duration(milliseconds: 100)); // ~halfway
      final box = tester.firstWidget<DecoratedBox>(
        find.descendant(
          of: find.byType(AnimatedSurface),
          matching: find.byType(DecoratedBox),
        ),
      );
      final color = (box.decoration as BoxDecoration).color!;
      // Mid-tween color should have both red and blue components.
      expect(color.r, greaterThan(0.0));
      expect(color.b, greaterThan(0.0));
      await tester.pumpAndSettle();
    });

    testWidgets('accepts ShapeDecoration (Decoration subtype)', (tester) async {
      await tester.pumpWidget(_wrap(
        AnimatedSurface(
          decoration: ShapeDecoration(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const SizedBox(width: 80, height: 80),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedSurface), findsOneWidget);
    });
  });

  group('CountUpText', () {
    testWidgets('shows final value when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const CountUpText(value: 42),
        disableAnimations: true,
      ));
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('counts up to value over duration', (tester) async {
      await tester.pumpWidget(_wrap(
        const CountUpText(value: 100, duration: Duration(milliseconds: 400)),
      ));
      // Mid-animation — should show a partial value.
      await tester.pump(const Duration(milliseconds: 200));
      final text = tester.widget<Text>(
        find.descendant(
            of: find.byType(CountUpText), matching: find.byType(Text)),
      );
      final displayed = int.parse(text.data!);
      expect(displayed, greaterThan(0));
      expect(displayed, lessThan(100));
      await tester.pumpAndSettle();
    });

    testWidgets('shows full value after animation completes', (tester) async {
      await tester.pumpWidget(_wrap(
        const CountUpText(value: 99, duration: Duration(milliseconds: 200)),
      ));
      await tester.pumpAndSettle();
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('custom formatter is applied', (tester) async {
      await tester.pumpWidget(_wrap(
        CountUpText(
          value: 5,
          formatter: (v) => '\$${v.toInt()}',
        ),
        disableAnimations: true,
      ));
      expect(find.text('\$5'), findsOneWidget);
    });

    testWidgets('reruns animation when value changes', (tester) async {
      double val = 10;
      late StateSetter setState;
      await tester.pumpWidget(StatefulBuilder(builder: (context, s) {
        setState = s;
        return _wrap(CountUpText(value: val));
      }));
      await tester.pumpAndSettle();
      expect(find.text('10'), findsOneWidget);
      setState(() => val = 50);
      await tester.pumpAndSettle();
      expect(find.text('50'), findsOneWidget);
    });
  });

  group('TypewriterText', () {
    testWidgets('shows full text when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const TypewriterText(text: 'hello'),
        disableAnimations: true,
      ));
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('starts with partial text during animation', (tester) async {
      await tester.pumpWidget(_wrap(
        const TypewriterText(
          text: 'hello world',
          duration: Duration(milliseconds: 600),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 300)); // halfway
      final text = tester.widget<Text>(
        find.descendant(
            of: find.byType(TypewriterText), matching: find.byType(Text)),
      );
      // Should have some characters but not all 11.
      expect(text.data!.length, greaterThan(0));
      expect(text.data!.length, lessThan(11));
      await tester.pumpAndSettle();
    });

    testWidgets('shows full text after animation completes', (tester) async {
      await tester.pumpWidget(_wrap(
        const TypewriterText(
          text: 'hi',
          duration: Duration(milliseconds: 200),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('restarts when text changes', (tester) async {
      String txt = 'abc';
      late StateSetter setState;
      await tester.pumpWidget(StatefulBuilder(builder: (context, s) {
        setState = s;
        return _wrap(TypewriterText(
          text: txt,
          duration: const Duration(milliseconds: 200),
        ));
      }));
      await tester.pumpAndSettle();
      expect(find.text('abc'), findsOneWidget);
      setState(() => txt = 'xyz');
      await tester.pumpAndSettle();
      expect(find.text('xyz'), findsOneWidget);
    });

    testWidgets('delay defers start', (tester) async {
      await tester.pumpWidget(_wrap(
        const TypewriterText(
          text: 'hi',
          duration: Duration(milliseconds: 300),
          delay: Duration(milliseconds: 200),
        ),
      ));
      // During delay window — text should still be empty.
      await tester.pump(const Duration(milliseconds: 100));
      final text = tester.widget<Text>(
        find.descendant(
            of: find.byType(TypewriterText), matching: find.byType(Text)),
      );
      expect(text.data, isEmpty);
      await tester.pumpAndSettle();
    });
  });

  group('SkeletonBox', () {
    // Fix 5: verify the Animate wrapper is present, not just that the child
    // exists (which would pass even if SkeletonBox returned child directly).
    testWidgets('applies shimmer animation when animations enabled', (tester) async {
      await tester.pumpWidget(_wrap(
        const SkeletonBox(child: SizedBox(width: 100, height: 16)),
      ));
      // SkeletonBox repeats forever — advance past one shimmer cycle instead
      // of pumpAndSettle (which would never settle).
      await tester.pump(const Duration(milliseconds: 1600));
      expect(
        find.descendant(
          of: find.byType(SkeletonBox),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
    });

    testWidgets('returns child directly when reduce-motion enabled',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const SkeletonBox(child: Text('loading')),
        disableAnimations: true,
      ));
      expect(find.text('loading'), findsOneWidget);
      expect(find.byType(Animate), findsNothing);
    });

    testWidgets('custom color and duration smoke test', (tester) async {
      await tester.pumpWidget(_wrap(
        const SkeletonBox(
          color: Colors.white,
          duration: Duration(milliseconds: 800),
          child: SizedBox(width: 100, height: 16),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 900));
      expect(
        find.descendant(
          of: find.byType(SkeletonBox),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
    });
  });
}
