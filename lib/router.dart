import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickcare/screens/web/resetpassscreen.dart';
import 'package:quickcare/screens/web/splashscreen_web.dart';
import 'package:quickcare/screens/web/authsignin.dart';
import 'package:quickcare/screens/web/homescreen_web.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (BuildContext context, GoRouterState state) =>
          const SigninScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreenWeb(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (BuildContext context, GoRouterState state) {
        final token = state.uri.queryParameters['token'] ?? "";
        print("token is $token");

        return ResetPasswordScreen(token: token);
      },
    ),
  ],
);
