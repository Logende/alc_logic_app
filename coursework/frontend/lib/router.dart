import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/screen_main.dart';
import 'package:frontend/screens/screen_statistics.dart';
import 'package:frontend/screens/screen_user_guide.dart';
import 'package:go_router/go_router.dart';

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: ScreenMain.routeLocation,
    routes: [
      GoRoute(
        path: ScreenMain.routeLocation,
        name: ScreenMain.routeName,
        builder: (context, state) {
          return const ScreenMain();
        },
      ),
      GoRoute(
        path: ScreenStatistics.routeLocation,
        name: ScreenStatistics.routeName,
        builder: (context, state) {
          return const ScreenStatistics();
        },
      ),
      GoRoute(
        path: ScreenUserGuide.routeLocation,
        name: ScreenUserGuide.routeName,
        builder: (context, state) {
          return const ScreenUserGuide();
        },
      ),
    ],
    redirect: (context, state) {
      ScreenMain.routeLocation;
      return null;
    },
  );
});
