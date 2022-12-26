import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/model_game_state.dart';
import 'package:frontend/providers.dart';
import "package:yaml/yaml.dart";

import '../models/model_tasks.dart';

Future<GameState> loadGameState(Ref ref) async {
  await ref.watch(tasksProvider.notifier).isLoaded();

  var taskList = ref.watch(tasksProvider).tasks;
  var task = taskList[Random().nextInt(taskList.length)];
  return GameState(currentTask: task, showSolution: false, userAnswerValue: false, darkMode: false);
}
