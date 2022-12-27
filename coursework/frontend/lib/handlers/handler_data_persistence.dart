
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/models/model_user_statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';

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