import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:app_gestao/src/modules/vendas/state/vendas_state.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:app_gestao/src/shared/components/modals/insert_clientes_modal.dart';
import 'package:provider/provider.dart';

class FinalizeVendasPage extends StatefulWidget {
  final String id;
  final Function onSave;
  const FinalizeVendasPage({super.key, required this.id, required this.onSave});

  @override
  State<FinalizeVendasPage> createState() => _FinalizeVendasPageState();
}

class _FinalizeVendasPageState extends State<FinalizeVendasPage> {
  final _idClientesController = TextEditingController();
  final _nomeClientesController = TextEditingController();
  final _descontoController = TextEditingController();
  final _acrescimoController = TextEditingController();
  final _dataVencimentoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dataVencimentoController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    if (widget.id.isNotEmpty) {
      readById();
    }
  }

  void readById() async {
    final res = await context.read<VendasState>().readForFinalize(
          context,
          widget.id,
        );

    setState(() {
      _idClientesController.text = res.idClientes ?? '';
      _nomeClientesController.text = res.nomeClientes ?? '';
    });
  }

  void insert() async {
    final dataVencimento = _dataVencimentoController.text.split('/');

    final res = await context.read<VendasState>().finalize(
          context,
          widget.id,
          _idClientesController.text,
          _descontoController.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '').replaceAll(' ', ''),
          _acrescimoController.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '').replaceAll(' ', ''),
          dataVencimento.length != 3 ? '' : '${dataVencimento[2]}-${dataVencimento[1]}-${dataVencimento[0]}',
        );

    if (res) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Venda'),
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
                  child: SearchAnchor(
                    builder: (context, controller) {
                      return TextField(
                        controller: _nomeClientesController,
                        decoration: InputDecoration(
                          label: const Text('Cliente'),
                          suffixIcon: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => InsertClientesModal(
                                  onSave: (id, nome) {
                                    _idClientesController.text = id;
                                    _nomeClientesController.text = nome;
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          controller.openView();
                        },
                      );
                    },
                    suggestionsBuilder: (context, controller) async {
                      final search = controller.text;

                      final res = await context.read<GlobalProvider>().readClientes(context, search);

                      return (res ?? [])
                          .map(
                            (e) => ListTile(
                              onTap: () {
                                _idClientesController.text = e.id;
                                _nomeClientesController.text = e.nome;
                                controller.closeView('');
                              },
                              leading: const Icon(Icons.people),
                              title: Text(e.nome),
                              subtitle: Text('#${e.id}'),
                            ),
                          )
                          .toList();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _dataVencimentoController,
                    decoration: const InputDecoration(
                      label: Text('Data de Vencimento'),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final dataVencimento = _dataVencimentoController.text.split('/');

                      final DateTime? time = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                        initialDate: dataVencimento.length == 3
                            ? DateTime.tryParse('${dataVencimento[2]}-${dataVencimento[1]}-${dataVencimento[0]}')
                            : DateTime.now(),
                      );

                      if (mounted && time != null) {
                        _dataVencimentoController.text = DateFormat('dd/MM/yyyy').format(time);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
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
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _acrescimoController,
                    decoration: const InputDecoration(
                      label: Text('Acréscimo'),
                      prefixText: 'R\$ ',
                    ),
                    onChanged: (value) {
                      _acrescimoController.text = CurrencyFormatterFunction.format(value);
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
