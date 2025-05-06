import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/algorithm_result.dart';

class SortingProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _inicio = 10;
  int _fim = 1000;
  int _passo = 10;

  int get inicio => _inicio;
  int get fim => _fim;
  int get passo => _passo;

  List<AlgorithmResult> _results = [];
  List<AlgorithmResult> get results => _results;

  void setParameters(dynamic inicio, dynamic fim, dynamic passo) {
    _inicio = inicio;
    _fim = fim;
    _passo = passo;
    notifyListeners();
  }

  Future<void> runAnalysis() async {
    _isLoading = true;
    notifyListeners();

    // Executar análise em um isolate para não bloquear a UI
    _results = await compute(_runSortingAnalysis, {
      'inicio': _inicio,
      'fim': _fim,
      'passo': _passo,
    });

    _isLoading = false;
    notifyListeners();
  }

  // Métodos auxiliares para criar arrays
  static List<int> _criarArrayAleatorio(int n) {
    final random = Random();
    return List.generate(n, (_) => random.nextInt(101));
  }

  static List<int> _criarArrayOrdenado(int n) {
    return List.generate(n, (i) => i);
  }

  static List<int> _criarArrayOrdenadoReverso(int n) {
    return List.generate(n, (i) => n - i - 1);
  }
}

// Função para executar em um isolate
List<AlgorithmResult> _runSortingAnalysis(Map<String, int> params) {
  final inicio = params['inicio']!;
  final fim = params['fim']!;
  final passo = params['passo']!;

  // Resultados para cada algoritmo
  final bubbleResult = AlgorithmResult(name: 'Bubble Sort', data: {});

  final selectionResult = AlgorithmResult(name: 'Selection Sort', data: {});

  final insertionResult = AlgorithmResult(name: 'Insertion Sort', data: {});

  final quickResult = AlgorithmResult(name: 'Quick Sort', data: {});

  // Executar algoritmos para cada tamanho de array
  for (int n = inicio; n < fim; n += passo) {
    // Bubble Sort
    var arrayAleatorio = SortingProvider._criarArrayAleatorio(n);
    var resultAleatorio = _bubbleSort(List.from(arrayAleatorio));

    var arrayOrdenado = SortingProvider._criarArrayOrdenado(n);
    var resultOrdenado = _bubbleSort(List.from(arrayOrdenado));

    var arrayReverso = SortingProvider._criarArrayOrdenadoReverso(n);
    var resultReverso = _bubbleSort(List.from(arrayReverso));

    bubbleResult.data[n] = {
      'aleatorio': {
        'comparacoes': resultAleatorio[0],
        'trocas': resultAleatorio[1],
      },
      'ordenado': {
        'comparacoes': resultOrdenado[0],
        'trocas': resultOrdenado[1],
      },
      'reverso': {'comparacoes': resultReverso[0], 'trocas': resultReverso[1]},
    };

    // Selection Sort
    arrayAleatorio = SortingProvider._criarArrayAleatorio(n);
    resultAleatorio = _selectionSort(List.from(arrayAleatorio));

    arrayOrdenado = SortingProvider._criarArrayOrdenado(n);
    resultOrdenado = _selectionSort(List.from(arrayOrdenado));

    arrayReverso = SortingProvider._criarArrayOrdenadoReverso(n);
    resultReverso = _selectionSort(List.from(arrayReverso));

    selectionResult.data[n] = {
      'aleatorio': {
        'comparacoes': resultAleatorio[0],
        'trocas': resultAleatorio[1],
      },
      'ordenado': {
        'comparacoes': resultOrdenado[0],
        'trocas': resultOrdenado[1],
      },
      'reverso': {'comparacoes': resultReverso[0], 'trocas': resultReverso[1]},
    };

    // Insertion Sort
    arrayAleatorio = SortingProvider._criarArrayAleatorio(n);
    resultAleatorio = _insertionSort(List.from(arrayAleatorio));

    arrayOrdenado = SortingProvider._criarArrayOrdenado(n);
    resultOrdenado = _insertionSort(List.from(arrayOrdenado));

    arrayReverso = SortingProvider._criarArrayOrdenadoReverso(n);
    resultReverso = _insertionSort(List.from(arrayReverso));

    insertionResult.data[n] = {
      'aleatorio': {
        'comparacoes': resultAleatorio[0],
        'trocas': resultAleatorio[1],
      },
      'ordenado': {
        'comparacoes': resultOrdenado[0],
        'trocas': resultOrdenado[1],
      },
      'reverso': {'comparacoes': resultReverso[0], 'trocas': resultReverso[1]},
    };

    // Quick Sort
    arrayAleatorio = SortingProvider._criarArrayAleatorio(n);
    resultAleatorio = _quickSort(List.from(arrayAleatorio));

    arrayOrdenado = SortingProvider._criarArrayOrdenado(n); 
    resultOrdenado = _quickSort(List.from(arrayOrdenado));

    arrayReverso = SortingProvider._criarArrayOrdenadoReverso(n);
    resultReverso = _quickSort(List.from(arrayReverso));

    quickResult.data[n] = {
      'aleatorio': {
        'comparacoes': resultAleatorio[0],
        'trocas': resultAleatorio[1],
      },
      'ordenado': {
        'comparacoes': resultOrdenado[0],
        'trocas': resultOrdenado[1],
      },
      'reverso': {'comparacoes': resultReverso[0], 'trocas': resultReverso[1]},
    };
  }

  return [bubbleResult, selectionResult, insertionResult, quickResult];
}

