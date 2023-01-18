import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers.dart';

import '../models/model_user_statistics_aggregated.dart';

// copied and modified from https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/line_chart/samples/line_chart_sample9.dart#L102
class LineChartTimeOverDifficulty extends ConsumerStatefulWidget {
  const LineChartTimeOverDifficulty({super.key, required this.ref, required this.stats});

  final WidgetRef ref;
  final UserStatisticsAggregated stats;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      LineChartTimeOverDifficultyState();
}

class LineChartTimeOverDifficultyState
    extends ConsumerState<LineChartTimeOverDifficulty> {
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = Theme.of(context).textTheme.caption;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = Theme.of(context).textTheme.caption;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    var stats = widget.stats;

    final spots = List.generate(
        stats.difficulties.length,
        (i) => FlSpot(
            i.toDouble(), stats.totalTimeNeeded[i]! / stats.attempts[i]!.toDouble()));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'Time per Task by task complexity [s]',
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 350,
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
      ],
    );
  }
}
