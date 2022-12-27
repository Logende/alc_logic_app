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
        iconThumbsUpColor = correctAnswer
            ? Colors.green
            : Theme.of(context).colorScheme.error;
      } else {
        iconThumbsDownColor = correctAnswer
            ? Colors.green
            : Theme.of(context).colorScheme.error;
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
            onPressed: gameState.showSolution ? null : onPressedThumbsUp,
            iconSize: 60,

            icon: Icon(
              Icons.thumb_up,
              color: iconThumbsUpColor,
            ),
        ),

        IconButton(
            onPressed: !gameState.showSolution ? null : onPressedNextTask,
            iconSize: 60,
            icon: Icon(
              Icons.next_plan_outlined,
              color: iconColor,
            )
        ),

        IconButton(
            onPressed: gameState.showSolution ? null : onPressedThumbsDown,
            iconSize: 60,
            icon: Icon(
              Icons.thumb_down,
              color: iconThumbsDownColor,
            )
        )
      ],
    );
  }

  void onPressedThumbsUp() {
    var gameState = ref.watch(gameStateProvider);

    // only allow choosing answer when solution is not yet shown
    if (!gameState.showSolution) {
      var notifier = ref.watch(gameStateProvider.notifier);
      notifier.setShowSolution(true);
      notifier.setUserAnswerValue(true);
    }
  }

  void onPressedThumbsDown() {
    var gameState = ref.watch(gameStateProvider);

    // only allow choosing answer when solution is not yet shown
    if (!gameState.showSolution) {
      var notifier = ref.watch(gameStateProvider.notifier);
      notifier.setShowSolution(true);
      notifier.setUserAnswerValue(false);
    }
  }

  void onPressedNextTask() {
    var gameState = ref.watch(gameStateProvider);
    var availableTasks = ref.watch(tasksProvider);
    var gameStateNotifier = ref.watch(gameStateProvider.notifier);
    var userStatisticsNotifier = ref.watch(userStatisticsProvider.notifier);

    gameStateNotifier.setShowSolution(false);
    gameStateNotifier.replaceTask(selectTask(gameState, availableTasks));

    userStatisticsNotifier.addUserAttempt(gameState);
    persistUserStatistics(ref.watch(userStatisticsProvider));
  }
}
