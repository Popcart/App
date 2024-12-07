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
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      value: 1,
      lowerBound: 0.8,
    );
    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceIn);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        _controller.reverse();
      },
      onTapUp: (_) {
        _controller.forward();
      },
      onTapCancel: () {
        _controller.forward();
      },
      onTap: () {
        _controller
            .reverse()
            .then(
              (value) => _controller.forward(),
            )
            .then(
              (value) => widget.onTap(),
            );
        // widget.onTap();
      },
      child: Transform.scale(
        scale: _curvedAnimation.value,
        child: IgnorePointer(child: widget.child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
