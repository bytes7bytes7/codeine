import 'package:flutter/material.dart';

import 'screens/screens.dart';
import 'constants/routes.dart' as constant_routes;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, dynamic> args =
        (settings.arguments as Map<String, dynamic>?) ?? {};

    switch (settings.name) {
      case constant_routes.preloading:
        return _up(const PreloadingScreen());
      // case constant_routes.login:
      //   return _up(LoginScreen());
      // case constant_routes.home:
      //   return _up(HomeScreen(user: user));
      default:
        return _left(
          const Scaffold(
            body: Center(
              child: Text('Not found'),
            ),
          ),
        );
    }
  }

  static Route<dynamic> _left(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          child: child,
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
        );
      },
    );
  }

  static Route<dynamic> _up(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          child: child,
          position: animation.drive(
            Tween(
              begin: const Offset(0.0, 1.0),
              end: const Offset(0.0, 0.0),
            ).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
        );
      },
    );
  }
}
