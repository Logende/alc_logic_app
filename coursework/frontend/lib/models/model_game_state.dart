import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_game_state_loader.dart';
import 'package:frontend/models/model_tasks.dart';
import 'package:frontend/providers.dart';

GameState createInitialGameState(Ref ref) {
  // TODO: Make take user-dependent
  Task currentTask = ref.watch(tasksProvider).tasks.first;
  return GameState(
      currentTask: currentTask, showSolution: false, userAnswerValue: false, darkMode: false);
}

@immutable
class GameState {
  const GameState(
      {required this.currentTask,
      required this.showSolution,
      required this.userAnswerValue,
      required this.darkMode});

  final Task currentTask;
  final bool showSolution;
  final bool userAnswerValue;
  final bool darkMode;

  GameState _copyWith(
      {Task? currentTask, bool? showSolution, bool? userAnswerValue, bool? darkMode}) {
    return GameState(
      currentTask: currentTask ?? this.currentTask,
      showSolution: showSolution ?? this.showSolution,
      userAnswerValue: userAnswerValue ?? this.userAnswerValue,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  GameState _replaceTask(Task newTask) {
    return _copyWith(currentTask: newTask);
  }

  GameState _setShowSolution(bool showSolution) {
    return _copyWith(showSolution: showSolution);
  }

  GameState _setUserAnswerValue(bool userAnswerValue) {
    return _copyWith(userAnswerValue: userAnswerValue);
  }

  GameState _setDarkMode(bool darkMode) {
    return _copyWith(darkMode: darkMode);
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier(Ref ref) : super(createInitialGameState(ref));

  void replaceTask(Task task) {
    state = state._replaceTask(task);
  }

  void setShowSolution(bool showSolution) {
    state = state._setShowSolution(showSolution);
  }

  void setUserAnswerValue(bool userAnswerValue) {
    state = state._setUserAnswerValue(userAnswerValue);
  }

  void setDarkMode(bool darkMode) {
    state = state._setDarkMode(darkMode);
  }

  void updateGameState(GameState gameState) {
    state = gameState;
  }

  void load(Ref ref) {
    loadGameState(ref).then((value) => updateGameState(value));
  }
}
