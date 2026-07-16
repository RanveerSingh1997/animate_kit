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
      await tester.pumpWidget(_wrap(const FadeEntrance(child: Text('hello'))));
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const FadeEntrance(child: Text('hello')),
          disableAnimations: true,
        ),
      );
      // No animation timer — no pumpAndSettle needed.
      expect(find.text('hello'), findsOneWidget);
    });

    // Fix 6: verify delay is honoured by checking FadeTransition opacity
    // is still 0 when pumped to halfway through the delay.
    testWidgets('delay postpones animation start', (tester) async {
      const delay = Duration(milliseconds: 100);
      await tester.pumpWidget(
        _wrap(
          const FadeEntrance(
            delay: delay,
            duration: Duration(milliseconds: 200),
            child: Text('hello'),
          ),
        ),
      );
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
      await tester.pumpWidget(
        _wrap(
          const FadeEntrance(
            direction: FadeSlideDirection.none,
            child: Text('hello'),
          ),
        ),
      );
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
      await tester.pumpWidget(_wrap(const FadeEntrance(child: Text('hello'))));
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

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const ScaleEntrance(child: Text('hi')), disableAnimations: true),
      );
      expect(find.text('hi'), findsOneWidget);
      // No Animate wrapper when reduce-motion is on.
      expect(
        find.descendant(
          of: find.byType(ScaleEntrance),
          matching: find.byType(Animate),
        ),
        findsNothing,
      );
    });

    testWidgets('applies fade and scale effects via Animate wrapper', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const ScaleEntrance(child: Text('hi'))));
      await tester.pump();
      // flutter_animate's scale() uses Transform.scale (not ScaleTransition).
      // Verify the Animate wrapper and FadeTransition (from fadeIn) are present.
      expect(
        find.descendant(
          of: find.byType(ScaleEntrance),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ScaleEntrance),
          matching: find.byType(FadeTransition),
        ),
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

  group('RotateEntrance', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(const RotateEntrance(child: Text('hi'))));
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const RotateEntrance(child: Text('hi')), disableAnimations: true),
      );
      expect(find.text('hi'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(RotateEntrance),
          matching: find.byType(Animate),
        ),
        findsNothing,
      );
    });

    testWidgets('applies fade and rotate effects via Animate wrapper', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const RotateEntrance(child: Text('hi'))));
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(RotateEntrance),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(RotateEntrance),
          matching: find.byType(FadeTransition),
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
    });

    testWidgets('asserts when initialTurns is out of range', (tester) async {
      expect(
        () => RotateEntrance(initialTurns: -1.1, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => RotateEntrance(initialTurns: 1.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('StaggeredList', () {
    testWidgets('renders all children', (tester) async {
      await tester.pumpWidget(
        _wrap(const StaggeredList(children: [Text('a'), Text('b'), Text('c')])),
      );
      await tester.pumpAndSettle();
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
    });

    testWidgets('wraps each child in FadeEntrance', (tester) async {
      await tester.pumpWidget(
        _wrap(const StaggeredList(children: [Text('a'), Text('b'), Text('c')])),
      );
      expect(find.byType(FadeEntrance), findsNWidgets(3));
      await tester.pumpAndSettle();
    });

    testWidgets('renders empty list without error', (tester) async {
      await tester.pumpWidget(_wrap(const StaggeredList(children: [])));
      await tester.pumpAndSettle();
      expect(find.byType(StaggeredList), findsOneWidget);
    });
  });

  group('ScaleToggle', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const ScaleToggle(scaled: true, child: Text('hi'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('target scale is 1.0 when scaled=true', (tester) async {
      await tester.pumpWidget(
        _wrap(const ScaleToggle(scaled: true, child: Text('hi'))),
      );
      final widget = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(ScaleToggle),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(widget.scale, closeTo(1.0, 0.001));
    });

    testWidgets('target scale is minScale when scaled=false', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ScaleToggle(scaled: false, minScale: 0.8, child: Text('hi')),
        ),
      );
      final widget = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(ScaleToggle),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(widget.scale, closeTo(0.8, 0.001));
    });

    testWidgets('uses Duration.zero when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const ScaleToggle(scaled: false, child: Text('hi')),
          disableAnimations: true,
        ),
      );
      final widget = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(ScaleToggle),
          matching: find.byType(AnimatedScale),
        ),
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
      await tester.pumpWidget(
        _wrap(const SlideToggle(visible: true, child: Text('hi'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('offset is Offset.zero when visible=true', (tester) async {
      await tester.pumpWidget(
        _wrap(const SlideToggle(visible: true, child: Text('hi'))),
      );
      final widget = tester.widget<AnimatedSlide>(
        find.descendant(
          of: find.byType(SlideToggle),
          matching: find.byType(AnimatedSlide),
        ),
      );
      expect(widget.offset, Offset.zero);
    });

    testWidgets('offset is hiddenOffset when visible=false', (tester) async {
      const hidden = Offset(1, 0);
      await tester.pumpWidget(
        _wrap(
          const SlideToggle(
            visible: false,
            hiddenOffset: hidden,
            child: Text('hi'),
          ),
        ),
      );
      final widget = tester.widget<AnimatedSlide>(
        find.descendant(
          of: find.byType(SlideToggle),
          matching: find.byType(AnimatedSlide),
        ),
      );
      expect(widget.offset, hidden);
    });

    testWidgets('uses Duration.zero when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SlideToggle(visible: false, child: Text('hi')),
          disableAnimations: true,
        ),
      );
      final widget = tester.widget<AnimatedSlide>(
        find.descendant(
          of: find.byType(SlideToggle),
          matching: find.byType(AnimatedSlide),
        ),
      );
      expect(widget.duration, Duration.zero);
    });
  });

  group('ExpandableSection', () {
    testWidgets('renders child when expanded', (tester) async {
      await tester.pumpWidget(
        _wrap(const ExpandableSection(expanded: true, child: Text('hi'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('keeps child mounted when collapsed', (tester) async {
      await tester.pumpWidget(
        _wrap(const ExpandableSection(expanded: false, child: Text('hi'))),
      );
      await tester.pumpAndSettle();
      // Child stays in the tree (state preserved) even though height is 0.
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('heightFactor is 1.0 when expanded, 0.0 when collapsed', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const ExpandableSection(expanded: true, child: Text('hi'))),
      );
      var align = tester.widget<Align>(
        find.descendant(
          of: find.byType(ExpandableSection),
          matching: find.byType(Align),
        ),
      );
      expect(align.heightFactor, 1.0);

      await tester.pumpWidget(
        _wrap(const ExpandableSection(expanded: false, child: Text('hi'))),
      );
      await tester.pumpAndSettle();
      align = tester.widget<Align>(
        find.descendant(
          of: find.byType(ExpandableSection),
          matching: find.byType(Align),
        ),
      );
      expect(align.heightFactor, 0.0);
    });

    testWidgets('uses Duration.zero when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const ExpandableSection(expanded: true, child: Text('hi')),
          disableAnimations: true,
        ),
      );
      final size = tester.widget<AnimatedSize>(
        find.descendant(
          of: find.byType(ExpandableSection),
          matching: find.byType(AnimatedSize),
        ),
      );
      expect(size.duration, Duration.zero);
    });
  });

  group('AnimatedVisibility', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const AnimatedVisibility(visible: true, child: Text('hello'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    // Fix 1+2: AnimatedOpacity starts at the target immediately — no
    // first-frame flash from minOpacity and no easing asymmetry on hide.
    testWidgets('visible=true starts at full opacity on first frame', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AnimatedVisibility(visible: true, child: Text('hello'))),
      );
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
    testWidgets(
      'snaps to minOpacity via Opacity when reduce-motion on and not visible',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AnimatedVisibility(
              visible: false,
              minOpacity: 0.35,
              child: Text('hello'),
            ),
            disableAnimations: true,
          ),
        );
        final opacity = tester.widget<Opacity>(
          find.descendant(
            of: find.byType(AnimatedVisibility),
            matching: find.byType(Opacity),
          ),
        );
        expect(opacity.opacity, closeTo(0.35, 0.001));
      },
    );

    testWidgets(
      'snaps to full opacity via Opacity when reduce-motion on and visible',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AnimatedVisibility(visible: true, child: Text('hello')),
            disableAnimations: true,
          ),
        );
        final opacity = tester.widget<Opacity>(
          find.descendant(
            of: find.byType(AnimatedVisibility),
            matching: find.byType(Opacity),
          ),
        );
        expect(opacity.opacity, closeTo(1.0, 0.001));
      },
    );

    testWidgets('accepts custom minOpacity', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedVisibility(
            visible: false,
            minOpacity: 0.1,
            child: Text('hello'),
          ),
          disableAnimations: true,
        ),
      );
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
          visible: true,
          minOpacity: 1.5,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
      expect(
        () => AnimatedVisibility(
          visible: true,
          minOpacity: -0.1,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('toggles opacity target on visible change', (tester) async {
      bool visible = true;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(
              AnimatedVisibility(visible: visible, child: const Text('hi')),
            );
          },
        ),
      );
      await tester.pump();
      expect(
        tester
            .widget<AnimatedOpacity>(
              find.descendant(
                of: find.byType(AnimatedVisibility),
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .opacity,
        closeTo(1.0, 0.001),
      );
      setState(() => visible = false);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<AnimatedOpacity>(
              find.descendant(
                of: find.byType(AnimatedVisibility),
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .opacity,
        closeTo(0.35, 0.001),
      );
      setState(() => visible = true);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<AnimatedOpacity>(
              find.descendant(
                of: find.byType(AnimatedVisibility),
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .opacity,
        closeTo(1.0, 0.001),
      );
    });

    testWidgets(
      'wraps in IgnorePointer when ignorePointerWhenHidden and not visible',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AnimatedVisibility(
              visible: false,
              ignorePointerWhenHidden: true,
              child: Text('hello'),
            ),
          ),
        );
        expect(
          find.descendant(
            of: find.byType(AnimatedVisibility),
            matching: find.byType(IgnorePointer),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('no IgnorePointer when visible is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedVisibility(
            visible: true,
            ignorePointerWhenHidden: true,
            child: Text('hello'),
          ),
        ),
      );
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
    testWidgets('applies Animate wrapper when animations enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const PulseAnimation(child: SizedBox(width: 20, height: 20))),
      );
      expect(
        find.descendant(
          of: find.byType(PulseAnimation),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 1000));
    });

    testWidgets('isolates repaints with a RepaintBoundary', (tester) async {
      await tester.pumpWidget(
        _wrap(const PulseAnimation(child: SizedBox(width: 20, height: 20))),
      );
      expect(
        find.descendant(
          of: find.byType(PulseAnimation),
          matching: find.byType(RepaintBoundary),
        ),
        findsWidgets,
      );
      await tester.pump(const Duration(milliseconds: 1000));
    });

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const PulseAnimation(child: Text('live')),
          disableAnimations: true,
        ),
      );
      expect(find.text('live'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(PulseAnimation),
          matching: find.byType(Animate),
        ),
        findsNothing,
      );
    });

    testWidgets('asserts when minScale and minOpacity are out of range', (
      tester,
    ) async {
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
      await tester.pumpWidget(
        _wrap(const ShakeAnimation(trigger: 0, child: Text('field'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('field'), findsOneWidget);
    });

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const ShakeAnimation(trigger: 0, child: Text('field')),
          disableAnimations: true,
        ),
      );
      expect(find.text('field'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ShakeAnimation),
          matching: find.byType(Animate),
        ),
        findsNothing,
      );
    });

    testWidgets('changing trigger replays animation', (tester) async {
      int trigger = 0;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(
              ShakeAnimation(trigger: trigger, child: const Text('field')),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      // Change trigger to fire a new shake.
      setState(() => trigger = 1);
      await tester.pump();
      // Animation is running — FadeTransition or Animate is active.
      expect(
        find.descendant(
          of: find.byType(ShakeAnimation),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
    });
  });

  group('BounceAnimation', () {
    testWidgets('applies Animate wrapper when animations enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const BounceAnimation(child: SizedBox(width: 20, height: 20))),
      );
      expect(
        find.descendant(
          of: find.byType(BounceAnimation),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 700));
    });

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const BounceAnimation(child: Text('hint')),
          disableAnimations: true,
        ),
      );
      expect(find.text('hint'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BounceAnimation),
          matching: find.byType(Animate),
        ),
        findsNothing,
      );
    });

    testWidgets('asserts when height is not positive', (tester) async {
      expect(
        () => BounceAnimation(height: 0.0, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => BounceAnimation(height: -2.0, child: const SizedBox()),
        throwsAssertionError,
      );
    });

    testWidgets('isolates repaints with a RepaintBoundary', (tester) async {
      await tester.pumpWidget(
        _wrap(const BounceAnimation(child: SizedBox(width: 20, height: 20))),
      );
      expect(
        find.descendant(
          of: find.byType(BounceAnimation),
          matching: find.byType(RepaintBoundary),
        ),
        findsWidgets,
      );
      await tester.pump(const Duration(milliseconds: 700));
    });
  });

  group('AnimatedSurface', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedSurface(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('hello'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('uses Duration.zero when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedSurface(
            decoration: BoxDecoration(color: Colors.red),
            child: SizedBox(),
          ),
          disableAnimations: true,
        ),
      );
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(container.duration, Duration.zero);
    });

    testWidgets('uses provided duration when animations enabled', (
      tester,
    ) async {
      const dur = Duration(milliseconds: 250);
      await tester.pumpWidget(
        _wrap(
          const AnimatedSurface(
            decoration: BoxDecoration(color: Colors.red),
            duration: dur,
            child: SizedBox(),
          ),
        ),
      );
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(container.duration, dur);
    });

    testWidgets('decoration color transitions mid-tween', (tester) async {
      bool selected = false;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(
              AnimatedSurface(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selected ? Colors.blue : Colors.red,
                ),
                child: const SizedBox(width: 100, height: 100),
              ),
            );
          },
        ),
      );
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
      await tester.pumpWidget(
        _wrap(
          AnimatedSurface(
            decoration: ShapeDecoration(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const SizedBox(width: 80, height: 80),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedSurface), findsOneWidget);
    });
  });

  group('CountUpText', () {
    testWidgets('shows final value when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(const CountUpText(value: 42), disableAnimations: true),
      );
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('counts up to value over duration', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CountUpText(value: 100, duration: Duration(milliseconds: 400)),
        ),
      );
      // Mid-animation — should show a partial value.
      await tester.pump(const Duration(milliseconds: 200));
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byType(CountUpText),
          matching: find.byType(Text),
        ),
      );
      final displayed = int.parse(text.data!);
      expect(displayed, greaterThan(0));
      expect(displayed, lessThan(100));
      await tester.pumpAndSettle();
    });

    testWidgets('shows full value after animation completes', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CountUpText(value: 99, duration: Duration(milliseconds: 200)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('custom formatter is applied', (tester) async {
      await tester.pumpWidget(
        _wrap(
          CountUpText(value: 5, formatter: (v) => '\$${v.toInt()}'),
          disableAnimations: true,
        ),
      );
      expect(find.text('\$5'), findsOneWidget);
    });

    testWidgets('reruns animation when value changes', (tester) async {
      double val = 10;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(CountUpText(value: val));
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('10'), findsOneWidget);
      setState(() => val = 50);
      await tester.pumpAndSettle();
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('no ticker runs when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(const CountUpText(value: 42), disableAnimations: true),
      );
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('value change under reduce-motion snaps without animating', (
      tester,
    ) async {
      double val = 10;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(CountUpText(value: val), disableAnimations: true);
          },
        ),
      );
      expect(find.text('10'), findsOneWidget);
      setState(() => val = 50);
      await tester.pump();
      expect(find.text('50'), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('semantics announce the target value during animation', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const CountUpText(value: 100, duration: Duration(milliseconds: 400)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200)); // halfway
      final semantics = tester.getSemantics(
        find.descendant(
          of: find.byType(CountUpText),
          matching: find.byType(Text),
        ),
      );
      expect(semantics.label, '100');
      await tester.pumpAndSettle();
      handle.dispose();
    });
  });

  group('TypewriterText', () {
    testWidgets('shows full text when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(const TypewriterText(text: 'hello'), disableAnimations: true),
      );
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('starts with partial text during animation', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TypewriterText(
            text: 'hello world',
            duration: Duration(milliseconds: 600),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300)); // halfway
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byType(TypewriterText),
          matching: find.byType(Text),
        ),
      );
      // Should have some characters but not all 11.
      expect(text.data!.length, greaterThan(0));
      expect(text.data!.length, lessThan(11));
      await tester.pumpAndSettle();
    });

    testWidgets('shows full text after animation completes', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TypewriterText(
            text: 'hi',
            duration: Duration(milliseconds: 200),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('restarts when text changes', (tester) async {
      String txt = 'abc';
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(
              TypewriterText(
                text: txt,
                duration: const Duration(milliseconds: 200),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('abc'), findsOneWidget);
      setState(() => txt = 'xyz');
      await tester.pumpAndSettle();
      expect(find.text('xyz'), findsOneWidget);
    });

    testWidgets('delay defers start', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TypewriterText(
            text: 'hi',
            duration: Duration(milliseconds: 300),
            delay: Duration(milliseconds: 200),
          ),
        ),
      );
      // During delay window — text should still be empty.
      await tester.pump(const Duration(milliseconds: 100));
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byType(TypewriterText),
          matching: find.byType(Text),
        ),
      );
      expect(text.data, isEmpty);
      await tester.pumpAndSettle();
    });

    testWidgets('never splits grapheme clusters (emoji-safe)', (tester) async {
      // Each of these is a single grapheme built from multiple code units.
      const emojiText = '👍🏽🎉👨‍👩‍👧';
      final graphemes = emojiText.characters.toList();
      await tester.pumpWidget(
        _wrap(
          const TypewriterText(
            text: emojiText,
            duration: Duration(milliseconds: 300),
          ),
        ),
      );
      // Sample several points mid-animation; every partial string must be a
      // whole-grapheme prefix, never a broken surrogate half.
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        final text = tester.widget<Text>(
          find.descendant(
            of: find.byType(TypewriterText),
            matching: find.byType(Text),
          ),
        );
        final shown = text.data!;
        final validPrefixes = [
          for (int n = 0; n <= graphemes.length; n++) graphemes.take(n).join(),
        ];
        expect(validPrefixes, contains(shown));
      }
      await tester.pumpAndSettle();
      expect(find.text(emojiText), findsOneWidget);
    });

    testWidgets('no ticker runs when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(const TypewriterText(text: 'hello'), disableAnimations: true),
      );
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('semantics announce the full text during animation', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const TypewriterText(
            text: 'hello world',
            duration: Duration(milliseconds: 600),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300)); // halfway
      final semantics = tester.getSemantics(
        find.descendant(
          of: find.byType(TypewriterText),
          matching: find.byType(Text),
        ),
      );
      expect(semantics.label, 'hello world');
      await tester.pumpAndSettle();
      handle.dispose();
    });
  });

  group('SkeletonBox', () {
    // Fix 5: verify the Animate wrapper is present, not just that the child
    // exists (which would pass even if SkeletonBox returned child directly).
    testWidgets('applies shimmer animation when animations enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const SkeletonBox(child: SizedBox(width: 100, height: 16))),
      );
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

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SkeletonBox(child: Text('loading')),
          disableAnimations: true,
        ),
      );
      expect(find.text('loading'), findsOneWidget);
      expect(find.byType(Animate), findsNothing);
    });

    testWidgets('custom color and duration smoke test', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SkeletonBox(
            color: Colors.white,
            duration: Duration(milliseconds: 800),
            child: SizedBox(width: 100, height: 16),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 900));
      expect(
        find.descendant(
          of: find.byType(SkeletonBox),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
    });

    testWidgets('isolates repaints with a RepaintBoundary', (tester) async {
      await tester.pumpWidget(
        _wrap(const SkeletonBox(child: SizedBox(width: 100, height: 16))),
      );
      expect(
        find.descendant(
          of: find.byType(SkeletonBox),
          matching: find.byType(RepaintBoundary),
        ),
        findsWidgets,
      );
      await tester.pump(const Duration(milliseconds: 1600));
    });
  });

  group('AnimatedProgressRing', () {
    testWidgets('renders two CircularProgressIndicators (track + arc)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AnimatedProgressRing(value: 0.5), disableAnimations: true),
      );
      expect(
        find.descendant(
          of: find.byType(AnimatedProgressRing),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('shows target value immediately when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AnimatedProgressRing(value: 0.7), disableAnimations: true),
      );
      final arc = tester
          .widgetList<CircularProgressIndicator>(
            find.descendant(
              of: find.byType(AnimatedProgressRing),
              matching: find.byType(CircularProgressIndicator),
            ),
          )
          .last;
      expect(arc.value, closeTo(0.7, 0.001));
    });

    testWidgets('animates from 0 to value over duration', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedProgressRing(
            value: 1.0,
            duration: Duration(milliseconds: 400),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      final arc = tester
          .widgetList<CircularProgressIndicator>(
            find.descendant(
              of: find.byType(AnimatedProgressRing),
              matching: find.byType(CircularProgressIndicator),
            ),
          )
          .last;
      expect(arc.value, greaterThan(0.0));
      expect(arc.value, lessThan(1.0));
      await tester.pumpAndSettle();
    });

    testWidgets('renders optional child centered inside the ring', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedProgressRing(value: 0.4, child: Text('40%')),
          disableAnimations: true,
        ),
      );
      expect(find.text('40%'), findsOneWidget);
    });

    testWidgets('asserts when value is out of range', (tester) async {
      expect(() => AnimatedProgressRing(value: -0.1), throwsAssertionError);
      expect(() => AnimatedProgressRing(value: 1.1), throwsAssertionError);
    });

    testWidgets('no ticker runs when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(const AnimatedProgressRing(value: 0.5), disableAnimations: true),
      );
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('semantics expose a single progress value', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const AnimatedProgressRing(
            value: 0.7,
            semanticsLabel: 'Upload progress',
          ),
          disableAnimations: true,
        ),
      );
      final semantics = tester.getSemantics(
        find.bySemanticsLabel('Upload progress'),
      );
      expect(semantics.value, '70%');
      // The two stacked CircularProgressIndicators must not leak their own
      // "100%" / per-frame announcements.
      expect(find.bySemanticsLabel(RegExp('100%')), findsNothing);
      handle.dispose();
    });
  });

  group('AnimatedCheckmark', () {
    testWidgets('renders a CustomPaint', (tester) async {
      await tester.pumpWidget(_wrap(const AnimatedCheckmark(checked: true)));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(AnimatedCheckmark),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('toggling checked animates the stroke', (tester) async {
      bool checked = false;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(AnimatedCheckmark(checked: checked));
          },
        ),
      );
      await tester.pumpAndSettle();
      setState(() => checked = true);
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets('snaps and runs no ticker when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AnimatedCheckmark(checked: true), disableAnimations: true),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('asserts on invalid configuration', (tester) async {
      expect(
        () => AnimatedCheckmark(checked: true, size: 0.0),
        throwsAssertionError,
      );
      expect(
        () => AnimatedCheckmark(checked: true, strokeWidth: 0.0),
        throwsAssertionError,
      );
    });
  });

  group('RollingCounter', () {
    testWidgets('renders the current value', (tester) async {
      await tester.pumpWidget(_wrap(const RollingCounter(value: 42)));
      await tester.pumpAndSettle();
      expect(find.text('4'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('rolls to a new value', (tester) async {
      int value = 9;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(RollingCounter(value: value));
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('9'), findsOneWidget);
      setState(() => value = 10);
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('9'), findsNothing);
    });

    testWidgets('shows plain text when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(const RollingCounter(value: 123), disableAnimations: true),
      );
      expect(find.text('123'), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('custom formatter is applied', (tester) async {
      await tester.pumpWidget(
        _wrap(
          RollingCounter(value: 1234, formatter: (v) => '1,234'),
          disableAnimations: true,
        ),
      );
      expect(find.text('1,234'), findsOneWidget);
    });

    testWidgets('semantics announce the whole number', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_wrap(const RollingCounter(value: 42)));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('42'), findsOneWidget);
      handle.dispose();
    });
  });

  group('Marquee', () {
    testWidgets('renders static text when it fits', (tester) async {
      await tester.pumpWidget(
        _wrap(const SizedBox(width: 400, child: Marquee(text: 'short'))),
      );
      await tester.pump();
      expect(find.text('short'), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('scrolls with two copies when text overflows', (tester) async {
      const longText = 'An extremely long track title that cannot possibly fit';
      await tester.pumpWidget(
        _wrap(const SizedBox(width: 100, child: Marquee(text: longText))),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
      // Seamless loop renders the text twice.
      expect(find.text(longText), findsNWidgets(2));
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('static ellipsized text when reduce-motion enabled', (
      tester,
    ) async {
      const longText = 'An extremely long track title that cannot possibly fit';
      await tester.pumpWidget(
        _wrap(
          const SizedBox(width: 100, child: Marquee(text: longText)),
          disableAnimations: true,
        ),
      );
      await tester.pump();
      expect(find.text(longText), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('semantics announce the full text when scrolling', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      const longText = 'An extremely long track title that cannot possibly fit';
      await tester.pumpWidget(
        _wrap(const SizedBox(width: 100, child: Marquee(text: longText))),
      );
      await tester.pump();
      expect(find.bySemanticsLabel(longText), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      handle.dispose();
    });

    testWidgets('asserts on invalid configuration', (tester) async {
      expect(() => Marquee(text: 'x', velocity: 0.0), throwsAssertionError);
      expect(() => Marquee(text: 'x', gap: 0.0), throwsAssertionError);
    });
  });

  group('BlurEntrance', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(const BlurEntrance(child: Text('hi'))));
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const BlurEntrance(child: Text('hi')), disableAnimations: true),
      );
      expect(find.text('hi'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BlurEntrance),
          matching: find.byType(Animate),
        ),
        findsNothing,
      );
    });

    testWidgets('applies fade and blur effects via Animate wrapper', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const BlurEntrance(child: Text('hi'))));
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(BlurEntrance),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
    });

    testWidgets('asserts when initialSigma is not positive', (tester) async {
      expect(
        () => BlurEntrance(initialSigma: 0.0, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('FlipEntrance', () {
    testWidgets('renders child for both axes', (tester) async {
      await tester.pumpWidget(_wrap(const FlipEntrance(child: Text('h'))));
      await tester.pumpAndSettle();
      expect(find.text('h'), findsOneWidget);

      await tester.pumpWidget(
        _wrap(const FlipEntrance(axis: FlipAxis.vertical, child: Text('v'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('v'), findsOneWidget);
    });

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const FlipEntrance(child: Text('hi')), disableAnimations: true),
      );
      expect(find.text('hi'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FlipEntrance),
          matching: find.byType(Animate),
        ),
        findsNothing,
      );
    });

    testWidgets('asserts when initialTilt is out of range', (tester) async {
      expect(
        () => FlipEntrance(initialTilt: -1.1, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => FlipEntrance(initialTilt: 1.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('FlipCard', () {
    testWidgets('shows front when showFront is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const FlipCard(
            showFront: true,
            front: Text('front'),
            back: Text('back'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('front'), findsOneWidget);
      expect(find.text('back'), findsNothing);
    });

    testWidgets('flips to back when showFront changes', (tester) async {
      bool showFront = true;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(
              FlipCard(
                showFront: showFront,
                front: const Text('front'),
                back: const Text('back'),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      setState(() => showFront = false);
      await tester.pumpAndSettle();
      expect(find.text('back'), findsOneWidget);
      expect(find.text('front'), findsNothing);
    });

    testWidgets('front stays visible through the first half of the flip', (
      tester,
    ) async {
      bool showFront = true;
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(
              FlipCard(
                showFront: showFront,
                duration: const Duration(milliseconds: 400),
                front: const Text('front'),
                back: const Text('back'),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      setState(() => showFront = false);
      // Early in the flip the front face should still be showing.
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('front'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('back'), findsOneWidget);
    });

    testWidgets('swaps instantly when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const FlipCard(
            showFront: false,
            front: Text('front'),
            back: Text('back'),
          ),
          disableAnimations: true,
        ),
      );
      expect(find.text('back'), findsOneWidget);
      expect(find.text('front'), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('AnimatedBlur', () {
    testWidgets('renders child unfiltered when not blurred', (tester) async {
      await tester.pumpWidget(
        _wrap(const AnimatedBlur(blurred: false, child: Text('hi'))),
      );
      await tester.pumpAndSettle();
      expect(find.text('hi'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AnimatedBlur),
          matching: find.byType(ImageFiltered),
        ),
        findsNothing,
      );
    });

    testWidgets('applies ImageFiltered when blurred', (tester) async {
      await tester.pumpWidget(
        _wrap(const AnimatedBlur(blurred: true, child: Text('hi'))),
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(AnimatedBlur),
          matching: find.byType(ImageFiltered),
        ),
        findsOneWidget,
      );
    });

    testWidgets('snaps when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedBlur(blurred: true, child: Text('hi')),
          disableAnimations: true,
        ),
      );
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(AnimatedBlur),
          matching: find.byType(ImageFiltered),
        ),
        findsOneWidget,
      );
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('asserts when sigma is not positive', (tester) async {
      expect(
        () => AnimatedBlur(blurred: true, sigma: 0.0, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('FadeSwitcher', () {
    testWidgets('cross-fades between keyed children', (tester) async {
      Widget current = const Text('one', key: ValueKey('one'));
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(FadeSwitcher(child: current));
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('one'), findsOneWidget);
      setState(() => current = const Text('two', key: ValueKey('two')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      // Mid-transition both children are in the tree.
      expect(find.text('one'), findsOneWidget);
      expect(find.text('two'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('one'), findsNothing);
      expect(find.text('two'), findsOneWidget);
    });

    testWidgets('swaps instantly when reduce-motion enabled', (tester) async {
      Widget current = const Text('one', key: ValueKey('one'));
      late StateSetter setState;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _wrap(FadeSwitcher(child: current), disableAnimations: true);
          },
        ),
      );
      setState(() => current = const Text('two', key: ValueKey('two')));
      await tester.pump();
      expect(find.text('two'), findsOneWidget);
      expect(find.text('one'), findsNothing);
    });

    testWidgets('asserts when initialScale is out of range', (tester) async {
      expect(
        () => FadeSwitcher(initialScale: 0.0, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => FadeSwitcher(initialScale: 1.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('SpinAnimation', () {
    testWidgets('applies Animate wrapper and RepaintBoundary', (tester) async {
      await tester.pumpWidget(
        _wrap(const SpinAnimation(child: Icon(Icons.sync))),
      );
      expect(
        find.descendant(
          of: find.byType(SpinAnimation),
          matching: find.byType(Animate),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(SpinAnimation),
          matching: find.byType(RepaintBoundary),
        ),
        findsWidgets,
      );
      await tester.pump(const Duration(milliseconds: 1300));
    });

    testWidgets('returns child directly when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SpinAnimation(child: Text('spin')),
          disableAnimations: true,
        ),
      );
      expect(find.text('spin'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SpinAnimation),
          matching: find.byType(Animate),
        ),
        findsNothing,
      );
    });
  });

  group('LoadingDots', () {
    testWidgets('renders the configured number of dots', (tester) async {
      await tester.pumpWidget(_wrap(const LoadingDots(dotCount: 4)));
      await tester.pump(const Duration(milliseconds: 100));
      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(LoadingDots),
          matching: find.byType(Row),
        ),
      );
      // 4 dots + 3 spacers.
      expect(row.children.length, 7);
      await tester.pump(const Duration(milliseconds: 900));
    });

    testWidgets('no ticker runs when reduce-motion enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoadingDots(), disableAnimations: true),
      );
      expect(tester.hasRunningAnimations, isFalse);
      // Static dots still render.
      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(LoadingDots),
          matching: find.byType(Row),
        ),
      );
      expect(row.children.length, 5); // 3 dots + 2 spacers
    });

    testWidgets('asserts on invalid configuration', (tester) async {
      expect(() => LoadingDots(dotCount: 0), throwsAssertionError);
      expect(() => LoadingDots(dotSize: 0.0), throwsAssertionError);
      expect(() => LoadingDots(spacing: -1.0), throwsAssertionError);
    });
  });

  group('TapScale', () {
    testWidgets('invokes onTap', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _wrap(TapScale(onTap: () => taps++, child: const Text('tap'))),
      );
      await tester.tap(find.text('tap'));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('scales down while pressed and back up on release', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(TapScale(onTap: () {}, child: const Text('tap'))),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('tap')),
      );
      await tester.pumpAndSettle();
      var scale = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(TapScale),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(scale.scale, closeTo(0.95, 0.001));
      await gesture.up();
      await tester.pumpAndSettle();
      scale = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(TapScale),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(scale.scale, closeTo(1.0, 0.001));
    });

    testWidgets('uses Duration.zero when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          TapScale(onTap: () {}, child: const Text('tap')),
          disableAnimations: true,
        ),
      );
      final scale = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(TapScale),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(scale.duration, Duration.zero);
    });

    testWidgets('asserts when pressedScale is out of range', (tester) async {
      expect(
        () => TapScale(pressedScale: 0.0, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => TapScale(pressedScale: 1.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });
  });

  group('AnimatedProgressBar', () {
    testWidgets('fill fraction reaches target after animation', (tester) async {
      await tester.pumpWidget(_wrap(const AnimatedProgressBar(value: 0.6)));
      await tester.pumpAndSettle();
      final fill = tester.widget<FractionallySizedBox>(
        find.descendant(
          of: find.byType(AnimatedProgressBar),
          matching: find.byType(FractionallySizedBox),
        ),
      );
      expect(fill.widthFactor, closeTo(0.6, 0.001));
    });

    testWidgets('animates from 0 to value over duration', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedProgressBar(
            value: 1.0,
            duration: Duration(milliseconds: 400),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      final fill = tester.widget<FractionallySizedBox>(
        find.descendant(
          of: find.byType(AnimatedProgressBar),
          matching: find.byType(FractionallySizedBox),
        ),
      );
      expect(fill.widthFactor, greaterThan(0.0));
      expect(fill.widthFactor, lessThan(1.0));
      await tester.pumpAndSettle();
    });

    testWidgets('snaps and runs no ticker when reduce-motion enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AnimatedProgressBar(value: 0.4), disableAnimations: true),
      );
      final fill = tester.widget<FractionallySizedBox>(
        find.descendant(
          of: find.byType(AnimatedProgressBar),
          matching: find.byType(FractionallySizedBox),
        ),
      );
      expect(fill.widthFactor, closeTo(0.4, 0.001));
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('semantics expose a single progress value', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const AnimatedProgressBar(
            value: 0.3,
            semanticsLabel: 'Download progress',
          ),
          disableAnimations: true,
        ),
      );
      final semantics = tester.getSemantics(
        find.bySemanticsLabel('Download progress'),
      );
      expect(semantics.value, '30%');
      handle.dispose();
    });

    testWidgets('asserts when value is out of range', (tester) async {
      expect(() => AnimatedProgressBar(value: -0.1), throwsAssertionError);
      expect(() => AnimatedProgressBar(value: 1.1), throwsAssertionError);
    });
  });
}
