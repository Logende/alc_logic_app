import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/model/dice.dart';



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
    return _addDiceState(list.last.throwDice(throwCount));
  }

  DiceList _setEqualDistribution(bool equalDistr) {
    if (equalDistr != list.last.equalDistr) {
      return _addDiceState(list.last.setEqualDistribution(equalDistr));
    } else {
      return this;
    }
  }

  DiceList _resetStatistics() {
    return _addDiceState(list.last.resetStatistics());
  }

  DiceList _addDiceState(Dice newDice) {
    list.add(newDice);
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




}

class DiceListNotifier extends StateNotifier<DiceList> {
  DiceListNotifier(): super( createDefaultDiceListState() );

  void throwDice(int throwCount) {
    state = state._throwDice(throwCount);
  }

  Dice currentDice() {
    return state.currentDice();
  }

  void setEqualDistribution(bool equalDistr) {
    state = state._setEqualDistribution(equalDistr);
  }

  void resetStatistics() {
    state = state._resetStatistics();
  }

  void undo() {
    state = state._undo();
  }

  void redo() {
    state = state._redo();
  }

  bool isUndoPossible() {
    return state.isUndoPossible();
  }

  bool isRedoPossible() {
    return state.isRedoPossible();
  }


}
