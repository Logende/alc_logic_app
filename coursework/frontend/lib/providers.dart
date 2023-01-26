import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/model_game_state.dart';
import 'package:frontend/models/model_tasks.dart';
import 'package:frontend/models/model_user_statistics.dart';

import 'models/model_timer.dart';

final tasksProvider = StateNotifierProvider<TaskListNotifier, TaskList>((ref) {
  var notifier = TaskListNotifier();
  notifier.load();
  return notifier;
});

final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  var notifier = GameStateNotifier(ref);
  notifier.load(ref);
  return notifier;
});

final userStatisticsProvider =
    StateNotifierProvider<UserStatisticsNotifier, UserStatistics>((ref) {
  var notifier = UserStatisticsNotifier();
  notifier.load();
  return notifier;
});

final timerProvider =
    StateNotifierProvider<TimerModelNotifier, TimerModel>((ref) {
  var notifier = TimerModelNotifier(ref);
  notifier.resetTimer();
  return notifier;
});

final firebaseInitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});


final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});