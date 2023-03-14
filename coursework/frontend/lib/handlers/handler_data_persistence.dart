
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/handlers/handler_task_loader.dart';
import 'package:frontend/models/model_user_statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/model_tasks.dart';

Future<void> persistUserStatistics(UserStatistics userStatistics) async {
  final prefs = await SharedPreferences.getInstance();
  String stateString = jsonEncode(userStatistics.toMap());
  prefs.setString("user_statistics", stateString);
  debugPrint("persist user_statistics");
}



Future<UserStatistics> readUserStatistics() async {
  debugPrint("read user_statistics");
  final prefs = await SharedPreferences.getInstance();
  UserStatistics userStatistics;
  if (prefs.getKeys().contains("user_statistics")) {
    String stateString = prefs.getString("user_statistics")!;
    userStatistics = UserStatistics.fromMap(jsonDecode(stateString));
    debugPrint("found user_statistics");
  } else {
    debugPrint("create default user_statistics");
    userStatistics = createInitialUserStatistics(true);
  }
  return userStatistics;
}


Future<void> persistTasks(List<Task> tasks) async {
  final prefs = await SharedPreferences.getInstance();
  var taskStrings = List.from(tasks.map((e) => e.toString()));
  String taskString = jsonEncode(taskStrings);
  prefs.setString("tasks", taskString);
  debugPrint("persist tasks");
}

Future<List<Task>> readTasks() async {
  debugPrint("read tasks");
  final prefs = await SharedPreferences.getInstance();
  List<Task> tasks;
  if (prefs.getKeys().contains("tasks")) {
    String taskString = prefs.getString("tasks")!;
    List<dynamic> taskStrings = jsonDecode(taskString);
    Iterable<Task> tasksIterable = taskStrings.map((e) => Task.fromString(e));
    tasks = List.from(tasksIterable);
    debugPrint("found tasks");
  } else {
    debugPrint("read default tasks");
    tasks = await loadDefaultTasks();
  }
  return tasks;
}
