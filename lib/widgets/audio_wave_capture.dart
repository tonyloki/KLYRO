import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AudioWaveCaptureWidget extends StatefulWidget {
  final bool isRecording;

  const AudioWaveCaptureWidget({
    super.key,
    this.isRecording = true,
  });

  @override
  State<AudioWaveCaptureWidget> createState() => _AudioWaveCaptureWidgetState();
}

class _AudioWaveCaptureWidgetState extends State<AudioWaveCaptureWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 80),
          painter: _WavePainter(
            animationValue: _controller.value,
            isRecording: widget.isRecording,
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;
  final bool isRecording;

  _WavePainter({required this.animationValue, required this.isRecording});

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = 28;
    final barWidth = (size.width - (barCount * 4)) / barCount;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + 4);
      final phase = (i / barCount) * 2 * pi + (animationValue * 2 * pi);
      final heightFactor = isRecording
          ? 0.2 + (0.8 * (0.5 + 0.5 * sin(phase)))
          : 0.15;
      final barHeight = size.height * heightFactor;
      final y = (size.height - barHeight) / 2;

      final color = i % 4 == 0
          ? AppColors.primary
          : (i % 3 == 0 ? AppColors.ai : AppColors.info);
      paint.color = color.withOpacity(isRecording ? 0.85 : 0.3);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isRecording != isRecording;
  }
}
