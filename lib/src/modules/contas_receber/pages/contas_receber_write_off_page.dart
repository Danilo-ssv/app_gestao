import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:app_gestao/src/modules/contas_receber/state/contas_receber_state.dart';
import 'package:provider/provider.dart';

class ContasReceberWriteOffPage extends StatefulWidget {
  final String id;
  final Function onSave;
  const ContasReceberWriteOffPage({super.key, required this.id, required this.onSave});

  @override
  State<ContasReceberWriteOffPage> createState() => _ContasReceberWriteOffPageState();
}

class _ContasReceberWriteOffPageState extends State<ContasReceberWriteOffPage> {
  final _dataBaixaController = TextEditingController();
  final _descontoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dataBaixaController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  void insert() async {
    final dataBaixa = _dataBaixaController.text.split('/');

    final res = await context.read<ContasReceberState>().writeOff(
          context,
          widget.id,
          dataBaixa.length != 3 ? '' : '${dataBaixa[2]}-${dataBaixa[1]}-${dataBaixa[0]}',
          _descontoController.text.replaceAll('.', '').replaceAll(',', '.'),
        );

    if (res) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dar Baixa'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => insert(),
        label: const Row(
          children: [
            Text('Dar Baixa'),
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
                    controller: _dataBaixaController,
                    decoration: const InputDecoration(
                      label: Text('Data de Baixa'),
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
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _descontoController,
                    decoration: const InputDecoration(
                      label: Text('Desconto'),
                      prefixText: 'R\$ ',
                    ),
                    onChanged: (value) {
                      _descontoController.text = CurrencyFormatterFunction.format(value);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
