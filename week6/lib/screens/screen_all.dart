import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/dice.dart';
import '../heatmap/heatmap.dart';
import '../heatmap/heatmap_data.dart';

class ScreenAll extends ConsumerStatefulWidget {
  const ScreenAll({super.key, required this.title});


  final String title;

  @override
  ConsumerState<ScreenAll> createState() => _ScreenAllState();
}


class _ScreenAllState extends ConsumerState<ScreenAll> {
  final Dice _dice = Dice();
  bool _equalDistribution = false;


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



  void _throwDice() {
    setState(() {
      _updateInput();
      _dice.throwDice();
      _updateOutput();
    });
  }


  void _attemptReset() {
    final snackBar = SnackBar(
      content: const Text('Reset Statistics?'),
      action: SnackBarAction(
        label: 'Reset',
        onPressed: () {
          _reset();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void _reset() {
    setState(() {
      _dice.die[0] = 1;
      _dice.die[1] = 1;
      _dice.resetStatistics();
      _updateOutput();
    });
  }


  void _manyThrows() {
    setState(() {
      _updateInput();
      for(var i = 0 ; i < 1000; i++) {
        _dice.throwDice();
      }
      _updateOutput();
    });
  }

  void _updateOutput() {
    _heatmapResults = _generateHeatmapResults(_dice);
    _heatmapIndividualThrows = _generateHeatmapIndividualThrows(_dice);
  }

  void _updateInput() {
    _dice.equalDistr = _equalDistribution;
  }


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
            Wrap(
              spacing: 10.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                  ),
                  child: Text(
                    '${_dice.die[0]}',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                  ),
                  child: Text(
                    '${_dice.die[1]}',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ],
            ),

            const Text(
              'Count of throws:',
            ),
            Text(
              '${_dice.numberOfThrows}',
              style: Theme.of(context).textTheme.headline4,
            ),

            const Text(
              'Equal distribution:',
            ),
            CupertinoSwitch(
              value: _equalDistribution,
              onChanged: (value) {
                setState(() {
                  _equalDistribution = value;
                });
              },
            ),

            TextButton(onPressed: _attemptReset, child: const Text('Reset')),

            TextButton(onPressed: _manyThrows, child: const Text('1000 Throws')),

            SizedBox(
              width: 300,
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  const Text("Result Distribution", textScaleFactor: 1.4),
                  // Text("${_dice.sumStatistics.toString()}", textScaleFactor: 1.4),
                  const SizedBox(height: 8),
                  Heatmap(
                      heatmapData: _heatmapResults)
                ],
              ),
            ),

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
                      heatmapData: _heatmapIndividualThrows),
                ),
              ],
            ),




          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _throwDice,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}