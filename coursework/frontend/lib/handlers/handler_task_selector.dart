import 'dart:math';

import 'package:frontend/models/model_game_state.dart';

import '../models/model_tasks.dart';

Task selectTask(GameState currentState, TaskList availableTasks) {
  return availableTasks.tasks[Random().nextInt(availableTasks.tasks.length)];
}
