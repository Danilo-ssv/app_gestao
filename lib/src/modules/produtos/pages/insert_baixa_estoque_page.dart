import 'package:app_gestao/src/modules/produtos/state/produtos_state.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InsertBaixaEstoquePage extends StatefulWidget {
  final String id;
  final Function onSave;
  const InsertBaixaEstoquePage({super.key, required this.id, required this.onSave});

  @override
  State<InsertBaixaEstoquePage> createState() => _InsertBaixaEstoquePageState();
}

class _InsertBaixaEstoquePageState extends State<InsertBaixaEstoquePage> {
  final _estoqueController = TextEditingController();
  final _dataBaixaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dataBaixaController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  void insert() async {
    if (_estoqueController.text.isEmpty) {
      showErrorMessage(context, message: 'Estoque é Obrigatório!', success: false);
      return;
    }

    final dataBaixa = _dataBaixaController.text.split('/');

    final res = await context.read<ProdutosState>().insertBaixaEstoque(
          context,
          widget.id,
          int.tryParse(_estoqueController.text) ?? 0,
          dataBaixa.length != 3 ? '' : '${dataBaixa[2]}-${dataBaixa[1]}-${dataBaixa[0]}',
        );

    if (res) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baixa do Estoque'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => insert(),
        label: const Row(
          children: [
            Text('Salvar'),
            SizedBox(width: 10),
            Icon(Icons.check),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _estoqueController,
                    decoration: const InputDecoration(
                      label: Text('Estoque'),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _dataBaixaController,
                    decoration: const InputDecoration(
                      label: Text('Data Baixa'),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final dataBaixa = _dataBaixaController.text.split('/');

                      final DateTime? time = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                        initialDate: dataBaixa.length == 3 ? DateTime.tryParse('${dataBaixa[2]}-${dataBaixa[1]}-${dataBaixa[0]}') : DateTime.now(),
                      );

                      if (mounted && time != null) {
                        _dataBaixaController.text = DateFormat('dd/MM/yyyy').format(time);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
