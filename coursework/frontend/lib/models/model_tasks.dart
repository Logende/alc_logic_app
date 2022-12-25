import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TaskList createInitialTaskList() {
  var tasks = <Task>[
    const Task(concept: "A", satisfiable: true),
    const Task(concept: "A AND NOT A", satisfiable: false),
    // TODO: have tasks in UTF8 and read them from a file instead of hardcoding here
  ];
  return TaskList(tasks: tasks);
}

@immutable
class Task {
  const Task({required this.concept, required this.satisfiable});

  final String concept;
  final bool satisfiable;
}


@immutable
class TaskList {
  const TaskList({required this.tasks});

  final List<Task> tasks;

}

class TaskListNotifier extends StateNotifier<TaskList> {
  TaskListNotifier() : super(createInitialTaskList());

  void updateTasks(List<Task> newTasks) {
    state = TaskList(tasks: newTasks);
  }
}
