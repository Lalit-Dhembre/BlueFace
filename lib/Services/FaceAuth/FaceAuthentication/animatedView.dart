import 'dart:async';
import 'dart:math';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/size.dart';
import 'package:flutter/material.dart';

class AnimatedView extends StatefulWidget {
  const AnimatedView({super.key});

  @override
  State<AnimatedView> createState() => _AnimatedViewState();
}

class _AnimatedViewState extends State<AnimatedView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late double linePosition; // Position of the line

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        setState(() {
          linePosition = animation.value; // Update line position
        });
      });

    animationController.repeat(reverse: true); // Repeat animation
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      height: 0.3.sh,
      width: 0.66.sw,
      child: CustomPaint(
        painter: HorizontalLinePainter(linePosition: linePosition),
      ),
    );
  }
}

class HorizontalLinePainter extends CustomPainter {
  final double linePosition;

  HorizontalLinePainter({required this.linePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red // Change color to red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Width of the line

    // Fixed length of the line
    double lineLength = 0.66.sw; // 100% of the width
    // Calculate the vertical position of the line
    double y = size.height * linePosition; // Animate up and down

    // Draw the horizontal line
    canvas.drawLine(
      Offset((size.width - lineLength) / 2, y), // Start point
      Offset((size.width + lineLength) / 2, y), // End point
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when linePosition changes
  }
}