import 'dart:math';

const int minDie = 1;
const int maxDie = 6;

const int possibleOutcomesCount = maxDie - minDie + 1;

class Dice {

  bool equalDistr = true;
  List<int> die = List<int>.generate(2, (_) => -1);
  
  int numberOfThrows = 0;

  // in case of dice 1 to 6 this list would start at 2 and go to 12
  List<int> sumStatistics = List<int>.generate(possibleOutcomesCount * 2 - 1, (_) => 0);
  List<List<int>> dieStatistics = List<List<int>>.generate(
      possibleOutcomesCount, (_) => List<int>.generate(possibleOutcomesCount, (_) => 0));

  void throwDice() {
    var rng = Random();

    if (!equalDistr) {
      die[0] = minDie + rng.nextInt(possibleOutcomesCount);
      die[1] = minDie + rng.nextInt(possibleOutcomesCount);

    } else {

      var numberTotal = minDie*2 + rng.nextInt(maxDie*2 - minDie*2 + 1);
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
      die = possibleCombinations[chosenCombinationIndex];
    }

    numberOfThrows++;

    var sum = die.reduce((value, element) => value + element);
    sumStatistics[sum - minDie - 1] += 1;

    dieStatistics[die[0] - minDie][die[1] - minDie] += 1;

  }

  void resetStatistics() {
    numberOfThrows = 0;
    sumStatistics = List<int>.generate(possibleOutcomesCount * 2 - 1, (_) => 0);
    dieStatistics = List<List<int>>.generate(
        possibleOutcomesCount, (_) => List<int>.generate(possibleOutcomesCount, (_) => 0));
  }

}