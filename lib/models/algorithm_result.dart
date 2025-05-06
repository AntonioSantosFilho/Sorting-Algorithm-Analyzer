class AlgorithmResult {
  final String name;
  final Map<dynamic, Map<dynamic, Map<dynamic, dynamic>>> data;

  AlgorithmResult({required this.name, required this.data});

  // Método para obter dados formatados para gráficos
  Map<String, List<Map<dynamic, dynamic>>> getChartData() {
    Map<String, List<Map<dynamic, dynamic>>> chartData = {
      'comparacoes_aleatorio': [],
      'comparacoes_ordenado': [],
      'comparacoes_reverso': [],
      'trocas_aleatorio': [],
      'trocas_ordenado': [],
      'trocas_reverso': [],
    };

    data.forEach((n, values) {
      chartData['comparacoes_aleatorio']!.add({
        'x': n.toDouble(),
        'y': values['aleatorio']!['comparacoes']!.toDouble(),
      });
      chartData['comparacoes_ordenado']!.add({
        'x': n.toDouble(),
        'y': values['ordenado']!['comparacoes']!.toDouble(),
      });
      chartData['comparacoes_reverso']!.add({
        'x': n.toDouble(),
        'y': values['reverso']!['comparacoes']!.toDouble(),
      });
      chartData['trocas_aleatorio']!.add({
        'x': n.toDouble(),
        'y': values['aleatorio']!['trocas']!.toDouble(),
      });
      chartData['trocas_ordenado']!.add({
        'x': n.toDouble(),
        'y': values['ordenado']!['trocas']!.toDouble(),
      });
      chartData['trocas_reverso']!.add({
        'x': n.toDouble(),
        'y': values['reverso']!['trocas']!.toDouble(),
      });
    });

    // Ordenar por tamanho do array (x)
    chartData.forEach((key, list) {
      list.sort((a, b) => a['x'].compareTo(b['x']));
    });

    return chartData;
  }
}
