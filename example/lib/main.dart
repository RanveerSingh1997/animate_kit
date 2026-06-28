import 'package:animate_kit/animate_kit.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'animate_kit demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool _visible = true;
  bool _selected = false;
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('animate_kit')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _sectionLabel('FadeEntrance'),
          FadeEntrance(
            delay: const Duration(milliseconds: 200),
            child: _card(cs.primaryContainer, 'Fades in on first mount'),
          ),
          const SizedBox(height: 8),
          FadeEntrance(
            delay: const Duration(milliseconds: 300),
            direction: FadeSlideDirection.left,
            child: _card(cs.secondaryContainer, 'Slides in from right'),
          ),
          const SizedBox(height: 8),
          FadeEntrance(
            delay: const Duration(milliseconds: 400),
            direction: FadeSlideDirection.none,
            child: _card(cs.tertiaryContainer, 'Fade only — no slide'),
          ),
          const SizedBox(height: 32),

          _sectionLabel('AnimatedVisibility'),
          Row(
            children: [
              Switch(
                value: _visible,
                onChanged: (v) => setState(() => _visible = v),
              ),
              const SizedBox(width: 12),
              AnimatedVisibility(
                visible: _visible,
                minOpacity: 0.15,
                ignorePointerWhenHidden: true,
                child: _card(cs.secondary, 'Toggle me', textColor: cs.onSecondary),
              ),
            ],
          ),
          const SizedBox(height: 32),

          _sectionLabel('AnimatedSurface'),
          GestureDetector(
            onTap: () => setState(() => _selected = !_selected),
            child: AnimatedSurface(
              decoration: BoxDecoration(
                color: _selected ? cs.primaryContainer : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selected ? cs.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Tap to ${_selected ? 'deselect' : 'select'}',
                  style: TextStyle(
                    color: _selected ? cs.onPrimaryContainer : cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          _sectionLabel('SkeletonBox'),
          Row(
            children: [
              Switch(
                value: _loaded,
                onChanged: (v) => setState(() => _loaded = v),
              ),
              const SizedBox(width: 8),
              const Text('Simulate loaded'),
            ],
          ),
          const SizedBox(height: 8),
          if (_loaded)
            _card(cs.surfaceContainerHighest, 'Content loaded')
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SkeletonBox(
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    width: 200,
                    height: 16,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      );

  Widget _card(Color color, String label, {Color? textColor}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: TextStyle(color: textColor)),
      );
}
