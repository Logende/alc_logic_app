import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_task_loader.dart';
import 'package:frontend/handlers/handlers_time_formatter.dart';
import 'package:frontend/models/model_user_statistics_aggregated.dart';
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

class ScreenUserGuide extends ConsumerStatefulWidget {
  const ScreenUserGuide({super.key});

  static String get routeName => 'user_guide';
  static String get routeLocation => '/user_guide';

  final String title = "User Guide";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenUserGuideState();
  }
}

class _ScreenUserGuideState extends ConsumerState<ScreenUserGuide> {
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
          child: Html(
            data: """<div>
        <h1>Demo Page</h1>
        <p>This is a fantastic product that you should buy!</p>
        <h3>Features</h3>
        <ul>
          <li>It actually works</li>
          <li>It exists</li>
          <li>It doesn't cost much!</li>
        </ul>
        <!--You can pretty much put any html in here!-->
      </div>""",
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