// Implementações dos algoritmos de ordenação

// Bubble Sort
List<int> _bubbleSort(List<int> array) {
  int comparacoes = 0;
  int trocas = 0;

  for (int i = array.length - 1; i > 0; i--) {
    bool trocaFeita = false;
    for (int j = 0; j < i; j++) {
      comparacoes++;
      if (array[j] > array[j + 1]) {
        // Troca
        int temp = array[j];
        array[j] = array[j + 1];
        array[j + 1] = temp;
        trocas++;
        trocaFeita = true;
      }
    }
    if (!trocaFeita) break;
  }

  return [comparacoes, trocas];
}

// Selection Sort
List<int> _selectionSort(List<int> array) {
  int comparacoes = 0;
  int trocas = 0;
  int n = array.length;

  for (int i = 0; i < n; i++) {
    int posicaoMenor = i;

    for (int j = i + 1; j < n; j++) {
      comparacoes++;
      if (array[j] < array[posicaoMenor]) {
        posicaoMenor = j;
      }
    }

    if (posicaoMenor != i) {
      // Troca
      int temp = array[i];
      array[i] = array[posicaoMenor];
      array[posicaoMenor] = temp;
      trocas++;
    }
  }

  return [comparacoes, trocas];
}

// Insertion Sort
List<int> _insertionSort(List<int> array) {
  int comparacoes = 0;
  int trocas = 0;

  for (int i = 1; i < array.length; i++) {
    int j = i;
    while (j > 0) {
      comparacoes++;
      if (array[j] < array[j - 1]) {
        // Troca
        int temp = array[j];
        array[j] = array[j - 1];
        array[j - 1] = temp;
        trocas++;
      } else {
        break;
      }
      j--;
    }
  }

  return [comparacoes, trocas];
}

// Quick Sort
List<int> _quickSort(List<int> array) {
  int comparacoes = 0;
  int trocas = 0;

  int particao(List<int> array, int inicio, int fim, int pivo) {
    // Troca o pivô com o último elemento
    int temp = array[pivo];
    array[pivo] = array[fim];
    array[fim] = temp;

    int valorPivo = array[fim];
    int i = inicio;

    for (int j = inicio; j < fim; j++) {
      comparacoes++;
      if (array[j] <= valorPivo) {
        // Troca
        temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        trocas++;
        i++;
      }
    }

    // Coloca o pivô na posição correta
    temp = array[i];
    array[i] = array[fim];
    array[fim] = temp;

    return i;
  }

  int escolherPivo(List<int> array, int inicio, int fim) {
    return (inicio + fim) ~/ 2;
  }

  void quickSortRecursivo(List<int> array, int inicio, int fim) {
    if (inicio < fim) {
      int pivo = escolherPivo(array, inicio, fim);
      int p = particao(array, inicio, fim, pivo);
      quickSortRecursivo(array, inicio, p - 1);
      quickSortRecursivo(array, p + 1, fim);
    }
  }

  quickSortRecursivo(array, 0, array.length - 1);
  return [comparacoes, trocas];
}
