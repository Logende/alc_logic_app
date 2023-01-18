import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_data_persistence.dart';
import 'package:frontend/models/model_game_state.dart';
import 'package:frontend/models/model_user_statistics.dart';

import 'model_tasks.dart';

@immutable
class UserStatisticsAggregated {
  const UserStatisticsAggregated(
      this.totalTimePlayed,
      this.averageTimePerTask,
      this.mostDifficultTask,
      this.attempts,
      this.totalTimeNeeded,
      this.averageTimeNeeded,
      this.successes,
      this.failures,
      this.difficulties);

  final double totalTimePlayed;
  final double averageTimePerTask;
  final Task mostDifficultTask;
  final Map<int, int> attempts;
  final Map<int, double> totalTimeNeeded;
  final Map<int, double> averageTimeNeeded;
  final Map<int, int> successes;
  final Map<int, int> failures;
  final List<int> difficulties;
}

UserStatisticsAggregated aggregateUserStatistics(UserStatistics userStats) {
  var totalTimePlayed = userStats.tasksStatistics.values.fold(
      0.0, (previousValue, element) => previousValue + element.totalTimeNeeded);
  var totalAttempts = userStats.tasksStatistics.values
      .fold(0, (previousValue, element) => previousValue + element.attempts);
  var averageTimePerTask = totalTimePlayed / totalAttempts;

  var maxDifficulty = userStats.tasksStatistics.values.fold(
      0,
      (previousValue, element) => previousValue < element.task.complexity
          ? element.task.complexity
          : previousValue);
  var difficulties = List<int>.generate(maxDifficulty + 1, (i) => i);

  var attempts = <int, int>{};
  var totalTimeNeeded = <int, double>{};
  var averageTimeNeeded = <int, double>{};
  var successes = <int, int>{};
  var failures = <int, int>{};

  for (var difficulty in difficulties) {
    attempts[difficulty] = 0;
    totalTimeNeeded[difficulty] = 0;
    successes[difficulty] = 0;
    failures[difficulty] = 0;
  }
  for (var element in userStats.tasksStatistics.values) {
    var complexity = element.task.complexity;

    attempts[complexity] = attempts[complexity]! + element.attempts;
    totalTimeNeeded[complexity] =
        totalTimeNeeded[complexity]! + element.totalTimeNeeded;
    successes[complexity] = successes[complexity]! + element.successes;
    failures[complexity] =
        failures[complexity]! + (element.attempts - element.successes);
  }

  for (var difficulty in difficulties) {
    averageTimeNeeded[difficulty] =
        totalTimeNeeded[difficulty]! / attempts[difficulty]!;
  }

  var mostDifficultTask = userStats.tasksStatistics.values
      .reduce((value, element) => value.attempts - value.successes >
              element.attempts - element.successes
          ? value
          : element)
      .task;

  return UserStatisticsAggregated(
      totalTimePlayed,
      averageTimePerTask,
      mostDifficultTask,
      attempts,
      totalTimeNeeded,
      averageTimeNeeded,
      successes,
      failures,
      difficulties);
}
