import 'package:flutter/material.dart';
import 'package:sasha_botique/core/router/route_guards.dart';

import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/signup.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';

class AppRouter {
  final RouteGuards _guards;

  AppRouter(this._guards);

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) =>
              FutureBuilder<bool>(
                future: _guards.unauthGuard(_),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return const LoginScreen();
                  }
                  return const SizedBox.shrink();

                },
              ),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) =>
              FutureBuilder<bool>(
                future: _guards.unauthGuard(_),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return const SignupScreen();
                  }
                  return const SizedBox.shrink();
                },
              ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) =>
              FutureBuilder<bool>(
                future: _guards.authGuard(_),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return HomeScreen();
                  }
                  return const SizedBox.shrink();
                },
              ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
           Scaffold(
            body: Center(
              child: Text('Route not found!',style: TextStyle(color: Colors.white),),
            ),
          ),
        );
    }
  }
}