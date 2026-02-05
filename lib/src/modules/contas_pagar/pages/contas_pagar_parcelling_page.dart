import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_gestao/src/modules/contas_pagar/state/contas_pagar_state.dart';
import 'package:provider/provider.dart';

enum Frequencia { $1, $7, $30, $45, $90, $180, $365 }

extension FrequenciaExtension on Frequencia {
  Frequencia formatToEnum(String value) => Frequencia.values.firstWhere(
        (e) => e.name == '\$$value',
        orElse: () => Frequencia.$1,
      );
  String formatToString() => name.split('\$').last;
}

class ContasPagarParcellingPage extends StatefulWidget {
  final String id;
  final Function onSave;
  const ContasPagarParcellingPage({super.key, required this.id, required this.onSave});

  @override
  State<ContasPagarParcellingPage> createState() => _ContasPagarParcellingPageState();
}

class _ContasPagarParcellingPageState extends State<ContasPagarParcellingPage> {
  final _parcelasController = TextEditingController();
  final _frequenciaController = TextEditingController(text: Frequencia.$30.formatToString());

  void insert() async {
    final res = await context.read<ContasPagarState>().parcelling(
          context,
          widget.id,
          int.tryParse(_parcelasController.text) ?? 1,
          int.tryParse(_frequenciaController.text) ?? 30,
        );

    if (res) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcelar'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => insert(),
        label: const Row(
          children: [
            Text('Parcelar'),
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
                    controller: _parcelasController,
                    decoration: const InputDecoration(
                      label: Text('Qt. Parcelas'),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                DropdownMenu(
                    menuHeight: 200,
                    width: MediaQuery.of(context).size.width / 2 - 15,
                    label: const Text('Frequência das Parcelas'),
                    initialSelection: _frequenciaController.text,
                    onSelected: (value) => _frequenciaController.text = value ?? Frequencia.$30.formatToString(),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: Frequencia.$1.formatToString(), label: 'Diária'),
                      DropdownMenuEntry(value: Frequencia.$7.formatToString(), label: 'Semanal'),
                      DropdownMenuEntry(value: Frequencia.$30.formatToString(), label: 'Mensal'),
                      DropdownMenuEntry(value: Frequencia.$45.formatToString(), label: '45 Dias'),
                      DropdownMenuEntry(value: Frequencia.$90.formatToString(), label: 'Trimestral'),
                      DropdownMenuEntry(value: Frequencia.$180.formatToString(), label: 'Semestral'),
                      DropdownMenuEntry(value: Frequencia.$365.formatToString(), label: 'Anual'),
                    ])
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
