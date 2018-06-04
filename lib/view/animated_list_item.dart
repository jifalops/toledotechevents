import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class AnimatedListItem extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;

  AnimatedListItem(this.firstChild, this.secondChild);
  @override
  _AnimatedListItemState createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 10.0;
    return ListItemAnimation(
      controller: controller.view,
      child: widget.firstChild,
    );
  }
}

class ListItemAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> fade, scale;
  final Widget child;
  ListItemAnimation({Key key, @required this.controller, @required this.child})
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
          begin: 0.92,
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
              child: child,
            ),
          );
        },
        animation: controller,
        child: child,
      );
}

class ListItemPageRoute extends MaterialPageRoute {
  // final Widget firstChil

  ListItemPageRoute({@required WidgetBuilder builder})
      : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // return AnimatedCrossFade(
    //   crossFadeState: CrossFadeState.showFirst,
    //   duration: Duration(milliseconds: 400),
    //   firstChild: firstChild,
    //   secondChild: child,
    // );
    return child;
  }

  @override
  didPush() {}
}
