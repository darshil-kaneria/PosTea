import 'package:flutter/material.dart';
import 'dart:async';
class ShowUpAnimation extends StatefulWidget {

  final Widget child;
  final int delay;
  bool direction;

  ShowUpAnimation({@required this.child, this.delay, this.direction});

  @override
  _ShowUpAnimationState createState() => _ShowUpAnimationState();
}

class _ShowUpAnimationState extends State<ShowUpAnimation> with TickerProviderStateMixin{

  AnimationController animationController;
  Animation<Offset> animation;

  void reverseDir(){
    setState(() {


      if (widget.delay == null) {
      animationController.reverse();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        animationController.reverse();
      });
    }
      
    });
  }

  @override
  void initState() {
    
    super.initState();

    animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

    if (widget.delay == null && widget.direction == true) {
      animationController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        animationController.forward();
      });
    }
    
  }

  @override
  void dispose() {
    
    super.dispose();
    animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SlideTransition(position: animation, child: widget.child),
    );
  }
}