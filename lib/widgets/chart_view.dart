import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/algorithm_result.dart';

class ChartView extends StatelessWidget {
  final String title;
  final List<dynamic> results;
  final String metric;
  final String arrayType;
  final bool compareAlgorithms;
  final bool compareArrayTypes;
  final double? fixedHeight; // Adicionando parâmetro de altura fixa opcional

  const ChartView({
    super.key,
    required this.title,
    required this.results,
    this.metric = 'comparacoes',
    this.arrayType = 'aleatorio',
    this.compareAlgorithms = false,
    this.compareArrayTypes = false,
    this.fixedHeight, // Novo parâmetro
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Usar Container com altura fixa se fornecida, caso contrário usar Expanded
            fixedHeight != null
                ? Container(height: fixedHeight, child: _buildChart())
                : Expanded(child: _buildChart()),
            const SizedBox(height: 8),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _calculateYInterval(),
          verticalInterval: _calculateXInterval(),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _calculateXInterval(),
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  //         axisSide: meta.axisSide,
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _calculateYInterval(),
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  //        fitInside: meta.axisSide,
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: _getMinX(),
        maxX: _getMaxX(),
        minY: 0,
        maxY: _getMaxY() * 1.1, // 10% de margem
        lineBarsData: _getLineBarsData(),
      ),
    );
  }

  List<LineChartBarData> _getLineBarsData() {
    final List<LineChartBarData> lineBars = [];

    // Cores para os gráficos
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    if (compareAlgorithms) {
      // Comparar algoritmos para um tipo de array
      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        final chartData = result.getChartData();
        final dataKey = '${metric}_$arrayType';

        final spots = <FlSpot>[];
        for (final point in chartData[dataKey]!) {
          spots.add(FlSpot(point['x'], point['y']));
        }

        lineBars.add(
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: colors[i % colors.length],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        );
      }
    } else if (compareArrayTypes) {
      // Comparar tipos de array para um algoritmo
      final result = results.first;
      final chartData = result.getChartData();

      final arrayTypes = ['aleatorio', 'ordenado', 'reverso'];

      for (int i = 0; i < arrayTypes.length; i++) {
        final type = arrayTypes[i];
        final dataKey = '${metric}_$type';

        final spots = <FlSpot>[];
        for (final point in chartData[dataKey]!) {
          spots.add(FlSpot(point['x'], point['y']));
        }

        lineBars.add(
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: colors[i % colors.length],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        );
      }
    }

    return lineBars;
  }

  Widget _buildLegend() {
    final List<Widget> legendItems = [];

    // Cores para os gráficos
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    if (compareAlgorithms) {
      // Legenda para comparação de algoritmos
      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        legendItems.add(
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: colors[i % colors.length],
                ),
                const SizedBox(width: 4),
                Text(result.name),
              ],
            ),
          ),
        );
      }
    } else if (compareArrayTypes) {
      // Legenda para comparação de tipos de array
      final arrayTypes = [
        {'key': 'aleatorio', 'label': 'Aleatório'},
        {'key': 'ordenado', 'label': 'Ordenado'},
        {'key': 'reverso', 'label': 'Reverso'},
      ];

      for (int i = 0; i < arrayTypes.length; i++) {
        final type = arrayTypes[i];
        legendItems.add(
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: colors[i % colors.length],
                ),
                const SizedBox(width: 4),
                Text(type['label'] as String),
              ],
            ),
          ),
        );
      }
    }

    return Wrap(children: legendItems);
  }

  double _getMinX() {
    if (results.isEmpty) return 0;

    double minX = double.infinity;

    for (final result in results) {
      final sizes = result.data.keys.toList();
      if (sizes.isNotEmpty) {
        final min = sizes.reduce((a, b) => a < b ? a : b).toDouble();
        if (min < minX) minX = min;
      }
    }

    return minX == double.infinity ? 0 : minX;
  }

  double _getMaxX() {
    if (results.isEmpty) return 100;

    double maxX = 0;

    for (final result in results) {
      final sizes = result.data.keys.toList();
      if (sizes.isNotEmpty) {
        final max = sizes.reduce((a, b) => a > b ? a : b).toDouble();
        if (max > maxX) maxX = max;
      }
    }

    return maxX;
  }

  double _getMaxY() {
    if (results.isEmpty) return 100;

    double maxY = 0;

    if (compareAlgorithms) {
      // Máximo para um tipo de array entre todos os algoritmos
      for (final result in results) {
        for (final n in result.data.keys) {
          final value = result.data[n]![arrayType]![metric]!.toDouble();
          if (value > maxY) maxY = value;
        }
      }
    } else if (compareArrayTypes) {
      // Máximo para todos os tipos de array de um algoritmo
      final result = results.first;
      final arrayTypes = ['aleatorio', 'ordenado', 'reverso'];

      for (final type in arrayTypes) {
        for (final n in result.data.keys) {
          final value = result.data[n]![type]![metric]!.toDouble();
          if (value > maxY) maxY = value;
        }
      }
    }

    return maxY;
  }

  double _calculateXInterval() {
    final minX = _getMinX();
    final maxX = _getMaxX();
    final range = maxX - minX;

    if (range <= 100) return 10;
    if (range <= 500) return 50;
    if (range <= 1000) return 100;
    return range / 10;
  }

  double _calculateYInterval() {
    final maxY = _getMaxY();

    if (maxY <= 100) return 10;
    if (maxY <= 1000) return 100;
    if (maxY <= 10000) return 1000;
    return maxY / 10;
  }
}
