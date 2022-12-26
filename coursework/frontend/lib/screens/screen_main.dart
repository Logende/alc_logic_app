import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/widget_main_answers.dart';
import 'package:frontend/widgets/widget_main_task.dart';
import 'package:frontend/widgets/widget_main_timer.dart';

import '../models/model_game_state.dart';
import '../providers.dart';

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
              onPressed: onPressedDarkmode, icon: const Icon(Icons.wb_sunny))
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

  void onPressedStatistics() {}
  void onPressedHelp() {}
  void onPressedDarkmode() {}
}
