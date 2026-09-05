import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/activity_model.dart';

class SportsIcon extends StatelessWidget {
  final SportCategory category;
  final double size;

  const SportsIcon({
    super.key,
    required this.category,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: CustomPaint(
        size: Size(size * 0.58, size * 0.58),
        painter: _SportIconPainter(category: category, color: AppColors.primary),
      ),
    );
  }
}

class _SportIconPainter extends CustomPainter {
  final SportCategory category;
  final Color color;

  _SportIconPainter({required this.category, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (category) {
      case SportCategory.boxCricket:
        _drawCricket(canvas, size, strokePaint, fillPaint);
        break;
      case SportCategory.pickleball:
        _drawPickleball(canvas, size, strokePaint, fillPaint);
        break;
      case SportCategory.football:
        _drawFootball(canvas, size, strokePaint, fillPaint);
        break;
      case SportCategory.badminton:
        _drawBadminton(canvas, size, strokePaint, fillPaint);
        break;
      default:
        _drawCricket(canvas, size, strokePaint, fillPaint);
        break;
    }
  }

  void _drawCricket(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // 3 Stumps / Wickets
    const numStumps = 3;
    final stumpSpacing = w * 0.16;
    final startX = w * 0.34;
    final topY = h * 0.22;
    final bottomY = h * 0.92;

    for (int i = 0; i < numStumps; i++) {
      final x = startX + i * stumpSpacing;
      canvas.drawLine(Offset(x, topY), Offset(x, bottomY), stroke..strokeWidth = 2.2);
    }

    // Bails on top
    canvas.drawLine(
      Offset(startX - 2, topY),
      Offset(startX + (numStumps - 1) * stumpSpacing + 2, topY),
      stroke..strokeWidth = 2.4,
    );

    // Cricket Bat angled
    final batPath = Path();
    batPath.moveTo(w * 0.12, h * 0.25);
    batPath.lineTo(w * 0.22, h * 0.15);
    batPath.lineTo(w * 0.42, h * 0.65);
    batPath.lineTo(w * 0.32, h * 0.75);
    batPath.close();
    canvas.drawPath(batPath, stroke..strokeWidth = 1.8);

    // Bat handle
    canvas.drawLine(Offset(w * 0.17, h * 0.20), Offset(w * 0.08, h * 0.10), stroke..strokeWidth = 2.5);

    // Ball
    canvas.drawCircle(Offset(w * 0.82, h * 0.78), w * 0.10, fill);
  }

  void _drawPickleball(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Paddle 1
    canvas.save();
    canvas.translate(w * 0.38, h * 0.42);
    canvas.rotate(-0.4);
    final paddleRect1 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: w * 0.38, height: h * 0.48),
      const Radius.circular(8),
    );
    canvas.drawRRect(paddleRect1, stroke..strokeWidth = 2.0);
    canvas.drawLine(Offset(0, h * 0.24), Offset(0, h * 0.45), stroke..strokeWidth = 2.5);
    canvas.restore();

    // Paddle 2
    canvas.save();
    canvas.translate(w * 0.62, h * 0.42);
    canvas.rotate(0.4);
    final paddleRect2 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: w * 0.38, height: h * 0.48),
      const Radius.circular(8),
    );
    canvas.drawRRect(paddleRect2, stroke..strokeWidth = 2.0);
    canvas.drawLine(Offset(0, h * 0.24), Offset(0, h * 0.45), stroke..strokeWidth = 2.5);
    canvas.restore();

    // Pickleball with holes
    canvas.drawCircle(Offset(w * 0.5, h * 0.18), w * 0.12, stroke..strokeWidth = 1.8);
    canvas.drawCircle(Offset(w * 0.48, h * 0.16), 1.2, fill);
    canvas.drawCircle(Offset(w * 0.53, h * 0.19), 1.2, fill);
  }

  void _drawFootball(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.5);
    final radius = w * 0.44;

    // Outer circle
    canvas.drawCircle(center, radius, stroke..strokeWidth = 2.0);

    // Center pentagon
    final pentagonPath = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 72 - 90) * 3.14159265 / 180;
      final x = center.dx + (radius * 0.38) * (angle > 0 ? (i == 1 || i == 4 ? 0.9 : 1.0) : 1.0) * (angle == -1.570796325 ? 0.9 : 1.0) * 0.8 * (i == 0 ? 0.0 : (i == 1 ? 0.8 : (i == 2 ? 0.5 : (i == 3 ? -0.5 : -0.8))));
      final y = center.dy + (radius * 0.38) * (i == 0 ? -0.8 : (i == 1 || i == 4 ? -0.2 : 0.7));
      if (i == 0) {
        pentagonPath.moveTo(x, y);
      } else {
        pentagonPath.lineTo(x, y);
      }
    }
    pentagonPath.close();
    canvas.drawPath(pentagonPath, fill);

    // Seam lines to outer border
    canvas.drawLine(Offset(center.dx, center.dy - radius * 0.3), Offset(center.dx, center.dy - radius), stroke..strokeWidth = 1.6);
    canvas.drawLine(Offset(center.dx + radius * 0.3, center.dy), Offset(center.dx + radius * 0.95, center.dy + radius * 0.3), stroke..strokeWidth = 1.6);
    canvas.drawLine(Offset(center.dx - radius * 0.3, center.dy), Offset(center.dx - radius * 0.95, center.dy + radius * 0.3), stroke..strokeWidth = 1.6);
    canvas.drawLine(Offset(center.dx + radius * 0.2, center.dy + radius * 0.25), Offset(center.dx + radius * 0.5, center.dy + radius * 0.86), stroke..strokeWidth = 1.6);
    canvas.drawLine(Offset(center.dx - radius * 0.2, center.dy + radius * 0.25), Offset(center.dx - radius * 0.5, center.dy + radius * 0.86), stroke..strokeWidth = 1.6);
  }

  void _drawBadminton(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final w = size.width;
    final h = size.height;

    // Left Racket
    canvas.save();
    canvas.translate(w * 0.35, h * 0.4);
    canvas.rotate(-0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w * 0.35, height: h * 0.44),
      stroke..strokeWidth = 1.8,
    );
    canvas.drawLine(Offset(0, h * 0.22), Offset(0, h * 0.52), stroke..strokeWidth = 2.2);
    canvas.restore();

    // Right Racket
    canvas.save();
    canvas.translate(w * 0.65, h * 0.4);
    canvas.rotate(0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w * 0.35, height: h * 0.44),
      stroke..strokeWidth = 1.8,
    );
    canvas.drawLine(Offset(0, h * 0.22), Offset(0, h * 0.52), stroke..strokeWidth = 2.2);
    canvas.restore();

    // Shuttlecock bottom
    canvas.drawCircle(Offset(w * 0.5, h * 0.82), w * 0.08, fill);
    final shuttlePath = Path()
      ..moveTo(w * 0.42, h * 0.8)
      ..lineTo(w * 0.36, h * 0.65)
      ..lineTo(w * 0.64, h * 0.65)
      ..lineTo(w * 0.58, h * 0.8)
      ..close();
    canvas.drawPath(shuttlePath, stroke..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(covariant _SportIconPainter oldDelegate) =>
      oldDelegate.category != category || oldDelegate.color != color;
}
