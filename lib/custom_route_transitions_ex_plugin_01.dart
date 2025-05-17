import 'package:flutter/material.dart';
import 'package:custom_route_transitions_ex_plugin_01/models/animation_type_enum.dart';

/// A utility class for handling custom route transitions in Flutter navigation.
///
/// The [RouteTransitions] class provides an easy way to navigate between pages
/// with different animation effects, such as normal, fade in, and fade out transitions.
/// It also supports both push and pushReplacement navigation methods.
///
/// Example usage:
/// ```dart
/// RouteTransitions(
///   context: context,
///   child: NextPage(),
///   animation: AnimationType.fadeIn,
///   duration: Duration(milliseconds: 500),
///   replacement: true,
/// );
/// ```
///
/// The class also provides static methods for custom transitions like slide from right
/// and scale transitions, which can be used directly with the Navigator:
/// ```dart
/// Navigator.of(context).push(RouteTransitions.slideFromRight(MyPage()));
/// ```
///
/// Parameters:
/// - [context]: The build context used for navigation.
/// - [child]: The widget to navigate to.
/// - [animation]: The type of animation to use for the transition. Defaults to [AnimationType.normal].
/// - [duration]: The duration of the transition animation. Defaults to 300 milliseconds.
/// - [replacement]: Whether to replace the current route (pushReplacement) or push a new one. Defaults to false.
///
/// See also:
/// - [AnimationType] for available animation types.
/// - [Navigator] for navigation methods.
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

  /// Pushes the given [route] onto the navigation stack.
  ///
  /// Use this method to navigate to a new route without replacing the current one.
  void _push(Route route) => Navigator.push(context, route);

  /// Replaces the current route by pushing the given [route] and removing the previous one.
  ///
  /// Use this method for navigation when you want to discard the current route.
  void _pushReplacement(Route route) =>
      Navigator.pushReplacement(context, route);

  /// Navigates to the [child] widget using the default Material page route transition.
  ///
  /// If [replacement] is true, replaces the current route; otherwise, pushes a new route.
  void _navigateNormal() {
    final route = MaterialPageRoute(builder: (_) => child);
    if (replacement) {
      _pushReplacement(route);
      return;
    }
    _push(route);
  }

  /// Navigates to the [child] widget with a fade-in transition.
  ///
  /// The transition duration is defined by [duration]. If [replacement] is true,
  /// replaces the current route; otherwise, pushes a new route.
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

  /// Navigates to the [child] widget with a fade-out transition.
  ///
  /// The transition duration is defined by [duration]. If [replacement] is true,
  /// replaces the current route; otherwise, pushes a new route.
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

  /// Creates a [Route] that transitions the given [page] by sliding it in from the right.
  ///
  /// Use this static method to apply a right-to-left slide transition to a new page.
  static Route<T> slideFromRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  /// Creates a [Route] that transitions the given [page] with a scale (zoom) animation.
  ///
  /// The page scales from 80% to 100% of its size using an ease-out curve.
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
