import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'audio_service.dart';

class GamePalette {
  static const forest = Color(0xFF18331D);
  static const forestLight = Color(0xFF315A27);
  static const leaf = Color(0xFF72BE35);
  static const lime = Color(0xFF74D92B);
  static const sky = Color(0xFF70C8EE);
  static const ocean = Color(0xFF159ED3);
  static const sand = Color(0xFFEAC779);
  static const cream = Color(0xFFFFF0C6);
  static const wood = Color(0xFF8A4E2D);
  static const orange = Color(0xFFF29A34);
  static const pink = Color(0xFFE45F8B);
  static const ink = Color(0xFF70452D);
}

enum ButtonKind { wood, green, blue, red }

class GameBackdrop extends StatelessWidget {
  const GameBackdrop({super.key, required this.asset, required this.child, this.dark = false, this.reduceMotion = false});
  final String asset;
  final Widget child;
  final bool dark;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final width = math.min(constraints.maxWidth, 520.0);
        return Center(
          child: SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(asset, fit: BoxFit.cover),
              if (dark) ColoredBox(color: GamePalette.forest.withValues(alpha: .22)),
              if (!reduceMotion) const Positioned.fill(child: FallingLeaves()),
              child,
            ]),
          ),
        );
      });
}

class FallingLeaves extends StatefulWidget {
  const FallingLeaves({super.key});
  @override
  State<FallingLeaves> createState() => _FallingLeavesState();
}

class _FallingLeavesState extends State<FallingLeaves> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 19))..repeat();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => IgnorePointer(child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => LayoutBuilder(builder: (context, c) {
          final t = _controller.value;
          return Stack(children: List.generate(4, (i) {
            final phase = (t + i * .27) % 1;
            final left = c.maxWidth * (.08 + ((i * 29) % 83) / 100) + math.sin(phase * math.pi * 2 + i) * 22;
            return Positioned(
              left: left.clamp(0, math.max(0, c.maxWidth - 24)).toDouble(),
              top: c.maxHeight * phase - 18,
              child: Transform.rotate(
                angle: phase * math.pi * 3 + i,
                child: Opacity(opacity: .35 + math.sin(phase * math.pi) * .35, child: Image.asset('assets/ui/falling-leaf.png', width: 20 + (i % 2) * 7, height: 25 + (i % 2) * 8, fit: BoxFit.contain)),
              ),
            );
          }));
        }),
      ));
}

class GameButton extends StatefulWidget {
  const GameButton({super.key, required this.label, required this.onPressed, required this.audio, this.kind = ButtonKind.green, this.height = 58, this.icon, this.enabled = true, this.textSize = 18});
  final String label;
  final VoidCallback? onPressed;
  final GameAudio audio;
  final ButtonKind kind;
  final double height;
  final IconData? icon;
  final bool enabled;
  final double textSize;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final image = switch (widget.kind) {
      ButtonKind.wood => 'assets/ui/menu-plank.png',
      ButtonKind.green => 'assets/ui/button-green-v2.png',
      ButtonKind.blue => 'assets/ui/button-blue-v2.png',
      ButtonKind.red => null,
    };
    final background = widget.kind == ButtonKind.red
        ? const LinearGradient(colors: [Color(0xFFFF6660), Color(0xFFD71928), Color(0xFFAB1019)], begin: Alignment.topLeft, end: Alignment.bottomRight)
        : null;
    return Semantics(
      button: true,
      enabled: widget.enabled && widget.onPressed != null,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
        onTap: widget.enabled && widget.onPressed != null ? () { widget.audio.click(); widget.onPressed!(); } : null,
        child: AnimatedScale(
          scale: _pressed ? .965 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutBack,
          child: Opacity(
            opacity: widget.enabled ? 1 : .52,
            child: SizedBox(
              height: widget.height,
              width: double.infinity,
              child: Stack(alignment: Alignment.center, children: [
                if (image != null) Positioned.fill(child: Image.asset(image, fit: BoxFit.fill)),
                if (background != null) Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: background, border: Border.all(color: const Color(0xFF812D20), width: 3), borderRadius: BorderRadius.circular(widget.height / 2), boxShadow: const [BoxShadow(color: Color(0x773D281C), blurRadius: 3, offset: Offset(0, 3))]))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (widget.icon != null) ...[Icon(widget.icon, color: Colors.white, size: widget.textSize + 2), const SizedBox(width: 7)],
                    Flexible(child: Text(widget.label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: widget.textSize, height: 1.05, fontWeight: FontWeight.w900, color: const Color(0xFFFFF5D7), shadows: const [Shadow(color: Color(0xFF703919), blurRadius: 2, offset: Offset(0, 2))]))),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class GamePanel extends StatelessWidget {
  const GamePanel({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.color = GamePalette.cream, this.borderColor = GamePalette.wood, this.radius = 24});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final double radius;
  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(color: color.withValues(alpha: .96), borderRadius: BorderRadius.circular(radius), border: Border.all(color: borderColor, width: 3), boxShadow: const [BoxShadow(color: Color(0x6639200E), blurRadius: 9, offset: Offset(0, 5)), BoxShadow(color: Color(0xFFFFEBC2), blurRadius: 0, spreadRadius: 1)]),
        child: child,
      );
}

class WoodTitle extends StatelessWidget {
  const WoodTitle({super.key, required this.title, this.height = 58});
  final String title;
  final double height;
  @override
  Widget build(BuildContext context) => SizedBox(height: height, width: double.infinity, child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(child: Image.asset('assets/ui/menu-plank.png', fit: BoxFit.fill)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 26), child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFFF0C6), fontWeight: FontWeight.w900, fontSize: 23, shadows: [Shadow(color: Color(0xFF62341C), blurRadius: 2, offset: Offset(0, 2))]))),
      ]));
}

