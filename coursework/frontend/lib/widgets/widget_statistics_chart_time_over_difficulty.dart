import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers.dart';

// copied and modified from https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/line_chart/samples/line_chart_sample9.dart#L102
class LineChartTimeOverDifficulty extends ConsumerStatefulWidget {
  const LineChartTimeOverDifficulty({super.key, required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      LineChartTimeOverDifficultyState();
}

class LineChartTimeOverDifficultyState
    extends ConsumerState<LineChartTimeOverDifficulty> {
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userStats = ref.watch(userStatisticsProvider);
    var maxDifficulty = userStats.tasksStatistics.values.fold(
        0,
        (previousValue, element) => previousValue < element.task.complexity
            ? element.task.complexity
            : previousValue);
    var difficulties = List<int>.generate(maxDifficulty + 1, (i) => i);

    var attempts = <int, int>{};
    var totalTimeNeeded = <int, double>{};

    for (var difficulty in difficulties) {
      attempts[difficulty] = 0;
      totalTimeNeeded[difficulty] = 0;
    }
    for (var element in userStats.tasksStatistics.values) {
      var complexity = element.task.complexity;

      attempts[complexity] = attempts[complexity]! + element.attempts;
      totalTimeNeeded[complexity] =
          totalTimeNeeded[complexity]! + element.totalTimeNeeded;
    }

    final spots = List.generate(
        maxDifficulty + 1,
        (i) => FlSpot(
            i.toDouble(), totalTimeNeeded[i]! / attempts[i]!.toDouble()));

    return Padding(
      padding: const EdgeInsets.only(right: 22, bottom: 20),
      child: SizedBox(
        width: 400,
        height: 300,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                maxContentWidth: 100,
                tooltipBgColor: Colors.orange,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    final textStyle = TextStyle(
                      color: touchedSpot.bar.gradient?.colors[0] ??
                          touchedSpot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    );
                    return LineTooltipItem(
                      '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                      textStyle,
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
              getTouchLineStart: (data, index) => 0,
            ),
            lineBarsData: [
              LineChartBarData(
                color: Theme.of(context).primaryColor,
                spots: spots,
                isCurved: true,
                isStrokeCapRound: true,
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: false,
                ),
                dotData: FlDotData(show: false),
              ),
            ],
            minY: 0,
            maxY: 1.5,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 56,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitleWidgets,
                  reservedSize: 36,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: true,
              horizontalInterval: 1.5,
              verticalInterval: 5,
              checkToShowHorizontalLine: (value) {
                return value.toInt() == 0;
              },
              checkToShowVerticalLine: (value) {
                return value.toInt() == 0;
              },
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
