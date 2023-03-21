import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_data_persistence.dart';
import 'package:frontend/handlers/handler_task_loader.dart';

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

  @override
  String toString() {
    return "$concept:$satisfiable:$complexity";
  }

  Task.fromString(String definition)
      : concept = definition.split(":")[0],
        satisfiable = definition.split(":")[1] == 'true',
        complexity = int.parse(definition.split(":")[2]);

  Task.fromJson(Map<String, dynamic> definition)
      : concept = definition['Concept'],
        satisfiable = definition['Satisfiable'],
        complexity = definition['Complexity'];

  Map<String, dynamic> toMap() => {
        'Concept': concept,
        'Satisfiable': satisfiable,
        'Complexity': complexity
      };
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

    // always when the tasks are updated: persist them for next time
    persistTasks(newTasks);
  }

  void load() {
    // read tasks, which is either previously saved tasks or if none exists
    // it is the default tasks
    readTasks().then((value) => updateTasks(value, true));

    // try to fetch tasks from backend and if it succeeds, update tasks with them
    fetchTasksFromBackend().then((value) => updateTasks(value, true));
    print("fetched taks from backend, now having ${state.tasks.length}");
  }

  bool isLoaded() {
    return state.loaded;
  }
}
