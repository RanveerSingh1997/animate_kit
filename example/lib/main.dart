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
  bool _scaled = true;
  bool _slid = true;
  bool _loaded = false;
  double _score = 0;
  int _errorCount = 0;
  String _typed = 'animate_kit';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('animate_kit')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Entrance animations ────────────────────────────────────────
          _label('FadeEntrance + ScaleEntrance'),
          StaggeredList(
            children: [
              FadeEntrance(
                delay: const Duration(milliseconds: 0),
                child: _card(cs.primaryContainer, 'FadeEntrance — slides up'),
              ),
              ScaleEntrance(
                delay: const Duration(milliseconds: 120),
                child: _card(cs.secondaryContainer, 'ScaleEntrance — scales in'),
              ),
              FadeEntrance(
                delay: const Duration(milliseconds: 240),
                direction: FadeSlideDirection.left,
                child: _card(cs.tertiaryContainer, 'FadeEntrance — slides left'),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ── AnimatedVisibility ─────────────────────────────────────────
          _label('AnimatedVisibility'),
          Row(children: [
            Switch(value: _visible, onChanged: (v) => setState(() => _visible = v)),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedVisibility(
                visible: _visible,
                minOpacity: 0.15,
                ignorePointerWhenHidden: true,
                child: _card(cs.secondary, 'Toggle opacity',
                    textColor: cs.onSecondary),
              ),
            ),
          ]),
          const SizedBox(height: 28),

          // ── AnimatedSurface ────────────────────────────────────────────
          _label('AnimatedSurface'),
          GestureDetector(
            onTap: () => setState(() => _selected = !_selected),
            child: AnimatedSurface(
              decoration: BoxDecoration(
                color: _selected
                    ? cs.primaryContainer
                    : cs.surfaceContainerHighest,
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
                      color: _selected ? cs.onPrimaryContainer : cs.onSurface),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── ScaleToggle + SlideToggle ──────────────────────────────────
          _label('ScaleToggle + SlideToggle'),
          Row(children: [
            Expanded(
              child: Column(children: [
                Switch(
                    value: _scaled,
                    onChanged: (v) => setState(() => _scaled = v)),
                ScaleToggle(
                  scaled: _scaled,
                  minScale: 0.75,
                  child: _card(cs.primaryContainer, 'Scale'),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(children: [
                Switch(
                    value: _slid,
                    onChanged: (v) => setState(() => _slid = v)),
                SlideToggle(
                  visible: _slid,
                  hiddenOffset: const Offset(0, 0.4),
                  child: _card(cs.secondaryContainer, 'Slide'),
                ),
              ]),
            ),
          ]),
          const SizedBox(height: 28),

          // ── PulseAnimation ─────────────────────────────────────────────
          _label('PulseAnimation'),
          Row(children: [
            PulseAnimation(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: cs.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('Live indicator'),
          ]),
          const SizedBox(height: 28),

          // ── ShakeAnimation ─────────────────────────────────────────────
          _label('ShakeAnimation'),
          ShakeAnimation(
            trigger: _errorCount,
            child: FilledButton(
              onPressed: () => setState(() => _errorCount++),
              child: Text('Shake me ($_errorCount)'),
            ),
          ),
          const SizedBox(height: 28),

          // ── SkeletonBox ────────────────────────────────────────────────
          _label('SkeletonBox'),
          Row(children: [
            Switch(value: _loaded, onChanged: (v) => setState(() => _loaded = v)),
            const SizedBox(width: 8),
            const Text('Loaded'),
          ]),
          const SizedBox(height: 8),
          if (_loaded)
            _card(cs.surfaceContainerHighest, 'Content loaded')
          else
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                child: Container(
                  width: 180,
                  height: 16,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ]),
          const SizedBox(height: 28),

          // ── CountUpText ────────────────────────────────────────────────
          _label('CountUpText'),
          Row(children: [
            FilledButton.tonal(
              onPressed: () =>
                  setState(() => _score = (_score + 250).clamp(0, 9999)),
              child: const Text('+250'),
            ),
            const SizedBox(width: 16),
            CountUpText(
              value: _score,
              duration: const Duration(milliseconds: 600),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              formatter: (v) => v.toInt().toString(),
            ),
          ]),
          const SizedBox(height: 28),

          // ── TypewriterText ─────────────────────────────────────────────
          _label('TypewriterText'),
          DropdownButton<String>(
            value: _typed,
            items: const [
              DropdownMenuItem(value: 'animate_kit', child: Text('animate_kit')),
              DropdownMenuItem(
                  value: 'Flutter animations', child: Text('Flutter animations')),
              DropdownMenuItem(
                  value: 'Type by type...', child: Text('Type by type...')),
            ],
            onChanged: (v) => setState(() => _typed = v!),
          ),
          const SizedBox(height: 8),
          TypewriterText(
            text: _typed,
            duration: const Duration(milliseconds: 800),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: TextStyle(color: textColor)),
      );
}
