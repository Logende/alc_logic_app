import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_default_task_loader.dart';
import 'package:frontend/router.dart';
import 'package:frontend/screens/screen_main.dart';
import 'package:frontend/widgets/widget_main_answers.dart';
import 'package:frontend/widgets/widget_main_task.dart';
import 'package:frontend/widgets/widget_main_timer.dart';
import 'package:go_router/go_router.dart';

import '../models/model_game_state.dart';
import '../providers.dart';

class ScreenStatistics extends ConsumerStatefulWidget {
  const ScreenStatistics({super.key});

  static String get routeName => 'statistics';
  static String get routeLocation => '/statistics';

  final String title = "Statistics";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenStatisticsState();
  }
}

class _ScreenStatisticsState extends ConsumerState<ScreenStatistics> {

  @override
  Widget build(BuildContext context) {
    GameState gameState = ref.watch(gameStateProvider);

    IconData iconDataDarkmode = gameState.darkMode ? Icons.nights_stay : Icons.wb_sunny;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: onPressedClose, icon: const Icon(Icons.close)),
          IconButton(
            // nights_stay is name of other icon
              onPressed: onPressedDarkmode, icon: Icon(iconDataDarkmode))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(ref.watch(userStatisticsProvider).toMap().toString()),
        ],
      ),
    );
  }

  void onPressedClose() {
    context.go(ScreenMain.routeLocation);
  }

  void onPressedDarkmode() {
    var gameState = ref.watch(gameStateProvider);
    var notifier = ref.watch(gameStateProvider.notifier);
    notifier.setDarkMode(!gameState.darkMode);
  }
}
