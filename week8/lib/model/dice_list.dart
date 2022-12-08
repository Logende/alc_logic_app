import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week8/data_persistence_handler.dart';
import 'package:week8/model/dice.dart';



DiceList createDefaultDiceListState() {
  final List<Dice> list = [ createDefaultDiceState() ];
  return DiceList(list: list, current: 0, redoMax: 0);
}


@immutable
class DiceList {

  const DiceList({required this.list, required this.current,
    required this.redoMax});

  final int current;
  final int redoMax;
  final List<Dice> list;


  Dice currentDice() {
    return list[current];
  }


  DiceList _copyWith({List<Dice>? list, int? current, int? redoMax}) {
    return DiceList(
      list: list ?? this.list,
      current: current ?? this.current,
      redoMax: redoMax ?? this.redoMax
    );
  }

  DiceList _throwDice(int throwCount) {
    return _addDiceState(currentDice().throwDice(throwCount));
  }

  DiceList _setEqualDistribution(bool equalDistr) {
    if (equalDistr != currentDice().equalDistr) {
      return _addDiceState(currentDice().setEqualDistribution(equalDistr));
    } else {
      return this;
    }
  }

  DiceList _resetStatistics() {
    return _addDiceState(currentDice().resetStatistics());
  }


  DiceList _addDiceState(Dice newDice) {
    if (list.length > current + 1) {
      list[current + 1] = newDice;
    } else {
      list.add(newDice);
    }
    return _copyWith(list: list, current: current +1 , redoMax: 0);
  }

  DiceList _undo() {
    if (!isUndoPossible()) {
      throw Exception("Error: tried undo but impossible.");
    }
    return _copyWith(current: current - 1, redoMax: redoMax + 1);
  }

  DiceList _redo() {
    if (!isRedoPossible()) {
      throw Exception("Error: tried redo but impossible.");
    }
    return _copyWith(current: current + 1, redoMax: redoMax - 1);
  }

  bool isUndoPossible() {
    return current > 0;
  }

  bool isRedoPossible() {
    return redoMax > 0;
  }


  DiceList _overwriteState(Dice dice) {
    list[current] = dice;
    return this;
  }


}

class DiceListNotifier extends StateNotifier<DiceList> {
  DiceListNotifier(): super( createDefaultDiceListState() );

  void throwDice(int throwCount) {
    state = state._throwDice(throwCount);
    persistState(currentDice());
  }

  Dice currentDice() {
    return state.currentDice();
  }

  void setEqualDistribution(bool equalDistr) {
    state = state._setEqualDistribution(equalDistr);
  }

  void resetStatistics() {
    state = state._resetStatistics();
    persistState(currentDice());
  }

  void undo() {
    state = state._undo();
    persistState(currentDice());
  }

  void redo() {
    state = state._redo();
    persistState(currentDice());
  }

  bool isUndoPossible() {
    return state.isUndoPossible();
  }

  bool isRedoPossible() {
    return state.isRedoPossible();
  }


  void initState(Dice dice) {
    state = state._overwriteState(dice);
  }


}
