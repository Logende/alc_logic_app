import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_default_task_loader.dart';

TaskList createInitialTaskList() {
  var tasks = <Task>[
    const Task(concept: "Loading....", satisfiable: true, complexity: 0),
  ];
  return TaskList(tasks: tasks, loaded: false);
}

@immutable
class Task {
  const Task(
      {required this.concept,
      required this.satisfiable,
      required this.complexity});

  final String concept;
  final bool satisfiable;
  final int complexity;
}

@immutable
class TaskList {
  const TaskList({required this.tasks, required this.loaded});

  final List<Task> tasks;
  final bool loaded;
}

class TaskListNotifier extends StateNotifier<TaskList> {
  TaskListNotifier() : super(createInitialTaskList());

  void updateTasks(List<Task> newTasks, bool loaded) {
    state = TaskList(tasks: newTasks, loaded: loaded);
  }

  void load() {
    loadDefaultTasks().then((value) => updateTasks(value, true));
  }

  bool isLoaded() {
    return state.loaded;
  }
}
