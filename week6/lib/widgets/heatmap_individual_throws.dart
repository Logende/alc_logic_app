import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_heatmap/fl_heatmap.dart';

import '../model/dice.dart';

class HeatmapIndividualThrowsWidget extends ConsumerStatefulWidget {


  const HeatmapIndividualThrowsWidget({super.key, required this.ref,
    required this.modelProvider});


  final StateProvider<Dice> modelProvider;
  final WidgetRef ref;


  @override
  ConsumerState<HeatmapIndividualThrowsWidget> createState() => HeatmapIndividualThrowsState();
  
}


class HeatmapIndividualThrowsState extends ConsumerState<HeatmapIndividualThrowsWidget> {

  @override
  Widget build(BuildContext context) {
    Dice dice = ref.watch(widget.modelProvider);
    return
      Column(
        children: [
          const SizedBox(height: 14),
          const Text("Individual Dice Distribution", textScaleFactor: 1.4),
          // Text("h ${_dice.dieStatistics.expand((element) => element).toList().reduce((max))} and ${_dice.dieStatistics.toString()}", textScaleFactor: 1.4),
          const SizedBox(height: 8),


          Container(
            width: 150,
            child: Heatmap(
                onItemSelectedListener: (HeatmapItem? selectedItem) {
                  debugPrint(
                      'Item ${selectedItem?.yAxisLabel}/${selectedItem?.xAxisLabel} with value ${selectedItem?.value} selected');

                },
                heatmapData: _generateHeatmapData(dice)),
          ),
        ],
      );
  }



  static _generateHeatmapData(Dice dice) {
    var colorPalette = List<Color>.generate(255, (index) =>
        Color.fromARGB(255, 255 - index, index, 0));
    var columnCount = dice.dieStatistics.length;
    var rowCount = dice.dieStatistics[0].length;
    var columns = List<String>.generate(columnCount, (i) => (i + 1).toString());
    var rows = List<String>.generate(rowCount, (i) => (i + 1).toString());
    var highestValue = dice.dieStatistics.expand((element) => element).toList().reduce((max));
    return HeatmapData(rows: rows,
        colorPalette: colorPalette,
        columns: columns,
        items: [
          for (int row = 0; row < rowCount; row++)
            for (int col = 0; col < columnCount; col++)
              HeatmapItem(
                  value: dice.dieStatistics[row][col].toDouble() / highestValue.toDouble(),
                  unit: "unit",
                  xAxisLabel: columns[col],
                  yAxisLabel: rows[row]),
        ]);
  }

  StateProvider<int> getValueProviderDice1() {
    return StateProvider((ref) => ref.watch(widget.modelProvider).die[0]);
  }
  StateProvider<int> getValueProviderDice2() {
    return StateProvider((ref) => ref.watch(widget.modelProvider).die[1]);
  }

}