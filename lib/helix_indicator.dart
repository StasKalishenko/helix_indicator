import 'dart:math' as math;
import 'dart:ui' show Color, lerpDouble;

import 'package:flutter/material.dart';

class HelixIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final EdgeInsets? padding;

  const HelixIndicator({
    super.key,
    required this.color,
    this.size = 32.0,
    this.padding,
  });

  @override
  State<HelixIndicator> createState() => _HelixIndicatorState();
}

class _HelixIndicatorState extends State<HelixIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  final double _length = 30.0;
  final double _radius = 5.6;

  // For Y calculation
  final int _complexity = 3;

  // For Z calculation
  final int _zFrequency = 2;

  // Base thickness
  final double _baseStrokeWidth = 1.5;

  // How much thicker the front part is
  final double _maxStrokeWidthFactor = 2.5;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      // Adjust rotation speed
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0, end: -2 * math.pi).animate(_rotationController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          final double currentRotation = _rotationAnimation.value;
          Widget child = SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _HelixPainter(
                rotationAngle: currentRotation,
                color: widget.color,
                length: _length,
                radius: _radius,
                complexity: _complexity,
                zFrequency: _zFrequency,
                baseStrokeWidth: _baseStrokeWidth,
                maxStrokeWidthFactor: _maxStrokeWidthFactor,
              ),
            ),
          );
          if (widget.padding != null) {
            child = Padding(
              padding: widget.padding!,
              child: child,
            );
          }
          return child;
        });
  }
}

class _HelixPainter extends CustomPainter {
  final double rotationAngle;
  final Color color;
  final double length;
  final double radius;
  final int complexity;
  final int zFrequency;
  final double baseStrokeWidth;
  final double maxStrokeWidthFactor;

  _HelixPainter({
    required this.rotationAngle,
    required this.color,
    required this.length,
    required this.radius,
    required this.complexity,
    required this.zFrequency,
    required this.baseStrokeWidth,
    required this.maxStrokeWidthFactor,
  });

  ({Offset point2D, double zPrime}) getProjectedPointAndZ(double percent, double scaleFactor, double rotation) {
    double x = length * math.sin(math.pi * 2 * percent);
    double y = radius * math.cos(math.pi * 2 * complexity * percent);
    double z = radius * math.sin(math.pi * 2 * zFrequency * percent);
    double yPrime = y * math.cos(rotation) - z * math.sin(rotation);
    double zPrime = y * math.sin(rotation) + z * math.cos(rotation);
    return (point2D: Offset(x * scaleFactor, yPrime * scaleFactor), zPrime: zPrime);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset p1;
    double z1;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double scaleFactor = (size.width / 2) / (length * 1.2);
    canvas.translate(center.dx, center.dy);
    const int segments = 150;
    final Paint segmentPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final double minStroke = baseStrokeWidth / maxStrokeWidthFactor;
    final double maxStroke = baseStrokeWidth * maxStrokeWidthFactor;
    var result0 = getProjectedPointAndZ(0, scaleFactor, rotationAngle);
    p1 = result0.point2D;
    z1 = result0.zPrime;
    for (int i = 1; i <= segments; i++) {
      final double currentPercent = i / segments;
      var result = getProjectedPointAndZ(currentPercent, scaleFactor, rotationAngle);
      Offset p2 = result.point2D;
      double z2 = result.zPrime;
      double segmentZ = (z1 + z2) / 2.0;
      double normalizedZ = (segmentZ / radius + 1) / 2.0;
      normalizedZ = normalizedZ.clamp(0.0, 1.0);
      double segmentStrokeWidth = lerpDouble(minStroke, maxStroke, normalizedZ) ?? baseStrokeWidth;
      segmentPaint.strokeWidth = segmentStrokeWidth;
      canvas.drawLine(p1, p2, segmentPaint);
      p1 = p2;
      z1 = z2;
    }
  }

  @override
  bool shouldRepaint(covariant _HelixPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.color != color ||
        oldDelegate.length != length ||
        oldDelegate.radius != radius ||
        oldDelegate.complexity != complexity ||
        oldDelegate.zFrequency != zFrequency ||
        oldDelegate.baseStrokeWidth != baseStrokeWidth ||
        oldDelegate.maxStrokeWidthFactor != maxStrokeWidthFactor;
  }
}
