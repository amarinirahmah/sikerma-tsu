import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardBarChart extends StatelessWidget {
  final Map<String, Map<String, int>> dataPerYear;

  const DashboardBarChart({super.key, required this.dataPerYear});

  @override
  Widget build(BuildContext context) {
    final years = dataPerYear.keys.toList();
    final mouValues =
        years.map((year) => dataPerYear[year]?['MoU'] ?? 0).toList();
    final pksValues =
        years.map((year) => dataPerYear[year]?['PKS'] ?? 0).toList();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistik MoU dan PKS per Tahun',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.6,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(mouValues + pksValues),
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          int index = value.toInt();
                          return Text(
                            index >= 0 && index < years.length
                                ? years[index]
                                : '',
                          );
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(years.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: mouValues[index].toDouble(),
                          width: 12,
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: pksValues[index].toDouble(),
                          width: 12,
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                      barsSpace: 6,
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                _LegendItem(color: Colors.teal, label: 'MoU'),
                SizedBox(width: 16),
                _LegendItem(color: Colors.orange, label: 'PKS'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(List<int> values) {
    int max = values.reduce((a, b) => a > b ? a : b);
    return (max + 2).toDouble();
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
