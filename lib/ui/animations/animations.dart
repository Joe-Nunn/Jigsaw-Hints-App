
// Page transition animation
import 'package:flutter/material.dart';

Route slideIn(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, page) {
      const curve = Curves.decelerate;
      const beginSlide = 1.0;
      const endSlide = 10.0;
      var tweenSlide = Tween(begin: beginSlide, end: endSlide)
          .chain(CurveTween(curve: curve));
      const beginFade = 0.0;
      const endFade = 1.0;
      var tweenFade =
          Tween(begin: beginFade, end: endFade).chain(CurveTween(curve: curve));

      final slideTransition =
          SizeTransition(sizeFactor: animation.drive(tweenSlide), child: page);
      return FadeTransition(
          opacity: animation.drive(tweenFade), child: slideTransition);
    },
  );
}