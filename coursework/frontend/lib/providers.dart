import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/model_game_state.dart';
import 'package:frontend/models/model_tasks.dart';

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
return GameStateNotifier(ref);
});

final tasksProvider = StateNotifierProvider<TaskListNotifier, TaskList>((ref) {
  return TaskListNotifier();
});