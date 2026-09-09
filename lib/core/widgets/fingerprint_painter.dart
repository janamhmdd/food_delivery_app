import 'package:flutter/material.dart';

class FingerprintPainter extends CustomPainter {
  final Color color;
  final Color? activeColor;
  final double scanProgress;
  final double strokeWidth;

  const FingerprintPainter({
    required this.color,
    this.activeColor,
    this.scanProgress = 0.0,
    this.strokeWidth = 11.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    _drawFingerprint(canvas, size, basePaint);

    if (scanProgress > 0.0 && activeColor != null) {
      final activePaint = Paint()
        ..color = activeColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.save();
      final clipTop = size.height * (1.0 - scanProgress.clamp(0.0, 1.0));
      canvas.clipRect(
        Rect.fromLTWH(0, clipTop, size.width, size.height - clipTop + 10),
      );
      _drawFingerprint(canvas, size, activePaint);
      canvas.restore();
    }
  }

  void _drawFingerprint(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;

    // Outer overarching curve (top)
    final outerPath = Path();
    outerPath.moveTo(w * 0.15, h * 0.65);
    outerPath.cubicTo(
      w * 0.10, h * 0.35,
      w * 0.25, h * 0.05,
      w * 0.50, h * 0.05,
    );
    outerPath.cubicTo(
      w * 0.75, h * 0.05,
      w * 0.90, h * 0.35,
      w * 0.85, h * 0.68,
    );
    canvas.drawPath(outerPath, paint);

    // Outer right lower trail
    final outerRightTrail = Path();
    outerRightTrail.moveTo(w * 0.85, h * 0.74);
    outerRightTrail.cubicTo(
      w * 0.85, h * 0.85,
      w * 0.80, h * 0.93,
      w * 0.75, h * 0.94,
    );
    canvas.drawPath(outerRightTrail, paint);

    // Outer left lower trail
    final outerLeftTrail = Path();
    outerLeftTrail.moveTo(w * 0.15, h * 0.71);
    outerLeftTrail.cubicTo(
      w * 0.17, h * 0.77,
      w * 0.20, h * 0.82,
      w * 0.22, h * 0.85,
    );
    canvas.drawPath(outerLeftTrail, paint);

    // Second loop (middle arch)
    final midPath = Path();
    midPath.moveTo(w * 0.28, h * 0.62);
    midPath.cubicTo(
      w * 0.24, h * 0.38,
      w * 0.33, h * 0.18,
      w * 0.50, h * 0.18,
    );
    midPath.cubicTo(
      w * 0.67, h * 0.18,
      w * 0.76, h * 0.38,
      w * 0.72, h * 0.62,
    );
    midPath.cubicTo(
      w * 0.70, h * 0.76,
      w * 0.65, h * 0.86,
      w * 0.55, h * 0.93,
    );
    midPath.cubicTo(
      w * 0.45, h * 0.96,
      w * 0.35, h * 0.94,
      w * 0.30, h * 0.90,
    );
    canvas.drawPath(midPath, paint);

    // Inner arch
    final innerPath = Path();
    innerPath.moveTo(w * 0.38, h * 0.62);
    innerPath.cubicTo(
      w * 0.36, h * 0.44,
      w * 0.41, h * 0.31,
      w * 0.50, h * 0.31,
    );
    innerPath.cubicTo(
      w * 0.59, h * 0.31,
      w * 0.64, h * 0.44,
      w * 0.62, h * 0.62,
    );
    innerPath.cubicTo(
      w * 0.60, h * 0.78,
      w * 0.52, h * 0.85,
      w * 0.45, h * 0.85,
    );
    innerPath.cubicTo(
      w * 0.41, h * 0.85,
      w * 0.38, h * 0.78,
      w * 0.40, h * 0.68,
    );
    canvas.drawPath(innerPath, paint);

    // Center vertical pill core
    final corePath = Path();
    corePath.moveTo(w * 0.50, h * 0.42);
    corePath.lineTo(w * 0.50, h * 0.54);
    canvas.drawPath(corePath, paint);

    // Center lower dot / small stroke
    final lowerCore = Path();
    lowerCore.moveTo(w * 0.48, h * 0.65);
    lowerCore.lineTo(w * 0.48, h * 0.71);
    canvas.drawPath(lowerCore, paint);

    // Left lower detached stroke
    final leftLower = Path();
    leftLower.moveTo(w * 0.28, h * 0.73);
    leftLower.lineTo(w * 0.24, h * 0.83);
    canvas.drawPath(leftLower, paint);
  }

  @override
  bool shouldRepaint(covariant FingerprintPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.scanProgress != scanProgress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
