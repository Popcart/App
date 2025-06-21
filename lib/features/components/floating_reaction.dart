import 'dart:math';

import 'package:flutter/material.dart';

class FloatingReaction {
  final String emoji;
  final AnimationController controller;
  final Animation<double> fade;
  final Animation<Offset> movement;
  final double startX;

  FloatingReaction({
    required this.emoji,
    required TickerProvider vsync,
    required double screenWidth,
  })  : startX = Random().nextDouble() * (screenWidth - 50),
        controller = AnimationController(
          vsync: vsync,
          duration: const Duration(seconds: 4),
        ),
        movement = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(Random().nextDouble() * 0.4 - 0.2, -2.5),
        ).animate(CurvedAnimation(
          parent: AnimationController(
            vsync: vsync,
            duration: const Duration(seconds: 4),
          ),
          curve: Curves.easeInOut,
        )),
        fade = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
          parent: AnimationController(
            vsync: vsync,
            duration: const Duration(seconds: 4),
          ),
          curve: Curves.easeOut,
        )) {
    controller.forward();
  }

  Widget buildWidget() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Positioned(
        left: startX,
        bottom: 0,
        child: FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: movement,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }

  void dispose() => controller.dispose();
}

