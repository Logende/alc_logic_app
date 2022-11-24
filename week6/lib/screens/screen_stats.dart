import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week6/heatmap/fl_heatmap.dart';
import 'package:week6/widgets/dice.dart';
import 'package:week6/widgets/die.dart';
import 'package:week6/widgets/heatmap_distribution.dart';
import 'package:week6/widgets/heatmap_individual_throws.dart';
import 'package:week6/widgets/info.dart';
import 'package:week6/widgets/info_throw_number.dart';

import '../model/dice.dart';

class ScreenStats extends ConsumerStatefulWidget {
   ScreenStats({super.key, required this.ref,
    required this.title, required this.modelProvider});


  final String title;
  final StateProvider<Dice> modelProvider;



  final WidgetRef ref;


  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenStatsState();
  }
}




class _ScreenStatsState extends ConsumerState<ScreenStats> {


  static _generateHeatmapResults(Dice dice) {
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
                  value: dice.sumStatistics[col].toDouble() / highestValue.toDouble() * 6.0,
                  unit: "unit",
                  xAxisLabel: columnsSimple[col],
                  yAxisLabel: ""),
        ]);
  }


  static _generateHeatmapIndividualThrows(Dice dice) {
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
                  value: dice.dieStatistics[row][col].toDouble() / highestValue.toDouble() * 6,
                  unit: "unit",
                  xAxisLabel: columns[col],
                  yAxisLabel: rows[row]),
        ]);
  }
     HeatmapData _heatmapResults = _generateHeatmapResults(Dice());
     HeatmapData _heatmapIndividualThrows = _generateHeatmapIndividualThrows(Dice());


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            InfoWidget(ref: ref, modelProvider: widget.modelProvider),

            HeatmapDistributionWidget(ref: ref, modelProvider: widget.modelProvider),
            HeatmapIndividualThrowsWidget(ref: ref, modelProvider: widget.modelProvider),


          ],
        ),
      ),

    );
  }
   }

