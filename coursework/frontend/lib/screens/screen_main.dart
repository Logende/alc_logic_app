import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_default_task_loader.dart';
import 'package:frontend/screens/screen_statistics.dart';
import 'package:frontend/widgets/widget_main_answers.dart';
import 'package:frontend/widgets/widget_main_task.dart';
import 'package:frontend/widgets/widget_main_timer.dart';
import 'package:go_router/go_router.dart';

import '../models/model_game_state.dart';
import '../providers.dart';
import '../router.dart';

class ScreenMain extends ConsumerStatefulWidget {
  const ScreenMain({super.key});

  static String get routeName => 'main';
  static String get routeLocation => '/';

  final String title = "ALC Logic Quiz";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenMainState();
  }
}

class _ScreenMainState extends ConsumerState<ScreenMain> {

  @override
  Widget build(BuildContext context) {
    GameState gameState = ref.watch(gameStateProvider);

    IconData iconDataDarkmode = gameState.darkMode ? Icons.nights_stay : Icons.wb_sunny;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: onPressedStatistics,
              icon: const Icon(Icons.bar_chart)),
          IconButton(
              onPressed: onPressedHelp, icon: const Icon(Icons.help_outline)),
          IconButton(
            // nights_stay is name of other icon
              onPressed: onPressedDarkmode, icon: Icon(iconDataDarkmode))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetMainTimer(ref: ref),
          WidgetMainTask(ref: ref),
          WidgetMainAnswers(ref: ref),

        ],
      ),
    );
  }

  void onPressedStatistics() {
    context.go(ScreenStatistics.routeLocation);
    var timerNotifier = ref.watch(timerProvider.notifier);
    timerNotifier.stopTime();
  }

  void onPressedHelp() {
    context.go("/sign-in");
  }

  void onPressedDarkmode() {
    var gameState = ref.watch(gameStateProvider);
    var notifier = ref.watch(gameStateProvider.notifier);
    notifier.setDarkMode(!gameState.darkMode);
  }
}
