ANÁLISE DE ALGORITMOS DE ORDENAÇÃO
==================================

Um aplicativo Flutter para análise e visualização do desempenho de diferentes algoritmos de ordenação. Esta ferramenta permite comparar o número de comparações e trocas realizadas por algoritmos como Bubble Sort, Selection Sort, Insertion Sort e Quick Sort em diferentes cenários.

FUNCIONALIDADES
--------------

- Análise de 4 algoritmos de ordenação: Bubble Sort, Selection Sort, Insertion Sort e Quick Sort
- Configuração de parâmetros de análise (tamanho inicial, final e incremento)
- Visualização de resultados em gráficos interativos
- Comparação de desempenho entre diferentes algoritmos
- Análise de comportamento em 3 cenários: arrays aleatórios, ordenados e em ordem reversa
- Visualização de dados numéricos em tabelas

TECNOLOGIAS UTILIZADAS
---------------------

- Flutter (https://flutter.dev/)
- Provider para gerenciamento de estado
- FL Chart para visualização de gráficos

INSTALAÇÃO E EXECUÇÃO
--------------------

Pré-requisitos:
- Flutter SDK instalado
- Um editor de código (VS Code, Android Studio, etc.)
- Git

Passos para instalação:

1. Clone este repositório:
   git clone https://github.com/AntonioSantosFilho/Sorting-Algorithm-Analyzer.git

2. Navegue até o diretório do projeto:
   cd analise-algoritmos-ordenacao

3. Instale as dependências:
   flutter pub get

4. Execute o aplicativo:
   flutter run

COMO USAR
--------

1. Configure os parâmetros de análise:
   - Tamanho inicial do array
   - Tamanho final do array
   - Incremento (passo)

2. Clique em "Executar Análise" para iniciar o processamento

3. Visualize os resultados:
   - Na aba "Comparativo": compare o desempenho de todos os algoritmos
   - Na aba "Por Algoritmo": analise cada algoritmo individualmente
   - Na aba "Dados": visualize os resultados numéricos em formato de tabela

4. Filtre os resultados:
   - Selecione a métrica (Comparações ou Trocas)
   - Escolha o tipo de array (Aleatório, Ordenado ou Reverso)

ESTRUTURA DO PROJETO
-------------------

lib/
├── main.dart                  # Ponto de entrada do aplicativo
├── models/
│   └── algorithm_result.dart  # Modelo para armazenar resultados
├── providers/
│   └── sorting_provider.dart  # Gerenciamento de estado e lógica de ordenação
├── screens/
│   └── home_screen.dart       # Tela principal
└── widgets/
    ├── chart_view.dart        # Componente de visualização de gráficos
    ├── parameters_form.dart   # Formulário de parâmetros
    └── results_tabs.dart      # Abas de resultados

ALGORITMOS IMPLEMENTADOS
-----------------------

Bubble Sort:
- Complexidade de tempo: O(n²) no pior caso
- Implementação com otimização para interromper quando nenhuma troca é realizada

Selection Sort:
- Complexidade de tempo: O(n²) em todos os casos
- Encontra o menor elemento e o coloca na posição correta

Insertion Sort:
- Complexidade de tempo: O(n²) no pior caso, O(n) no melhor caso
- Eficiente para pequenos conjuntos de dados ou arrays quase ordenados

Quick Sort:
- Complexidade de tempo: O(n log n) no caso médio, O(n²) no pior caso
- Implementação com pivô escolhido como o elemento do meio

CONTRIBUIÇÕES
------------

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

1. Faça um fork do projeto
2. Crie uma branch para sua feature (git checkout -b feature/nova-feature)
3. Commit suas mudanças (git commit -m 'Adiciona nova feature')
4. Push para a branch (git push origin feature/nova-feature)
5. Abra um Pull Request

LICENÇA
------

Este projeto está licenciado sob a MIT License.