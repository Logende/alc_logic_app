import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_game_state_loader.dart';
import 'package:frontend/models/model_tasks.dart';
import 'package:frontend/providers.dart';

GameState createInitialGameState(Ref ref) {
  // TODO: Make task user-dependent
  Task currentTask = ref.watch(tasksProvider).tasks.first;
  return GameState(
      currentTask: currentTask,
      showSolution: false,
      userAnswerValue: false,
      userAttemptDuration: 0.0,
      darkMode: false);
}

@immutable
class GameState {
  const GameState(
      {required this.currentTask,
      required this.showSolution,
      required this.userAnswerValue,
      required this.userAttemptDuration,
      required this.darkMode});

  final Task currentTask;
  final bool showSolution;
  final bool userAnswerValue;
  final double userAttemptDuration;
  final bool darkMode;

  GameState _copyWith(
      {Task? currentTask,
      bool? showSolution,
      bool? userAnswerValue,
      double? userAttemptDuration,
      bool? darkMode}) {
    return GameState(
      currentTask: currentTask ?? this.currentTask,
      showSolution: showSolution ?? this.showSolution,
      userAnswerValue: userAnswerValue ?? this.userAnswerValue,
      userAttemptDuration: userAttemptDuration ?? this.userAttemptDuration,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  GameState _replaceTask(Task newTask) {
    return _copyWith(currentTask: newTask);
  }

  GameState _setShowSolution(bool showSolution) {
    return _copyWith(showSolution: showSolution);
  }

  GameState _setUserAnswer(bool userAnswerValue, double attemptDuration) {
    return _copyWith(
        userAnswerValue: userAnswerValue, userAttemptDuration: attemptDuration);
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

  void setUserAnswer(bool userAnswerValue, double attemptDuration) {
    state = state._setUserAnswer(userAnswerValue, attemptDuration);
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
