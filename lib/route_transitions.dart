import 'package:flutter/material.dart';

enum AnimationType { normal, fadeIn, fadeOut }

class RouteTransitions {
  final BuildContext context;
  final Widget child;
  final AnimationType animation;
  final Duration duration;
  final bool replacement;

  RouteTransitions({
    required this.context,
    required this.child,
    this.animation = AnimationType.normal,
    this.duration = const Duration(milliseconds: 300),
    this.replacement = false,
  }) {
    switch (animation) {
      case AnimationType.normal:
        _navigateNormal();
        break;
      case AnimationType.fadeIn:
        _navigateFadeIn();
        break;
      case AnimationType.fadeOut:
        _navigateFadeOut();
        break;
    }
  }

  void _push(Route route) => Navigator.push(context, route);

  void _pushReplacement(Route route) => Navigator.pushReplacement(context, route);

  void _navigateNormal() {
    final route = MaterialPageRoute(builder: (_) => child);
    if (replacement) {
      _pushReplacement(route);
      return;
    }
    _push(route);
  }

  void _navigateFadeIn() {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
          child: child,
        );
      },
    );
    if (replacement) {
      _pushReplacement(route);
      return;
    }
    _push(route);
  }

  void _navigateFadeOut() {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
    if (replacement) {
      _pushReplacement(route);
      return;
    }
    _push(route);
  }

  static Route<T> slideFromRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static Route<T> scale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return ScaleTransition(scale: scaleAnimation, child: child);
      },
    );
  }
}
