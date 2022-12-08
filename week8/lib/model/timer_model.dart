
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week8/providers.dart';


Timer _createTimer(WidgetRef ref) {
  const dur = Duration(milliseconds: 100);
  return Timer.periodic(
      dur,
          (Timer timer) {
        var notifier = ref.watch(timerModelProvider.notifier);
        notifier.addTime(0.1);
      });
}

TimerModel _createDefaultTimerModel() {
  return const TimerModel(timerValue: 0.0, lastDelta: -1, maxDelta: -1,
      minDelta: -1.0);
}

@immutable
class TimerModel {

  const TimerModel({this.timer, required this.timerValue,
    required this.lastDelta, required this.maxDelta, required this.minDelta});

  final Timer? timer;
  final double timerValue;

  final double lastDelta;
  final double maxDelta;
  final double minDelta;


  TimerModel _copyWith({Timer? timer, double? timerValue, double? lastDelta,
    double? maxDelta, double? minDelta}) {
    return TimerModel(
      timer: timer ?? this.timer,
      timerValue: timerValue ?? this.timerValue,
      lastDelta: lastDelta ?? this.lastDelta,
      maxDelta: maxDelta ?? this.maxDelta,
      minDelta: minDelta ?? this.minDelta,
    );
  }

  TimerModel _addTime(double duration) {
    return _copyWith(timerValue: timerValue + duration);
  }

  TimerModel _resetTime(WidgetRef ref) {
    // because -1 would always stay the min: special case
    double minDelta = (this.minDelta == -1.0 ? double.maxFinite : this.minDelta);
    return _copyWith(timerValue: 0.0, timer: _createTimer(ref),
        lastDelta: timerValue, maxDelta: max(timerValue, maxDelta),
        minDelta: min(timerValue, minDelta));
  }

}


class TimerModelNotifier extends StateNotifier<TimerModel> {
  TimerModelNotifier(Ref ref) : super(_createDefaultTimerModel());


  addTime(double duration) {
    state = state._addTime(duration);
  }


  void resetTimer(WidgetRef ref) {

    // destroy old timer if new one exists
    // note that I now see that I would not even have to create a new timer
    // every time the timer is reset
    state.timer?.cancel();
    state = state._resetTime(ref);
  }


}
