import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_default_task_loader.dart';
import 'package:frontend/handlers/handlers_time_formatter.dart';
import 'package:frontend/router.dart';
import 'package:frontend/screens/screen_main.dart';
import 'package:frontend/widgets/widget_main_answers.dart';
import 'package:frontend/widgets/widget_main_task.dart';
import 'package:frontend/widgets/widget_main_timer.dart';
import 'package:frontend/widgets/widget_statistics_chart_success_over_difficulty.dart';
import 'package:frontend/widgets/widget_statistics_chart_time_over_difficulty.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_file.dart';

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
    var stats = ref.watch(userStatisticsProvider);
    var totalTimePlayed = stats.tasksStatistics.values.fold(0.0,
        (previousValue, element) => previousValue + element.totalTimeNeeded);
    var totalAttempts = stats.tasksStatistics.values
        .fold(0, (previousValue, element) => previousValue + element.attempts);
    var averageTimePerTask = totalTimePlayed / totalAttempts;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: onPressedClose, icon: const Icon(Icons.close)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Total Time Played: ${formatTimePlaytime(totalTimePlayed)}",
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(
                  "Average Time/Task: ${formatTimePlaytime(averageTimePerTask)}",
                  style: Theme.of(context).textTheme.headlineSmall),
              //Text(ref.watch(userStatisticsProvider).toMap().toString()),

              BarChartSuccessOverDifficulty(ref: ref),

              LineChartTimeOverDifficulty(ref: ref),
            ],
          ),
        ));
  }

  void onPressedClose() {
    context.go(ScreenMain.routeLocation);
    var gameState = ref.watch(gameStateProvider);
    if (!gameState.showSolution) {
      var timerNotifier = ref.watch(timerProvider.notifier);
      timerNotifier.continueTime();
    }
  }
}
