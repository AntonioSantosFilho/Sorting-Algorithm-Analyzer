import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sorting_provider.dart';
import 'chart_view.dart';

class ResultsTabs extends StatefulWidget {
  const ResultsTabs({super.key});

  @override
  State<ResultsTabs> createState() => _ResultsTabsState();
}

class _ResultsTabsState extends State<ResultsTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedMetric = 'comparacoes';
  String _selectedArrayType = 'aleatorio';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SortingProvider>(context);
    final results = provider.results;

    return Column(
      children: [
        // Filtros
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Seleção de métrica
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Métrica',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedMetric,
                  items: const [
                    DropdownMenuItem(
                      value: 'comparacoes',
                      child: Text('Comparações'),
                    ),
                    DropdownMenuItem(value: 'trocas', child: Text('Trocas')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMetric = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Seleção de tipo de array
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Array',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedArrayType,
                  items: const [
                    DropdownMenuItem(
                      value: 'aleatorio',
                      child: Text('Aleatório'),
                    ),
                    DropdownMenuItem(
                      value: 'ordenado',
                      child: Text('Ordenado'),
                    ),
                    DropdownMenuItem(value: 'reverso', child: Text('Reverso')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedArrayType = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // Tabs
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Comparativo'),
            Tab(text: 'Por Algoritmo'),
            Tab(text: 'Dados'),
          ],
        ),

        // Conteúdo das tabs
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Comparativo entre algoritmos
              ChartView(
                title:
                    'Comparativo de Algoritmos - ${_selectedMetric == 'comparacoes' ? 'Comparações' : 'Trocas'} - ${_getArrayTypeLabel()}',
                results: results,
                metric: _selectedMetric,
                arrayType: _selectedArrayType,
                compareAlgorithms: true,
                fixedHeight: 200,
              ),

              // Tab 2: Comparativo por algoritmo
              SingleChildScrollView(
                child: Column(
                  children:
                      results.map((result) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ChartView(
                            title:
                                '${result.name} - ${_selectedMetric == 'comparacoes' ? 'Comparações' : 'Trocas'}',
                            results: [result],
                            metric: _selectedMetric,
                            compareArrayTypes: true,
                            fixedHeight:
                                300, // Definir uma altura fixa para o gráfico
                          ),
                        );
                      }).toList(),
                ),
              ),

              // Tab 3: Dados em tabela
              _buildDataTable(results),
            ],
          ),
        ),
      ],
    );
  }

  String _getArrayTypeLabel() {
    switch (_selectedArrayType) {
      case 'aleatorio':
        return 'Array Aleatório';
      case 'ordenado':
        return 'Array Ordenado';
      case 'reverso':
        return 'Array Reverso';
      default:
        return '';
    }
  }

  Widget _buildDataTable(List<dynamic> results) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados Numéricos - ${_selectedMetric == 'comparacoes' ? 'Comparações' : 'Trocas'} - ${_getArrayTypeLabel()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Tamanho (n)')),
                  ...results
                      .map((result) => DataColumn(label: Text(result.name)))
                      .toList(),
                ],
                rows: _buildDataRows(results),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows(List<dynamic> results) {
    final rows = <DataRow>[];
    final sizes = results.first.data.keys.toList()..sort();

    for (final n in sizes) {
      final cells = <DataCell>[];

      // Tamanho do array
      cells.add(DataCell(Text('$n')));

      // Valores para cada algoritmo
      for (final result in results) {
        final value = result.data[n]![_selectedArrayType]![_selectedMetric];
        cells.add(DataCell(Text('$value')));
      }

      rows.add(DataRow(cells: cells));
    }

    return rows;
  }
}
