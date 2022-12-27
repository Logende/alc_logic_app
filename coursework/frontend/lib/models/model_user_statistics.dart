import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_data_persistence.dart';
import 'package:frontend/handlers/handler_default_task_loader.dart';
import 'package:frontend/models/model_game_state.dart';

TaskStatistics createInitialTaskStatistics() {
  return const TaskStatistics(attempts: 0, successes: 0, totalTimeNeeded: 0.0);
}

UserStatistics createInitialUserStatistics(bool loaded) {
  var tasksStatistics = <String, TaskStatistics>{};
  return UserStatistics(tasksStatistics: tasksStatistics, loaded: loaded);
}

@immutable
class TaskStatistics {
  const TaskStatistics(
      {required this.attempts,
      required this.successes,
      required this.totalTimeNeeded});

  final int attempts;
  final int successes;
  final double totalTimeNeeded;

  TaskStatistics _copyWith(
      {int? attempts, int? successes, double? totalTimeNeeded}) {
    return TaskStatistics(
      attempts: attempts ?? this.attempts,
      successes: successes ?? this.successes,
      totalTimeNeeded: totalTimeNeeded ?? this.totalTimeNeeded,
    );
  }

  TaskStatistics _addAttempt(GameState gameState) {
    var attempts = this.attempts + 1;
    var successes = this.successes +
        (gameState.userAnswerValue == gameState.currentTask.satisfiable
            ? 1
            : 0);
    var totalTimeNeeded = this.totalTimeNeeded + 0.0; // TODO
    return _copyWith(
        attempts: attempts,
        successes: successes,
        totalTimeNeeded: totalTimeNeeded);
  }

  TaskStatistics.fromMap(Map<String, dynamic> json)
      : attempts = json['attempts'],
        successes = json['successes'],
        totalTimeNeeded = json['totalTimeNeeded'];

  Map<String, dynamic> toMap() => {
        'attempts': attempts,
        'successes': successes,
        'totalTimeNeeded': totalTimeNeeded
      };
}

@immutable
class UserStatistics {
  const UserStatistics({required this.tasksStatistics, required this.loaded});

  final Map<String, TaskStatistics> tasksStatistics;
  final bool loaded;

  UserStatistics.fromMap(Map<String, dynamic> json)
      : tasksStatistics = (json['tasksStatistics'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, TaskStatistics.fromMap(value))),
        loaded = json['loaded'];

  Map<String, dynamic> toMap() => {
        'tasksStatistics':
            tasksStatistics.map((key, value) => MapEntry(key, value.toMap())),
        'loaded': loaded
      };

  UserStatistics _addUserAttempt(GameState gameState) {
    var tasksStatistics = this.tasksStatistics;
    var taskId = gameState.currentTask.toString();
    if (tasksStatistics.containsKey(taskId)) {
      tasksStatistics[taskId] = tasksStatistics[taskId]!._addAttempt(gameState);
    } else {
      tasksStatistics[taskId] =
          createInitialTaskStatistics()._addAttempt(gameState);
    }
    return UserStatistics(tasksStatistics: tasksStatistics, loaded: loaded);
  }
}

class UserStatisticsNotifier extends StateNotifier<UserStatistics> {
  UserStatisticsNotifier() : super(createInitialUserStatistics(false));

  void updateUserStatistics(
      Map<String, TaskStatistics> tasksStatistics, bool loaded) {
    state = UserStatistics(tasksStatistics: tasksStatistics, loaded: loaded);
  }

  void load() {
    readUserStatistics().then((value) => state = value);
  }

  void addUserAttempt(GameState gameState) {
    state = state._addUserAttempt(gameState);
  }

  bool isLoaded() {
    return state.loaded;
  }
}
