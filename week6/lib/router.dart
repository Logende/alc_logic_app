import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:week6/screens/screen_detailed_combination.dart';
import 'package:week6/screens/screen_dices.dart';
import 'package:week6/screens/screen_settings.dart';
import 'package:week6/screens/screen_stats.dart';

import 'main.dart';

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: ScreenDices.routeLocation,
    routes: [
      GoRoute(
        path: ScreenDices.routeLocation,
        name: ScreenDices.routeName,
        builder: (context, state) {
          return const ScreenDices();
        },
      ),
      GoRoute(
        path: ScreenStats.routeLocation,
        name: ScreenStats.routeName,
        builder: (context, state) {
          return const ScreenStats();
        },
      ),
      GoRoute(
        path: ScreenSettings.routeLocation,
        name: ScreenSettings.routeName,
        builder: (context, state) {
          return const ScreenSettings();
        },
      ),
      GoRoute(
        path: ScreenDetailedCombination.routeLocation,
        name: ScreenDetailedCombination.routeName,
        builder: (context, state) {
          return const ScreenDetailedCombination();
        },
      ),
    ],
    redirect: (context, state) {

      ScreenDices.routeLocation;
    },
  );
});