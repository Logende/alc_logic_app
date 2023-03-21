import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/model_game_state.dart';
import 'package:frontend/providers.dart';

Future<GameState> loadGameState(Ref ref) async {
  await ref.watch(tasksProvider.notifier).isLoaded();

  var taskList = ref.watch(tasksProvider).tasks;
  var task = taskList[Random().nextInt(taskList.length)];
  return GameState(
      currentTask: task,
      showSolution: false,
      userAnswerValue: false,
      userAttemptDuration: 0.0,
      darkMode: false);
}
