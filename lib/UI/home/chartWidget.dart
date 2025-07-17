import 'package:finance/core/models/monthlyChart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartRekening extends StatelessWidget {
  final List<MonthlyChart> monthlyData;

  const ChartRekening({
    super.key,
    required this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(child: Text('Tidak ada data')),
      );
    }

    final double maxY = monthlyData
        .map((e) => e.amount.toDouble())
        .fold(0, (prev, curr) => curr > prev ? curr : prev);

    double interval;
    if (maxY <= 1_000_000) {
      interval = 200_000;
    } else if (maxY <= 5_000_000) {
      interval = 1_000_000;
    } else if (maxY <= 10_000_000) {
      interval = 2_000_000;
    } else {
      interval = 5_000_000;
    }

    final double adjustedMaxY = (maxY / interval).ceil() * interval;

    return SizedBox(
      height: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: adjustedMaxY,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final int index = value.toInt();
                    if (index >= 0 && index < monthlyData.length) {
                      return Transform.rotate(
                        angle: -0.6, // sekitar -34 derajat
                        child: Text(
                          monthlyData[index].month,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: interval,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      'Rp ${(value / 1_000_000).toStringAsFixed(0)}jt',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Colors.white,
                barWidth: 2,
                spots: monthlyData.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    entry.value.amount.toDouble(),
                  );
                }).toList(),
                dotData: FlDotData(show: false),
              ),
            ],
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
