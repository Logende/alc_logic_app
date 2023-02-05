import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/handlers/handler_data_persistence.dart';
import 'package:frontend/models/model_game_state.dart';

import 'model_tasks.dart';
import 'model_user_statistics.dart';


@immutable
class UserProfile {
  const UserProfile({required this.name,
    required this.statistics,
  });

  final String name;
  final UserStatistics statistics;

}