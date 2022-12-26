import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    var iconThumbsUpColor = Theme.of(context).textTheme.bodyText1!.color;
    var iconThumbsDownColor = Theme.of(context).textTheme.bodyText1!.color;
    if (gameState.showSolution) {
      var correctAnswer =
          gameState.userAnswerValue == gameState.currentTask.satisfiable;
      if (gameState.userAnswerValue) {
        iconThumbsUpColor = correctAnswer
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.error;
      } else {
        iconThumbsDownColor = correctAnswer
            ? Colors.green
            : Theme.of(context).colorScheme.error;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: onPressedThumbsUp,
            iconSize: 60,
            icon: Icon(
              Icons.thumb_up,
              color: iconThumbsUpColor,
            )),
        IconButton(
            onPressed: onPressedThumbsDown,
            iconSize: 60,
            icon: Icon(
              Icons.thumb_down,
              color: iconThumbsDownColor,
            ))
      ],
    );
  }

  void onPressedThumbsUp() {
    var notifier = ref.watch(gameStateProvider.notifier);
    notifier.setShowSolution(true);
    notifier.setUserAnswerValue(true);
  }

  void onPressedThumbsDown() {
    var notifier = ref.watch(gameStateProvider.notifier);
    notifier.setShowSolution(true);
    notifier.setUserAnswerValue(false);
  }
}
