import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Timer _createTimer(TimerModelNotifier notifier) {
  const dur = Duration(milliseconds: 100);
  return Timer.periodic(dur, (Timer timer) {
    notifier.addTime(0.1);
  });
}

TimerModel _createDefaultTimerModel() {
  return const TimerModel(timerValue: 0.0);
}

@immutable
class TimerModel {
  const TimerModel({this.timer, required this.timerValue});

  final Timer? timer;
  final double timerValue;

  TimerModel _copyWith({Timer? timer, double? timerValue}) {
    return TimerModel(
      timer: timer ?? this.timer,
      timerValue: timerValue ?? this.timerValue,
    );
  }

  TimerModel _addTime(double duration) {
    return _copyWith(timerValue: timerValue + duration);
  }

  TimerModel _resetTime(TimerModelNotifier notifier) {
    timer?.cancel();
    return _copyWith(timerValue: 0.0, timer: _createTimer(notifier));
  }

  TimerModel _stopTime() {
    timer?.cancel();
    return this;
  }

  TimerModel _continueTime(TimerModelNotifier notifier) {
    timer?.cancel();
    return _copyWith(timer: _createTimer(notifier));
  }
}

class TimerModelNotifier extends StateNotifier<TimerModel> {
  TimerModelNotifier(Ref ref) : super(_createDefaultTimerModel());

  addTime(double duration) {
    state = state._addTime(duration);
  }

  void resetTimer() {
    state = state._resetTime(this);
  }

  void stopTime() {
    state = state._stopTime();
  }

  void continueTime() {
    state = state._continueTime(this);
  }
}
