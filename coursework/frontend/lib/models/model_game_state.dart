import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/model_tasks.dart';
import 'package:frontend/providers.dart';

GameState createInitialGameState(Ref ref) {
  // TODO: Make take user-dependent
  Task currentTask = ref.watch(tasksProvider).tasks.first;
  return GameState(currentTask: currentTask, showSolution: false);
}

@immutable
class GameState {
  const GameState({required this.currentTask, required this.showSolution});

  final Task currentTask;
  final bool showSolution;

  GameState _copyWith({Task? currentTask, bool? showSolution}) {
    return GameState(
      currentTask: currentTask ?? this.currentTask,
      showSolution: showSolution ?? this.showSolution,
    );
  }

  GameState _replaceTask(Task newTask) {
    return _copyWith(currentTask: newTask);
  }

  GameState _setShowSolution(bool showSolution) {
    return _copyWith(showSolution: showSolution);
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier(Ref ref) : super(createInitialGameState(ref));

  void replaceTask(Task newTask) {
    state = state._replaceTask(newTask);
  }

  void setShowSolution(bool showSolution) {
    state = state._setShowSolution(showSolution);
  }
}
