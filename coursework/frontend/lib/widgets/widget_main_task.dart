import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers.dart';

class WidgetMainTask extends ConsumerStatefulWidget {
  const WidgetMainTask({super.key, required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<WidgetMainTask> createState() => WidgetMainTaskState();
}

class WidgetMainTaskState extends ConsumerState<WidgetMainTask> {
  @override
  Widget build(BuildContext context) {
    var gameState = ref.watch(gameStateProvider);

    var text = "Satisfiable?";
    if (gameState.showSolution) {
      text = gameState.currentTask.satisfiable
          ? "Satisfiable."
          : "Not Satisfiable.";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: Theme.of(context).textTheme.headlineLarge),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 6),
          ),
          width: 300,
          height: 300,
          alignment: Alignment.center,
          child: AutoSizeText(
            gameState.currentTask.concept,
            minFontSize: 40,
            wrapWords: false,
            maxLines: 4,
          ),
        )
      ],
    );
  }
}
