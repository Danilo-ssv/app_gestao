import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:app_gestao/src/modules/contas_receber/models/insert_contas_receber_model.dart';
import 'package:app_gestao/src/modules/contas_receber/state/contas_receber_state.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:app_gestao/src/shared/components/modals/insert_clientes_modal.dart';
import 'package:provider/provider.dart';

class InsertContasReceberPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  const InsertContasReceberPage({super.key, required this.id, required this.clone, required this.onSave});

  @override
  State<InsertContasReceberPage> createState() => _InsertContasReceberPageState();
}

class _InsertContasReceberPageState extends State<InsertContasReceberPage> {
  String _id = '';

  final _idClientesController = TextEditingController(text: '0');
  final _nomeClientesController = TextEditingController(text: 'Selecione um Cliente');
  final _dataEmissaoController = TextEditingController();
  final _dataVencimentoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dataEmissaoController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _dataVencimentoController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    if (widget.id.isNotEmpty) {
      readById();
    }
  }

  void readById() async {
    final res = await context.read<ContasReceberState>().readById(
          context,
          widget.id,
        );

    setState(() {
      _id = widget.clone ? '' : (res?.id ?? '');
      _idClientesController.text = res?.idClientes ?? '';
      _nomeClientesController.text = res?.nomeClientes ?? '';
      _dataEmissaoController.text = res?.dataEmissao ?? '';
      _dataVencimentoController.text = res?.dataVencimento ?? '';
      _descricaoController.text = res?.descricao ?? '';
      _valorController.text = res?.valor ?? '';
    });
  }

  void insert() async {
    if (_idClientesController.text.isEmpty) {
      showErrorMessage(context, message: 'Selecione algum Cliente!', success: false);
      return;
    }

    if (_valorController.text.isEmpty) {
      showErrorMessage(context, message: 'Valor é Obrigatório!', success: false);
      return;
    }

    final dataEmissao = _dataEmissaoController.text.split('/');
    final dataVencimento = _dataVencimentoController.text.split('/');

    final res = await context.read<ContasReceberState>().insert(
          context,
          InsertContasReceberModel(
            id: _id,
            idClientes: _idClientesController.text,
            nomeClientes: '',
            dataEmissao: dataEmissao.length != 3 ? '' : '${dataEmissao[2]}-${dataEmissao[1]}-${dataEmissao[0]}',
            dataVencimento: dataVencimento.length != 3 ? '' : '${dataVencimento[2]}-${dataVencimento[1]}-${dataVencimento[0]}',
            descricao: _descricaoController.text,
            valor: _valorController.text.replaceAll('.', '').replaceAll(',', '.'),
          ),
        );

    if (res) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Conta a Receber'),
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
                          suffixIcon: _idClientesController.text == '0'
                              ? IconButton(
                                  onPressed: () => controller.openView(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _idClientesController.text = '0';
                                      _nomeClientesController.text = 'Selecione um Cliente';
                                      controller.clear();
                                    });
                                  },
                                  icon: const Tooltip(
                                    message: 'Limpar campo de Cliente!',
                                    child: Icon(Icons.delete_outline),
                                  ),
                                ),
                        ),
                        readOnly: true,
                        onTap: () => controller.openView(),
                      );
                    },
                    suggestionsBuilder: (context, controller) async {
                      final search = controller.text;

                      final res = await context.read<GlobalProvider>().readClientes(context, search);

                      return [
                        if (search == '') ...[
                          ListTile(
                            onTap: () {
                              _idClientesController.text = '0';
                              _nomeClientesController.text = 'Selecione um Cliente';
                              controller.closeView('');
                            },
                            leading: const SizedBox(),
                            title: const Text('Selecione um Cliente', maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                        ...(res ?? []).map(
                          (e) => ListTile(
                            onTap: () {
                              _idClientesController.text = e.id;
                              _nomeClientesController.text = e.nome;
                              controller.closeView(e.nome);
                            },
                            leading: const Icon(Icons.people_alt_outlined),
                            title: Text(e.nome),
                            subtitle: Text('#${e.id}'),
                          ),
                        ),
                      ];
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: 'Inserir novo Cliente!',
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
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
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          child: Icon(Icons.add, size: 26, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 150,
                    controller: _descricaoController,
                    decoration: const InputDecoration(
                      label: Text('Descrição'),
                      counterText: '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dataEmissaoController,
                    decoration: const InputDecoration(
                      label: Text('Data de Emissão'),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final dataEmissao = _dataEmissaoController.text.split('/');

                      final DateTime? time = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                        initialDate:
                            dataEmissao.length == 3 ? DateTime.tryParse('${dataEmissao[2]}-${dataEmissao[1]}-${dataEmissao[0]}') : DateTime.now(),
                      );

                      if (mounted && time != null) {
                        _dataEmissaoController.text = DateFormat('dd/MM/yyyy').format(time);
                      }
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
                    controller: _valorController,
                    decoration: const InputDecoration(
                      label: Text('Valor'),
                      prefixText: 'R\$ ',
                    ),
                    onChanged: (value) {
                      _valorController.text = CurrencyFormatterFunction.format(value);
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
