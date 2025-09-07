import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';
import 'dart:math';

import '../../../../../global.dart';
import '../../../../../utils/time_formatter.dart';
import '../../../../widgets/divider_widget.dart';

class HomeFocusStatus extends StatelessWidget {
  const HomeFocusStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return appWidget.focus.focusManage(({
      required isFocused,
      required getTotal,
      required getHoursInWeekly,
      required toggle
    }) {
        final color = primaryColor(context);

        return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Chế độ tập trung --------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Chế độ tập trung',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Switch.adaptive(
                            value: isFocused,
                            onChanged: (changed) {
                              toggle();
                            },
                            activeColor: color,
                          )
                        ],
                      ),


                      const SizedBox(height: 12),
                      const WdgDivider(color: Colors.grey, height: 0.3, width: 200),

                      /// Thống kê trong tuần -----------------------------------------------
                      const SizedBox(height: 12),

                      const Text(
                        'Tuần này',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Column(
                            children: [
                              Icon(Icons.access_time, size: 32, color: iconColor(context)),
                              const SizedBox(height: 6),
                              Text(TimeFormatterUtil.fomathhmm(getTotal())),
                            ],
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                              child: _WeeklyLearningChart(hoursPerDay: getHoursInWeekly())
                          )
                        ],
                      ),
                    ],
                  )
        );
      }
    );
  }
}

class _WeeklyLearningChart extends StatelessWidget {
  final List<double> hoursPerDay;

  const _WeeklyLearningChart({required this.hoursPerDay});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    final maxValue = hoursPerDay.reduce(max);
    final maxY = _calculateMaxY(maxValue);

    return SizedBox(
      height: 120,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY.toDouble(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) => Text(_dayLabel(value.toInt())),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5,
                getTitlesWidget: (value, _) {
                  if (value % 5 == 0 || value <= 1) {
                    return Text('${value.toInt()}h', style: const TextStyle(fontSize: 10));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final y = touchedSpot.y;
                  final totalMinutes = (y * 60).round();
                  final hours = totalMinutes ~/ 60;
                  final minutes = totalMinutes % 60;

                  final label = '${hours}h ${minutes.toString().padLeft(2, '0')}m';

                  return LineTooltipItem(
                    label,
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),

          gridData: FlGridData(
            show: true,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.withAlpha(20), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                hoursPerDay.length,
                    (i) => FlSpot(i.toDouble(), hoursPerDay[i]),
              ),
              isCurved: true,
              color: color,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: color.withAlpha(20),
              ),
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  String _dayLabel(int index) {
    const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    if (index >= 0 && index < days.length) return days[index];
    return '';
  }

  int _calculateMaxY(double maxValue) {
    if (maxValue < 1) return 1;
    if (maxValue < 5) return 5;
    int rounded = ((maxValue / 5).ceil()) * 5;
    return min(rounded, 24);
  }
}
