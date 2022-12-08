import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:week8/helpers.dart';

const int minDie = 1;
const int maxDie = 6;

const int possibleOutcomesCount = maxDie - minDie + 1;


Dice createDefaultDiceState() {
  const bool equalDistr = true;
  final List<int> die = List<int>.generate(2, (_) => -1);
  const int numberOfThrows = 0;
  // in case of dice 1 to 6 this list would start at 2 and go to 12
  final List<int> sumStatistics = List<int>.generate(possibleOutcomesCount * 2 - 1, (_) => 0);
  final List<List<int>> dieStatistics = List<List<int>>.generate(
      possibleOutcomesCount, (_) => List<int>.generate(possibleOutcomesCount, (_) => 0));
  return Dice(equalDistr: equalDistr, die: die, numberOfThrows: numberOfThrows,
      sumStatistics: sumStatistics, dieStatistics: dieStatistics);
}

@immutable
class Dice {
  const Dice({required this.equalDistr, required this.die,
    required this.numberOfThrows, required this.sumStatistics,
    required this.dieStatistics});

  final bool equalDistr;
  final List<int> die;
  final int numberOfThrows;

  // in case of dice 1 to 6 this list would start at 2 and go to 12
  final List<int> sumStatistics;
  final List<List<int>> dieStatistics;


  Dice.fromMap(Map<String, dynamic> json)
      : equalDistr = json['equalDistr'],
        die = mapListDynamicToListInt(json['die']),
        numberOfThrows = json['numberOfThrows'],
        sumStatistics = mapListDynamicToListInt(json['sumStatistics']),
        dieStatistics = map2dListDynamicToListIntInt(json['dieStatistics']);

  Map<String, dynamic> toMap() => {
    'equalDistr': equalDistr,
    'die': die,
    'numberOfThrows': numberOfThrows,
    'sumStatistics': sumStatistics,
    'dieStatistics': dieStatistics,
  };



  Dice copyWith({bool? equalDistr, List<int>? die, int? numberOfThrows,
    List<int>? sumStatistics, List<List<int>>? dieStatistics}) {
    return Dice(
      equalDistr: equalDistr ?? this.equalDistr,
      die: die ?? this.die,
      numberOfThrows: numberOfThrows ?? this.numberOfThrows,
      sumStatistics: sumStatistics ?? this.sumStatistics,
      dieStatistics: dieStatistics ?? this.dieStatistics,
    );
  }

  Dice throwDice(int throwCount) {
    var rng = Random();

    List<int> newDie = List<int>.from(die);
    List<List<int>> newDieStatistics = [for (var sublist in dieStatistics) [...sublist]];
    List<int> newSumStatistics = List<int>.from(sumStatistics);
    int newNumberOfThrows = numberOfThrows;

    for (int i = 0; i < throwCount; i++) {

      if (!equalDistr) {
        newDie = [minDie + rng.nextInt(possibleOutcomesCount),
          minDie + rng.nextInt(possibleOutcomesCount)];
      } else {
        var numberTotal = minDie * 2 + rng.nextInt(maxDie * 2 - minDie * 2 + 1);
        // This will go over all combinations and collect relevant ones
        List<List<int>> possibleCombinations = [];
        for (var number1 = minDie; number1 <= maxDie; number1++) {
          for (var number2 = minDie; number2 <= maxDie; number2++) {
            if (number1 + number2 == numberTotal) {
              possibleCombinations.add([number1, number2]);
            }
          }
        }
        var chosenCombinationIndex = rng.nextInt(possibleCombinations.length);
        newDie = possibleCombinations[chosenCombinationIndex];
      }


      var sum = newDie.reduce((value, element) => value + element);
      newSumStatistics[sum - minDie - 1] += 1;

      newDieStatistics[newDie[0] - minDie][newDie[1] - minDie] += 1;

      newNumberOfThrows++;
    }

    return copyWith(die: newDie, numberOfThrows: newNumberOfThrows,
        sumStatistics: newSumStatistics, dieStatistics: newDieStatistics);
  }


  // not sure here if it wouldn't be better to just return the given object
  // because it is immutable anyways in case of no change in value
  Dice setEqualDistribution(bool equalDistr) {
    return copyWith(equalDistr: equalDistr);
  }

  Dice resetStatistics() {
    return createDefaultDiceState();
  }


}