import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:app_gestao/src/modules/contas_pagar/models/insert_contas_pagar_model.dart';
import 'package:app_gestao/src/modules/contas_pagar/state/contas_pagar_state.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:app_gestao/src/shared/components/modals/insert_despesas_modal.dart';
import 'package:app_gestao/src/shared/components/modals/insert_fornecedores_modal.dart';
import 'package:provider/provider.dart';

class InsertContasPagarPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  const InsertContasPagarPage({super.key, required this.id, required this.clone, required this.onSave});

  @override
  State<InsertContasPagarPage> createState() => _InsertContasPagarPageState();
}

class _InsertContasPagarPageState extends State<InsertContasPagarPage> {
  String _id = '';

  final _idFornecedoresController = TextEditingController(text: '0');
  final _nomeFornecedoresController = TextEditingController(text: 'Selecione um Fornecedor');
  final _dataEmissaoController = TextEditingController();
  final _dataVencimentoController = TextEditingController();
  final _idDespesasController = TextEditingController(text: '0');
  final _nomeDespesasController = TextEditingController(text: 'Selecione uma Despesa');
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
    final res = await context.read<ContasPagarState>().readById(
          context,
          widget.id,
        );

    setState(() {
      _id = widget.clone ? '' : (res?.id ?? '');
      _idFornecedoresController.text = res?.idFornecedores ?? '';
      _nomeFornecedoresController.text = res?.nomeFornecedores ?? '';
      _dataEmissaoController.text = res?.dataEmissao ?? '';
      _dataVencimentoController.text = res?.dataVencimento ?? '';
      _idDespesasController.text = res?.idDespesas ?? '';
      _nomeDespesasController.text = res?.nomeDespesas ?? '';
      _descricaoController.text = res?.descricao ?? '';
      _valorController.text = res?.valor ?? '';
    });
  }

  void insert() async {
    if (_idFornecedoresController.text.isEmpty) {
      showErrorMessage(context, message: 'Selecione algum Formecedor!', success: false);
      return;
    }

    if (_valorController.text.isEmpty) {
      showErrorMessage(context, message: 'Valor é Obrigatório!', success: false);
      return;
    }

    final dataEmissao = _dataEmissaoController.text.split('/');
    final dataVencimento = _dataVencimentoController.text.split('/');

    final res = await context.read<ContasPagarState>().insert(
          context,
          InsertContasPagarModel(
            id: _id,
            idFornecedores: _idFornecedoresController.text,
            nomeFornecedores: '',
            dataEmissao: dataEmissao.length != 3 ? '' : '${dataEmissao[2]}-${dataEmissao[1]}-${dataEmissao[0]}',
            dataVencimento: dataVencimento.length != 3 ? '' : '${dataVencimento[2]}-${dataVencimento[1]}-${dataVencimento[0]}',
            idDespesas: _idDespesasController.text,
            nomeDespesas: '',
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
        title: const Text('Inserir Conta a Pagar'),
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
                        controller: _nomeFornecedoresController,
                        decoration: InputDecoration(
                          label: const Text('Fornecedor'),
                          suffixIcon: _idFornecedoresController.text == '0'
                              ? IconButton(
                                  onPressed: () => controller.openView(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _idFornecedoresController.text = '0';
                                      _nomeFornecedoresController.text = 'Selecione um Fornecedor';
                                      controller.clear();
                                    });
                                  },
                                  icon: const Tooltip(
                                    message: 'Limpar campo de Fornecedor!',
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

                      final res = await context.read<GlobalProvider>().readFornecedores(context, search);

                      return [
                        if (search == '') ...[
                          ListTile(
                            onTap: () {
                              _idFornecedoresController.text = '0';
                              _nomeFornecedoresController.text = 'Selecione um Fornecedor';
                              controller.closeView('');
                            },
                            leading: const SizedBox(),
                            title: const Text('Selecione um Fornecedor', maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                        ...(res ?? []).map(
                          (e) => ListTile(
                            onTap: () {
                              _idFornecedoresController.text = e.id;
                              _nomeFornecedoresController.text = e.nome;
                              controller.closeView(e.nome);
                            },
                            leading: const Icon(Icons.person_2_outlined),
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
                  message: 'Inserir novo Fornecedor!',
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
                            builder: (context) => InsertFornecedoresModal(
                              onSave: (id, nome) {
                                _idFornecedoresController.text = id;
                                _nomeFornecedoresController.text = nome;
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
                  child: SearchAnchor(
                    builder: (context, controller) {
                      return TextField(
                        controller: _nomeDespesasController,
                        decoration: InputDecoration(
                          label: const Text('Despesa'),
                          suffixIcon: _idDespesasController.text == '0'
                              ? IconButton(
                                  onPressed: () => controller.openView(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _idDespesasController.text = '0';
                                      _nomeDespesasController.text = 'Selecione uma Despesa';
                                      controller.clear();
                                    });
                                  },
                                  icon: const Tooltip(
                                    message: 'Limpar campo de Despesa!',
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

                      final res = await context.read<GlobalProvider>().readDespesas(context, search);

                      return [
                        if (search == '') ...[
                          ListTile(
                            onTap: () {
                              _idDespesasController.text = '0';
                              _nomeDespesasController.text = 'Selecione uma Despesa';
                              controller.closeView('');
                            },
                            leading: const SizedBox(),
                            title: const Text('Selecione uma Despesa', maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                        ...(res ?? []).map(
                          (e) => ListTile(
                            onTap: () {
                              _idDespesasController.text = e.id;
                              _nomeDespesasController.text = e.nome;
                              controller.closeView(e.nome);
                            },
                            leading: const Icon(Icons.receipt_long),
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
                  message: 'Inserir nova Despesa!',
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
                            builder: (context) => InsertDespesasModal(
                              onSave: (id, nome) {
                                _idDespesasController.text = id;
                                _nomeDespesasController.text = nome;
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
