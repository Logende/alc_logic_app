import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/model_user_profile.dart';
import 'package:frontend/providers.dart';
import 'package:http/http.dart' as http;

import '../models/model_tasks.dart';

void sendStatisticsToBackend(WidgetRef ref) async {
  print("sending statistics to backend");

  var uri = 'http://10.0.2.2:5001/user/asdfgh';

  final statistics = ref.watch(userStatisticsProvider);
  final profile = UserProfile(
      name: "asdfgh", passwordHash: "asdfgh", statistics: statistics);
  final data = profile.toMap();
  final body = json.encode(data);

  var response = await http.put(Uri.parse(uri),
      headers: {"Content-Type": "application/json"}, body: body);

  print("response status code is ${response.statusCode} with text $body");
}

List<Task> loadTasksFromJson(Iterable taskDefinitions) {
  return List<Task>.from(taskDefinitions.map((model) => Task.fromJson(model)));
}