class GamePageHeader extends StatelessWidget {
  const GamePageHeader({super.key, required this.title, required this.onBack, required this.audio, this.backLabel = 'Voltar', this.showLogo = true});
  final String title;
  final VoidCallback onBack;
  final GameAudio audio;
  final String backLabel;
  final bool showLogo;
  @override
  Widget build(BuildContext context) => Column(children: [
        Row(children: [
          SizedBox(width: 88, height: 46, child: TextButton.icon(onPressed: () { audio.click(); onBack(); }, icon: const Icon(Icons.chevron_left, size: 21), label: Text(backLabel, overflow: TextOverflow.ellipsis), style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xFF148BC0), side: const BorderSide(color: Color(0xFF0C5883), width: 2), shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 7), textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)))),
          Expanded(child: Center(child: showLogo ? Image.asset('assets/brand/enviroment-all-logo.png', height: 62, fit: BoxFit.contain) : const SizedBox(height: 62))),
          const SizedBox(width: 88),
        ]),
        const SizedBox(height: 5),
        WoodTitle(title: title),
      ]);
}

class SpriteCell extends StatelessWidget {
  const SpriteCell({super.key, required this.asset, required this.index, this.borderRadius = 12});
  final String asset;
  final int index;
  final double borderRadius;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: AspectRatio(aspectRatio: 1, child: LayoutBuilder(builder: (context, c) {
          final width = c.maxWidth;
          final height = c.maxHeight;
          return Stack(children: [Positioned(left: -(index % 3) * width, top: -(index ~/ 3) * height, width: width * 3, height: height * 2, child: Image.asset(asset, fit: BoxFit.fill))]);
        })),
      );
}

class CurrencyPill extends StatelessWidget {
  const CurrencyPill({super.key, required this.coins, required this.crystals});
  final int coins;
  final int crystals;
  @override
  Widget build(BuildContext context) => Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
        _currency('🪙', coins, 'ouro'),
        _currency('💎', crystals, 'gemas'),
      ]);
  Widget _currency(String icon, int amount, String label) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFFAE4A4), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFBE762C), width: 2)), child: Text('$icon $amount $label', style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900)));
}

class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero, this.reduceMotion = false});
  final Widget child;
  final Duration delay;
  final bool reduceMotion;
  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 540));
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween(begin: const Offset(0, .12), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  @override
  void initState() { super.initState(); if (widget.reduceMotion) { _controller.value = 1; } else { Future<void>.delayed(widget.delay, () { if (mounted) _controller.forward(); }); } }
  @override
  void didUpdateWidget(covariant Reveal oldWidget) { super.didUpdateWidget(oldWidget); if (widget.reduceMotion) _controller.value = 1; }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: widget.child));
}

class FloatingGameCard extends StatefulWidget {
  const FloatingGameCard({super.key, required this.child, this.enabled = true});
  final Widget child;
  final bool enabled;
  @override
  State<FloatingGameCard> createState() => _FloatingGameCardState();
}

class _FloatingGameCardState extends State<FloatingGameCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat(reverse: true);
  @override
  void didUpdateWidget(covariant FloatingGameCard oldWidget) { super.didUpdateWidget(oldWidget); if (widget.enabled) { _controller.repeat(reverse: true); } else { _controller.stop(); } }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: _controller, builder: (context, _) => Transform.translate(offset: Offset(0, widget.enabled ? math.sin(_controller.value * math.pi) * -3 : 0), child: widget.child));
}

class FeedbackBanner extends StatelessWidget {
  const FeedbackBanner({super.key, required this.text, this.error = false});
  final String text;
  final bool error;
  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final color = error ? const Color(0xFFFFE2D9) : const Color(0xFFE4F6CD);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Container(
        key: ValueKey(text),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: error ? const Color(0xFFC7553A) : const Color(0xFF6DAA38),
            width: 2,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: GamePalette.ink,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

class LeafConfetti extends StatefulWidget {
  const LeafConfetti({super.key});
  @override
  State<LeafConfetti> createState() => _LeafConfettiState();
}

class _LeafConfettiState extends State<LeafConfetti> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => IgnorePointer(child: AnimatedBuilder(animation: _controller, builder: (context, _) => CustomPaint(painter: _ConfettiPainter(_controller.value), size: Size.infinite)));
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [const Color(0xFFFFD52F), const Color(0xFFFF5C63), const Color(0xFF5DD8EE), const Color(0xFF8BDB42), const Color(0xFFFC9A36)];
    for (var i = 0; i < 34; i++) {
      final seed = i * 27.31;
      final x = (math.sin(seed) * .5 + .5) * size.width;
      final phase = (progress + (i * .163)) % 1;
      final y = phase * size.height;
      final paint = Paint()..color = colors[i % colors.length].withValues(alpha: phase < .1 || phase > .91 ? .45 : .9);
      canvas.save();
      canvas.translate(x + math.sin(phase * math.pi * 4 + seed) * 15, y);
      canvas.rotate(phase * 8 + seed);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 6 + i % 4, height: 3 + i % 3), const Radius.circular(2)), paint);
      canvas.restore();
    }
  }
  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
