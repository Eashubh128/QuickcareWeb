import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickcare/provider/custom_auth_provider.dart';
import 'package:quickcare/screens/web/resetpassscreen.dart';
import 'package:quickcare/screens/web/splashscreen_web.dart';
import 'package:quickcare/screens/web/authsignin.dart';
import 'package:quickcare/screens/web/homescreen_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) async {
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);
    if (authProvider.isLoading) {
      return '/loading';
    }
    await authProvider.checkSession();
    final isLoggedIn = authProvider.currentUser != null;
    print(isLoggedIn);
    final isSplashScreen = state.matchedLocation == '/';
    final isSignInScreen = state.matchedLocation == '/signin';
    final isResetPasswordScreen =
        state.matchedLocation.startsWith('/reset-password');

    print("coming here");

    if (isResetPasswordScreen) {
      return null;
    }

    if (!isLoggedIn) {
      if (!isSplashScreen && !isSignInScreen) {
        return '/signin';
      }
    } else if (isSignInScreen) {
      return '/home';
    }

    return null;
  },
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
        return ResetPasswordScreen(token: token);
      },
    ),
  ],
);
