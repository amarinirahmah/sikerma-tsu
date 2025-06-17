import 'package:flutter/material.dart';

class FadeInOnScroll extends StatefulWidget {
  final Widget child;
  final double triggerOffset;
  final ScrollController scrollController;

  const FadeInOnScroll({
    required this.child,
    required this.scrollController,
    this.triggerOffset = 100,
    super.key,
  });

  @override
  State<FadeInOnScroll> createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<FadeInOnScroll> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      final position = renderObject.localToGlobal(Offset.zero).dy;
      final screenHeight = MediaQuery.of(context).size.height;

      if (position < screenHeight - widget.triggerOffset) {
        setState(() => opacity = 1.0);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: widget.child,
    );
  }
}
