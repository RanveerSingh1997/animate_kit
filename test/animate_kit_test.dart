import 'package:animate_kit/animate_kit.dart';
import 'package:flutter/material.dart';
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

    testWidgets('accepts custom delay and duration', (tester) async {
      await tester.pumpWidget(_wrap(
        const FadeEntrance(
          delay: Duration(milliseconds: 50),
          duration: Duration(milliseconds: 200),
          child: Text('hello'),
        ),
      ));
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
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, closeTo(0.35, 0.001));
    });

    testWidgets('snaps to full opacity via Opacity when reduce-motion on and visible',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AnimatedVisibility(visible: true, child: Text('hello')),
        disableAnimations: true,
      ));
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
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
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, closeTo(0.1, 0.001));
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
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(
        const SkeletonBox(child: SizedBox(width: 100, height: 16)),
      ));
      // SkeletonBox repeats forever — advance past one shimmer cycle instead
      // of pumpAndSettle (which would never settle).
      await tester.pump(const Duration(milliseconds: 1600));
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('returns child directly when reduce-motion enabled',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const SkeletonBox(child: Text('loading')),
        disableAnimations: true,
      ));
      expect(find.text('loading'), findsOneWidget);
    });
  });
}
