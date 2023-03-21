import 'package:flutter/cupertino.dart';

import 'model_user_statistics.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.name,
    required this.passwordHash,
    required this.statistics,
  });

  final String name;
  final String passwordHash;
  final UserStatistics statistics;

  UserProfile.fromMap(Map<String, dynamic> json)
      : name = json['Name'],
        passwordHash = json['PasswordHash'],
        statistics = UserStatistics.fromMap(json);

  Map<String, dynamic> toMap() => {
        'Name': name,
        'PasswordHash': passwordHash,
        'TasksStatistics': statistics.tasksStatistics
            .map((key, value) => MapEntry(key, value.toMap())),
      };
}
