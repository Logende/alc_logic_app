import 'dart:math';

import 'package:frontend/models/model_game_state.dart';
import 'package:frontend/models/model_user_statistics.dart';

import '../models/model_tasks.dart';

Task selectTask(GameState currentState, TaskList availableTasks, UserStatistics stats) {
  // expect that tasklist is in the order in which the tasks should be completed
  List<Task> options = [];

  // pick the first 5 tasks that are not yet completed‚
  for (var i = 0; i < availableTasks.tasks.length && options.length < 5; i++) {
    var task = availableTasks.tasks[i];
    if (!isTaskCompleted(stats, task)) {
      options.add(task);
    }
  }

  // already completed all tasks? Then add all tasks back
  if (options.isEmpty) {
    options.addAll(availableTasks.tasks);
  }

  return options[Random().nextInt(options.length)];
}

bool isTaskCompleted(UserStatistics stats, Task task) {
  var tasksStats = stats.tasksStatistics;
  if (tasksStats.containsKey(task.toString())) {
    var taskStats = tasksStats[task.toString()]!;
    // completed when more successes than failures
    return taskStats.successes > (taskStats.attempts - taskStats.successes);
  }
  return false;
}