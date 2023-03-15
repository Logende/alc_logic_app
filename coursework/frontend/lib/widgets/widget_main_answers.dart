import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_data_persistence.dart';
import 'package:frontend/handlers/handler_task_selector.dart';
import 'package:frontend/models/model_game_state.dart';
import 'package:frontend/providers.dart';

class WidgetMainAnswers extends ConsumerStatefulWidget {
  const WidgetMainAnswers({super.key, required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<WidgetMainAnswers> createState() => WidgetMainAnswersState();
}

class WidgetMainAnswersState extends ConsumerState<WidgetMainAnswers> {
  @override
  Widget build(BuildContext context) {
    GameState gameState = ref.watch(gameStateProvider);

    var iconColor = Theme.of(context).textTheme.bodyText1!.color;
    var iconThumbsUpColor = iconColor;
    var iconThumbsDownColor = iconColor;
    if (gameState.showSolution) {
      var correctAnswer =
          gameState.userAnswerValue == gameState.currentTask.satisfiable;
      if (gameState.userAnswerValue) {
        iconThumbsUpColor =
            correctAnswer ? Colors.green : Theme.of(context).colorScheme.error;
      } else {
        iconThumbsDownColor =
            correctAnswer ? Colors.green : Theme.of(context).colorScheme.error;
      }
    } else {
      iconColor = Colors.transparent;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: gameState.showSolution ? null : onPressedThumbsDown,
            iconSize: 60,
            icon: Icon(
              Icons.thumb_down,
              color: iconThumbsDownColor,
            )),
        IconButton(
            onPressed: !gameState.showSolution ? null : onPressedNextTask,
            iconSize: 60,
            icon: Icon(
              Icons.next_plan_outlined,
              color: iconColor,
            )),
        IconButton(
          onPressed: gameState.showSolution ? null : onPressedThumbsUp,
          iconSize: 60,
          icon: Icon(
            Icons.thumb_up,
            color: iconThumbsUpColor,
          ),
        ),
      ],
    );
  }

  void onPressedThumbsUp() {
    var gameState = ref.watch(gameStateProvider);

    // only allow choosing answer when solution is not yet shown
    if (!gameState.showSolution) {
      var notifier = ref.watch(gameStateProvider.notifier);
      var timeProvider = ref.watch(timerProvider);
      notifier.setShowSolution(true);
      notifier.setUserAnswer(true, timeProvider.timerValue);

      var timerNotifier = ref.watch(timerProvider.notifier);
      timerNotifier.stopTime();
    }
  }

  void onPressedThumbsDown() {
    var gameState = ref.watch(gameStateProvider);

    // only allow choosing answer when solution is not yet shown
    if (!gameState.showSolution) {
      var notifier = ref.watch(gameStateProvider.notifier);
      var timeProvider = ref.watch(timerProvider);
      notifier.setShowSolution(true);
      notifier.setUserAnswer(false, timeProvider.timerValue);

      var timerNotifier = ref.watch(timerProvider.notifier);
      timerNotifier.stopTime();
    }
  }

  void onPressedNextTask() {
    var gameState = ref.watch(gameStateProvider);
    var availableTasks = ref.watch(tasksProvider);
    var userStats = ref.watch(userStatisticsProvider);
    var gameStateNotifier = ref.watch(gameStateProvider.notifier);
    var userStatisticsNotifier = ref.watch(userStatisticsProvider.notifier);

    gameStateNotifier.setShowSolution(false);
    gameStateNotifier.replaceTask(selectTask(gameState, availableTasks, userStats));

    userStatisticsNotifier.addUserAttempt(gameState);
    ref.watch(timerProvider.notifier).resetTimer();
    persistUserStatistics(ref.watch(userStatisticsProvider));
  }
}
