import 'package:flutter/material.dart';

class BouncingEffect extends StatefulWidget {
  const BouncingEffect({required this.child, required this.onTap, super.key});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<BouncingEffect> createState() => _BouncingEffectState();
}

class _BouncingEffectState extends State<BouncingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      value: 1,
      lowerBound: 0.8,
    );
    // _curvedAnimation =
    //     CurvedAnimation(parent: _controller, curve: Curves.bounceIn);
    // _controller.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: IgnorePointer(child: widget.child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PulsingAnimation extends StatefulWidget {
  const PulsingAnimation({
    required this.child,
    required this.pulseColor,
    super.key,
  });
  final Widget child;
  final Color pulseColor;

  @override
  _PulsingAnimationState createState() => _PulsingAnimationState();
}

class _PulsingAnimationState extends State<PulsingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Animation duration
    )..repeat(reverse: true); // Make it pulse continuously

    // Animation that scales from 1.0 to 1.2 and back
    _scaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), // Capsule shape
            boxShadow: [
              BoxShadow(
                color: widget.pulseColor,
                blurRadius: 20 * _scaleAnimation.value,
                spreadRadius: 5 * _scaleAnimation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
