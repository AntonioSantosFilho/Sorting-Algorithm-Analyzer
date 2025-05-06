import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sorting_provider.dart';
import '../widgets/parameters_form.dart';
import '../widgets/results_tabs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SortingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Algoritmos de Ordenação'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          // Formulário de parâmetros
          const ParametersForm(),

          // Botão para executar análise
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed:
                  provider.isLoading ? null : () => provider.runAnalysis(),
              icon:
                  provider.isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.play_arrow),
              label: Text(
                provider.isLoading ? 'Processando...' : 'Executar Análise',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),

          // Resultados
          if (provider.isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Executando análise...\nIsso pode levar alguns segundos.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else if (provider.results.isNotEmpty)
            const Expanded(child: ResultsTabs())
          else
            const Expanded(
              child: Center(
                child: Text(
                  'Configure os parâmetros e clique em "Executar Análise" para visualizar os resultados.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
