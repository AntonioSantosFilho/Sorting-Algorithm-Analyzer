import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/sorting_provider.dart';

class ParametersForm extends StatefulWidget {
  const ParametersForm({super.key});

  @override
  State<ParametersForm> createState() => _ParametersFormState();
}

class _ParametersFormState extends State<ParametersForm> {
  final _formKey = GlobalKey<FormState>();
  final _inicioController = TextEditingController();
  final _fimController = TextEditingController();
  final _passoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SortingProvider>(context, listen: false);
    _inicioController.text = provider.inicio.toString();
    _fimController.text = provider.fim.toString();
    _passoController.text = provider.passo.toString();
  }

  @override
  void dispose() {
    _inicioController.dispose();
    _fimController.dispose();
    _passoController.dispose();
    super.dispose();
  }

  void _saveParameters() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<SortingProvider>(context, listen: false);
      provider.setParameters(
        int.parse(_inicioController.text),
        int.parse(_fimController.text),
        int.parse(_passoController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parâmetros atualizados'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ExpansionTile(
            title: const Text(
              'Parâmetros da Análise',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _inicioController,
                            decoration: const InputDecoration(
                              labelText: 'Início',
                              border: OutlineInputBorder(),
                              helperText: 'Tamanho mínimo',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Obrigatório';
                              }
                              final inicio = int.tryParse(value);
                              if (inicio == null || inicio <= 0) {
                                return 'Valor inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _fimController,
                            decoration: const InputDecoration(
                              labelText: 'Fim',
                              border: OutlineInputBorder(),
                              helperText: 'Tamanho máximo',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Obrigatório';
                              }
                              final fim = int.tryParse(value);
                              if (fim == null || fim <= 0) {
                                return 'Valor inválido';
                              }
                              final inicio =
                                  int.tryParse(_inicioController.text) ?? 0;
                              if (fim <= inicio) {
                                return 'Deve ser > início';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _passoController,
                            decoration: const InputDecoration(
                              labelText: 'Passo',
                              border: OutlineInputBorder(),
                              helperText: 'Incremento',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Obrigatório';
                              }
                              final passo = int.tryParse(value);
                              if (passo == null || passo <= 0) {
                                return 'Valor inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _saveParameters,
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar Parâmetros'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
