import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage navigationAnimation( Widget child){
  return CustomTransitionPage(
    child: child ,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
          begin:const  Offset(1, 0),
          end: Offset.zero
      );

      final curveTwee = CurveTween(curve: Curves.easeInOut);
      return SlideTransition(
        position: animation.drive(curveTwee).drive(tween),
        child: child,
      );
    },
  );
 }