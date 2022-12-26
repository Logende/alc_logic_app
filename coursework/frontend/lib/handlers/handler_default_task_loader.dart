import 'package:flutter/services.dart';
import "package:yaml/yaml.dart";

import '../models/model_tasks.dart';

Future<List<Task>> loadDefaultTasks() async {
  final data = await rootBundle.loadString('assets/default_tasks.yaml');
  final mapData = loadYaml(data);
  final Iterable taskDefinitionList = mapData["tasks"];

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
