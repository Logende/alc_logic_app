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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Satisfiable?", style: Theme.of(context).textTheme.headlineLarge),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                gameState.currentTask.concept,
                style: Theme.of(context).textTheme.headline1,
              ),
            ))
      ],
    );
  }
}
