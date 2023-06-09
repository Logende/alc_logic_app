import 'dart:math';
import 'package:fl_heatmap/fl_heatmap.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:week6/screens/screen_detailed_sum.dart';

import '../model/dice.dart';

class HeatmapDistributionWidget extends ConsumerStatefulWidget {


  const HeatmapDistributionWidget({super.key, required this.ref,
    required this.modelProvider});


  final StateProvider<Dice> modelProvider;
  final WidgetRef ref;


  @override
  ConsumerState<HeatmapDistributionWidget> createState() => HeatmapDistributionState();
  
}


class HeatmapDistributionState extends ConsumerState<HeatmapDistributionWidget> {

  @override
  Widget build(BuildContext context) {
    Dice dice = ref.watch(widget.modelProvider);
    return
      SizedBox(
        width: 300,
        child: Column(
          children: [
            const SizedBox(height: 14),
            const Text("Result Distribution", textScaleFactor: 1.4),
            // Text("${_dice.sumStatistics.toString()}", textScaleFactor: 1.4),
            const SizedBox(height: 8),
            Heatmap(
                onItemSelectedListener: (HeatmapItem? selectedItem) {
                  setState(() {
                    if (selectedItem != null) {
                      int sum = int.parse(selectedItem.xAxisLabel!.trim());
                      dice.die[0] = sum ~/ 2;
                      dice.die[1] = (sum ~/ 2) + sum % 2;
                      debugPrint("dice 1 ${dice.die[0]} dice 2 ${dice.die[1]}");
                      context.go(ScreenDetailedSum.routeLocation);
                    }
                  });
                  debugPrint(
                      'Item ${selectedItem?.yAxisLabel}/${selectedItem?.xAxisLabel} with value ${selectedItem?.value} selected');

                },
                heatmapData: _generateHeatmapData(dice))
          ],
        ),
      );
  }



  static _generateHeatmapData(Dice dice) {
    var colorPalette = List<Color>.generate(255, (index) =>
        Color.fromARGB(255, 255 - index, index, 0));
    var columnCount = dice.sumStatistics.length;
    var columnsSimple = List<String>.generate(columnCount, (i) => (i + 2).toString());
    var highestValue = dice.sumStatistics.reduce(max);
    return HeatmapData(rows: ['',],
        colorPalette: colorPalette,
        columns: columnsSimple,
        items: [
          for (int row = 0; row < 1; row++)
            for (int col = 0; col < columnCount; col++)
              HeatmapItem(
                  value: dice.sumStatistics[col].toDouble() / highestValue.toDouble(),
                  unit: "unit",
                  xAxisLabel: columnsSimple[col],
                  yAxisLabel: ""),
        ]);
  }

  StateProvider<int> getValueProviderDice1() {
    return StateProvider((ref) => ref.watch(widget.modelProvider).die[0]);
  }
  StateProvider<int> getValueProviderDice2() {
    return StateProvider((ref) => ref.watch(widget.modelProvider).die[1]);
  }

}