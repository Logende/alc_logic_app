import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import "package:yaml/yaml.dart";

import '../models/model_tasks.dart';

Future<List<Task>> loadDefaultTasks() async {
  final data = await rootBundle.loadString('assets/default_tasks.yaml');
  final mapData = loadYaml(data);
  final Iterable taskDefinitionList = mapData["tasks"];
  return loadTasksFromYaml(taskDefinitionList);
}

List<Task> loadTasksFromYaml(Iterable taskDefinitionList) {
  var result = <Task>[];
  for (String taskDefinition in taskDefinitionList) {
    var parts = taskDefinition.split(":");
    String concept = parts[0];
    bool satisfiable = parts[1].toLowerCase() == "true";
    int complexity = int.parse(parts[2]);
    result.add(Task(
        concept: concept, satisfiable: satisfiable, complexity: complexity));
  }
  return result;
}

Future<List<Task>> fetchTasksFromBackend() async {
  print("fetch task from backend");

  var uri = 'http://10.0.2.2:5001/tasks';

  final response = await http.get(Uri.parse(uri));

  var body = utf8.decode(response.bodyBytes);

  print("response status code is ${response.statusCode} with text $body");

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var jsonObject = jsonDecode(body);
    return loadTasksFromJson(jsonObject);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Tasks');
  }
}

List<Task> loadTasksFromJson(Iterable taskDefinitions) {
  return List<Task>.from(taskDefinitions.map((model) => Task.fromJson(model)));
}
