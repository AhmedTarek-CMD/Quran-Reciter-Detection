import 'package:flutter/material.dart';

class GradientCircle extends StatelessWidget {
  final double size;
  final double borderWidth;

  const GradientCircle({super.key, this.size = 100.0, this.borderWidth = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF3E3E3E),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF3AF00),
            blurRadius: borderWidth,
            spreadRadius: borderWidth,
            blurStyle: BlurStyle.outer, // Applies the blur to the outside of the box
          ),
        ],
      ),
      child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF3E3E3E),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Image.asset('assets/images/quran-logo.png'),
            ),
          )),
    );
  }
}
