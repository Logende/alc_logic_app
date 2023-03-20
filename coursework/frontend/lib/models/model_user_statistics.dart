 import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_data_persistence.dart';
import 'package:frontend/models/model_game_state.dart';

import 'model_tasks.dart';

TaskStatistics createInitialTaskStatistics(Task task) {
  return TaskStatistics(
      attempts: 0,
      successes: 0,
      totalTimeNeeded: 0.0,
      task: task);
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
      required this.totalTimeNeeded,
      required this.task});

  final int attempts;
  final int successes;
  final double totalTimeNeeded;

  final Task task;

  TaskStatistics _copyWith(
      {int? attempts, int? successes, double? totalTimeNeeded}) {
    return TaskStatistics(
        attempts: attempts ?? this.attempts,
        successes: successes ?? this.successes,
        totalTimeNeeded: totalTimeNeeded ?? this.totalTimeNeeded,
        task: task);
  }

  TaskStatistics _addAttempt(GameState gameState) {
    var attempts = this.attempts + 1;
    var successes = this.successes +
        (gameState.userAnswerValue == gameState.currentTask.satisfiable
            ? 1
            : 0);
    var totalTimeNeeded = this.totalTimeNeeded + gameState.userAttemptDuration;
    return _copyWith(
        attempts: attempts,
        successes: successes,
        totalTimeNeeded: totalTimeNeeded);
  }

  TaskStatistics.fromMap(Map<String, dynamic> json)
      : attempts = json['Attempts'],
        successes = json['Successes'],
        totalTimeNeeded = json['TotalTimeNeeded'],
        task = Task.fromJson(json['Task']);

  Map<String, dynamic> toMap() => {
        'Attempts': attempts,
        'Successes': successes,
        'TotalTimeNeeded': totalTimeNeeded,
        'Task': task.toMap()
      };
}

@immutable
class UserStatistics {
  const UserStatistics({required this.tasksStatistics, required this.loaded});

  final Map<String, TaskStatistics> tasksStatistics;
  final bool loaded;

  UserStatistics.fromMap(Map<String, dynamic> json)
      : tasksStatistics = (json['TasksStatistics'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, TaskStatistics.fromMap(value))),
        loaded = json['Loaded'];

  Map<String, dynamic> toMap() => {
        'TasksStatistics':
            tasksStatistics.map((key, value) => MapEntry(key, value.toMap())),
        'Loaded': loaded
      };

  UserStatistics _addUserAttempt(GameState gameState) {
    var tasksStatistics = this.tasksStatistics;
    var taskId = gameState.currentTask.toString();
    if (tasksStatistics.containsKey(taskId)) {
      tasksStatistics[taskId] = tasksStatistics[taskId]!._addAttempt(gameState);
    } else {
      tasksStatistics[taskId] =
          createInitialTaskStatistics(gameState.currentTask)._addAttempt(gameState);
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
