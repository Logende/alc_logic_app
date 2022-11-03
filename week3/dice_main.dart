import 'dice.dart';
import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addOption('throws', abbr: 'n');
  final argResults = parser.parse(arguments);

  int n = int.parse(argResults['throws']);
  var dice = Dice();
  dice.equalDistr = false;
  throwDicesAndPrintStatistics(dice, n);

  dice.resetStatistics();
  dice.equalDistr = true;
  throwDicesAndPrintStatistics(dice, n);
}

void throwDicesAndPrintStatistics(Dice dice, int n) {
  for (var i = 0; i <= n; i++) {
    dice.throwDice();
  }

  print("sumStatistics: ${dice.sumStatistics}");
}
