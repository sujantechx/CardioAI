import 'package:flutter/material.dart';

class AnimatedHeart extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const AnimatedHeart({
    super.key,
    this.size = 80,
    this.color = const Color(0xFFE53935),
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _HeartPainter(color: widget.color),
          ),
        );
      },
    );
  }
}

class _HeartPainter extends CustomPainter {
  final Color color;

  _HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w / 2, h * 0.35);
    path.cubicTo(w * 0.15, h * 0.0, -w * 0.05, h * 0.5, w / 2, h * 0.95);
    path.moveTo(w / 2, h * 0.35);
    path.cubicTo(w * 0.85, h * 0.0, w * 1.05, h * 0.5, w / 2, h * 0.95);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);

    // Add ECG line across the heart
    final ecgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final ecgPath = Path();
    ecgPath.moveTo(w * 0.15, h * 0.5);
    ecgPath.lineTo(w * 0.3, h * 0.5);
    ecgPath.lineTo(w * 0.35, h * 0.35);
    ecgPath.lineTo(w * 0.4, h * 0.6);
    ecgPath.lineTo(w * 0.5, h * 0.25);
    ecgPath.lineTo(w * 0.58, h * 0.65);
    ecgPath.lineTo(w * 0.63, h * 0.45);
    ecgPath.lineTo(w * 0.7, h * 0.5);
    ecgPath.lineTo(w * 0.85, h * 0.5);

    canvas.drawPath(ecgPath, ecgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
