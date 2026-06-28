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
  });
}
