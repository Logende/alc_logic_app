import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handlers_time_formatter.dart';
import 'package:frontend/models/model_user_statistics_aggregated.dart';
import 'package:frontend/screens/screen_main.dart';
import 'package:frontend/widgets/widget_statistics_chart_success_over_difficulty.dart';
import 'package:frontend/widgets/widget_statistics_chart_time_over_difficulty.dart';
import 'package:go_router/go_router.dart';

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
    var statsAggregated = aggregateUserStatistics(stats);

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
              Text(
                  "Total Time Played: ${formatTimePlaytime(statsAggregated.totalTimePlayed)}",
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(
                  "Average Time/Task: ${formatTimePlaytime(statsAggregated.averageTimePerTask)}",
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(
                  "Most difficult task: '${statsAggregated.mostDifficultTask.concept}'",
                  style: Theme.of(context).textTheme.headlineSmall),
              BarChartSuccessOverDifficulty(ref: ref, stats: statsAggregated),
              LineChartTimeOverDifficulty(ref: ref, stats: statsAggregated),
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
