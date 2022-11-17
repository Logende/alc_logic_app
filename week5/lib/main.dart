import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_heatmap/fl_heatmap.dart';
import 'dice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice App Felix',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dice Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
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
                  value: dice.dieStatistics[row][col].toDouble() / highestValue.toDouble() * 6.4,
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
