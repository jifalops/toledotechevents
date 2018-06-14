import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class AnimatedPage extends StatefulWidget {
  final Widget child;
  AnimatedPage(this.child);
  @override
  _AnimatedPageState createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 10.0;
    return PageAnimation(
      controller: _controller.view,
      child: widget.child,
    );
  }
}

class PageAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> scale;
  final Animation<double> fade;
  final Widget child;
  PageAnimation({Key key, @required this.controller, @required this.child})
      : fade = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: Curves.easeIn),
          ),
        ),
        scale = Tween(
          begin: 0.95,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.0, 1.0, curve: Curves.easeIn),
        )),
        super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        builder: (context, child) {
          return ScaleTransition(
            scale: scale,
            child: FadeTransition(
              opacity: fade,
              child: this.child,
            ),
          );
        },
        animation: controller,
      );
}
