import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week8/model/dice_list.dart';
import 'package:week8/model/timer_model.dart';

final modelProvider = StateNotifierProvider<DiceListNotifier, DiceList>((ref) {
return DiceListNotifier();
});

final timerModelProvider = StateNotifierProvider<TimerModelNotifier, TimerModel>((ref) {
  return TimerModelNotifier(ref);
});