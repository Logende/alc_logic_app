import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/model_user_statistics_aggregated.dart';
import 'package:frontend/providers.dart';

// copied and modified from https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/bar_chart/samples/bar_chart_sample2.dart
class BarChartSuccessOverDifficulty extends ConsumerStatefulWidget {
  const BarChartSuccessOverDifficulty({super.key, required this.ref, required this.stats});

  final WidgetRef ref;
  final UserStatisticsAggregated stats;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      BarChartSuccessOverDifficultyState();
}

class BarChartSuccessOverDifficultyState
    extends ConsumerState<BarChartSuccessOverDifficulty> {


  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  late int maxValue;

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    var stats = widget.stats;
    final items = List.of(stats.difficulties.map((e) =>
        makeGroupData(e, stats.successes[e]!.toDouble(), stats.failures[e]!.toDouble())));

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;

    maxValue = max(stats.attempts.values.reduce(max), stats.failures.values.reduce(max));

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Right/Wrong by task complexity [#]',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: maxValue.toDouble() - 1.0,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    var style = Theme.of(context).textTheme.caption;
    String text;
    if (value == 0) {
      text = '1';
    } else if (value == maxValue - 1) {
      text = maxValue.toString();
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    var userStats = ref.watch(userStatisticsProvider);
    var maxDifficulty = userStats.tasksStatistics.values.fold(
        0,
        (previousValue, element) => previousValue < element.task.complexity
            ? element.task.complexity
            : previousValue);
    var difficulties = List<int>.generate(maxDifficulty + 1, (i) => i);
    final titles = List.of(difficulties.map((e) => e.toString()));

    final Widget text = Text(
      titles[value.toInt()],
      style: Theme.of(context).textTheme.caption
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.green,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: Theme.of(context).colorScheme.error,
          width: width,
        ),
      ],
    );
  }
}
